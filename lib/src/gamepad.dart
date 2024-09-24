import "dart:ffi";

import "package:ffi/ffi.dart";
import "package:sdl3/sdl3.dart" as sdl;

import "info.dart";
import "library.dart";
import "state.dart";
import "utils.dart";

/// A gamepad that is connected to the host device.
///
/// To open a gamepad:
/// - Use [SdlGamepad.fromGamepadIndex] with a gamepad ID
/// - Use [SdlGamepad.fromPlayerIndex] with a player ID
/// - Check [getConnectedGamepadIds] and use one with [SdlGamepad.fromGamepadIndex]
///
/// Before using any gamepad, be sure to call [SdlLibrary.init]. Otherwise, inputs may not register.
///
/// Once a gamepad is connected, it can be disconnected at any time. Always check [isConnected] to
/// have the latest info. The current state of the gamepad (which buttons are pressed) can be
/// queried at any time using [getState]. Once done with the gamepad, remember to call [close].
///
/// The gamepad ID and player ID are two distinct concepts which are explained in detail in
/// [SdlGamepad.fromGamepadIndex] and [SdlGamepad.fromPlayerIndex], but to summarize, a gamepad ID
/// is assigned when a gamepad is connected and does not change until the gamepad is disconnected.
/// A player ID is a unique ID per human user and represents the n-th input device.
class SdlGamepad {
  /// Gets a list of gamepad IDs for all currently connected gamepads.
  static List<int> getConnectedGamepadIds() => using((arena) {
        final lengthPointer = arena<Int32>();
        final array = sdl.SdlGamepadEx.gets(lengthPointer);
        final result = [
          for (var index = 0; index < lengthPointer.value; index++)
            array[index],
        ];
        sdl.sdlFree(array);
        return result;
      });

  static GamepadType _getType(int type) =>
      type == 0 ? GamepadType.unknown : GamepadType.fromValue(type);

  /// Gets associated info about the gamepad and its physical configuration.
  ///
  /// This returns less data than [getInfo] but does not require the gamepad to be opened.
  /// Specifically, the following are not available in this method:
  /// - [GamepadInfo.serial]
  /// - [GamepadInfo.steamHandle]
  /// - [GamepadInfo.properties]
  /// - [GamepadInfo.firmwareVersion]
  static GamepadInfo getInfoForGamepadId(int gamepadId) => GamepadInfo(
        guid: sdl.sdlGetGamepadGuidForId(gamepadId),
        name: sdl.sdlGetGamepadNameForId(gamepadId),
        path: sdl.sdlGetGamepadPathForId(gamepadId),
        serial: null,
        steamHandle: null,
        productId: sdl.sdlGetGamepadProductForId(gamepadId),
        productVersion: sdl.sdlGetGamepadProductVersionForId(gamepadId),
        properties: null,
        realType: _getType(sdl.sdlGetRealGamepadTypeForId(gamepadId)),
        type: _getType(sdl.sdlGetGamepadTypeForId(gamepadId)),
        vendor: sdl.sdlGetGamepadVendorForId(gamepadId),
        firmwareVersion: null,
      );

  /// A pointer to the gamepad object managed by SDL.
  ///
  /// You should not have to use this pointer directly as this package provides Dart-friendly
  /// alternatives, but you can use this pointer with `package:sdl3` for more low-level access.
  ///
  /// See [sdl.SdlGamepadEx] and [sdl.SdlGamepadPointerEx] for more details.
  final Pointer<sdl.SdlGamepad> sdlGamepad;

  /// Opens a gamepad assigned to the given player index.
  ///
  /// A player index is a number tracked by the OS that represents how many input devices are
  /// currently attached. That is, this number is *not* specific or unique to the gamepad and
  /// which gamepad will be opened depends on exactly how many gamepads are connected and in
  /// what order.
  ///
  /// See also: [SdlGamepad.fromGamepadIndex], which remains constant while the device is connected
  SdlGamepad.fromPlayerIndex(int index)
      : sdlGamepad = sdl.SdlGamepadEx.getFromPlayerIndex(index);

  /// Opens a gamepad of the given index.
  ///
  /// A gamepad index is a number that is assigned to the gamepad when it is connected. The exact
  /// value depends on the operating system, the exact amount of devices already connected, the
  /// order they were connected, and any other rules or heuristics given to the operating system.
  /// However, once this value is assigned, it is not changed and is therefore a good value to use
  /// for the duration of the gamepad's lifespan.
  ///
  /// See also:
  /// - [SdlGamepad.fromPlayerIndex], which chooses the n-th gamepad connected to the system
  /// - [Udev rules](https://opensource.com/article/18/11/udev), which can influence the assigned value.
  SdlGamepad.fromGamepadIndex(int index)
      : sdlGamepad = sdl.SdlGamepadEx.open(index);

  /// Re-uses an already-opened SDL3 gamepad pointer.
  ///
  /// To open a gamepad, use [SdlGamepad.fromPlayerIndex] or [SdlGamepad.fromGamepadIndex]. This is
  /// meant to be used in cases where you are working with SDL or `package:sdl3` and already have an
  /// opened gamepad and wish to use it with this package. This is never strictly necessary, since
  /// this package is just a wrapper around `package:sdl3`, but it could be convenient.
  SdlGamepad.fromPointer(this.sdlGamepad);

  /// Closes the gamepad and releases any resources used by this object.
  void close() => sdlGamepad.close();

  /// Whether this gamepad is connected.
  bool get isConnected => sdlGamepad.connected();

  /// Gets the current state of the gamepad and all the buttons that are pressed.
  GamepadState getState() => GamepadState(
        buttonA: sdlGamepad.getButton(sdl.SDL_GAMEPAD_BUTTON_SOUTH),
        buttonB: sdlGamepad.getButton(sdl.SDL_GAMEPAD_BUTTON_EAST),
        buttonX: sdlGamepad.getButton(sdl.SDL_GAMEPAD_BUTTON_WEST),
        buttonY: sdlGamepad.getButton(sdl.SDL_GAMEPAD_BUTTON_NORTH),
        buttonBack: sdlGamepad.getButton(sdl.SDL_GAMEPAD_BUTTON_BACK),
        buttonStart: sdlGamepad.getButton(sdl.SDL_GAMEPAD_BUTTON_START),
        dpadDown: sdlGamepad.getButton(sdl.SDL_GAMEPAD_BUTTON_DPAD_DOWN),
        dpadUp: sdlGamepad.getButton(sdl.SDL_GAMEPAD_BUTTON_DPAD_UP),
        dpadLeft: sdlGamepad.getButton(sdl.SDL_GAMEPAD_BUTTON_DPAD_LEFT),
        dpadRight: sdlGamepad.getButton(sdl.SDL_GAMEPAD_BUTTON_DPAD_RIGHT),
        leftShoulder:
            sdlGamepad.getButton(sdl.SDL_GAMEPAD_BUTTON_LEFT_SHOULDER),
        rightShoulder:
            sdlGamepad.getButton(sdl.SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER),
        leftTrigger: sdlGamepad.getAxis(sdl.SDL_GAMEPAD_AXIS_LEFT_TRIGGER),
        rightTrigger: sdlGamepad.getAxis(sdl.SDL_GAMEPAD_AXIS_RIGHT_TRIGGER),
        leftJoystickX: sdlGamepad.getAxis(sdl.SDL_GAMEPAD_AXIS_LEFTX),
        leftJoystickY: sdlGamepad.getAxis(sdl.SDL_GAMEPAD_AXIS_LEFTY),
        rightJoystickX: sdlGamepad.getAxis(sdl.SDL_GAMEPAD_AXIS_RIGHTX),
        rightJoystickY: sdlGamepad.getAxis(sdl.SDL_GAMEPAD_AXIS_RIGHTY),
      );

  /// Gets the gamepad ID of the gamepad. See [SdlGamepad.fromGamepadIndex] for details.
  int? get id => sdlGamepad.getId().nullIf(0);

  /// Gets the player ID of the gamepad. See [SdlGamepad.fromPlayerIndex] for details.
  int? get playerIndex => sdlGamepad.getPlayerIndex().nullIf(-1);

  /// Gets associated info about the gamepad and its physical configuration.
  ///
  /// This returns more data than [getInfoForGamepadId] but requires the gamepad to be connected.
  GamepadInfo getInfo() => GamepadInfo(
        guid: sdl.SdlGamepadEx.getGuidForId(id!),
        name: sdlGamepad.getName(),
        path: sdlGamepad.getPath(),
        serial: sdlGamepad.getSerial(),
        steamHandle: sdlGamepad.getSteamHandle().nullIf(0),
        productId: sdlGamepad.getProduct().nullIf(0),
        productVersion: sdlGamepad.getProductVersion().nullIf(0),
        properties: sdlGamepad.getProperties().nullIf(0),
        realType: _getType(sdlGamepad.getRealType()),
        type: _getType(sdlGamepad.getType()),
        vendor: sdlGamepad.getVendor().nullIf(0),
        firmwareVersion: sdlGamepad.getFirmwareVersion().nullIf(0),
      );
}
