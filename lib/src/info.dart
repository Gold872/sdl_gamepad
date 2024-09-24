import "package:sdl3/sdl3.dart";
import "package:collection/collection.dart";

export "package:sdl3/sdl3.dart" show SdlGuid;

/// Standard gamepad types.
///
/// This type does not necessarily map to first-party controllers from
/// Microsoft/Sony/Nintendo; in many cases, third-party controllers can report
/// as these, either because they were designed for a specific console, or they
/// simply most closely match that console's controllers (does it have A/B/X/Y
/// buttons or X/O/Square/Triangle? Does it have a touchpad? etc
enum GamepadType {
  /// The gamepad is unknown.
  unknown,
  /// A "standard" gamepad.
  standard,
  /// An Xbox 360 controller.
  xbox360,
  /// An Xbox One controller.
  xboxOne,
  /// A PS3 controller.
  xboxPs3,
  /// A PS4 controller.
  xboxPs4,
  /// A PS5 controller.
  xboxPs5,
  /// A Nintendo Switch Pro controller.
  nintendoSwitchPro,
  /// The left joy-con of a Nintendo Switch joy-con pair.
  nintendoSwitchJoyconLeft,
  /// The right joy-con of a Nintendo Switch joy-con pair.
  nintendoSwitchJoyconRight,
  /// A complete pair of Nintendo Switch joy-cons.
  nintendoSwitchJoyconPair;

  /// Returns the appropriate [GamepadType] for the given C++ value.
  static GamepadType fromValue(int value) =>
    values.firstWhereOrNull((type) => type.index == value) ?? unknown;
}

/// Associated data about a gamepad.
class GamepadInfo {
  /// The GUID of the gamepad.
  ///
  /// If the gamepad is not connected, this will be zero.
  final SdlGuid guid;

  /// The name of the gamepad, if available.
  final String? name;

  /// The path of the gamepad, if available.
  final String? path;

  /// The serial identifier of the gamepad, if available.
  final String? serial;

  /// The Steam input handle of the gamepad, if available.
  final int? steamHandle;

  /// The USB product ID of the gamepad, if available.
  final int? productId;

  /// The USB product version of the gamepad, if available.
  final int? productVersion;

  /// The type of the gamepad, if available. Ignores mapping overrides.
  final GamepadType realType;

  /// The type of the gamepad, if available.
  final GamepadType type;

  /// The vendor of the gamepad, if available.
  final int? vendor;

  /// The version of the gamepad's firmware, if available.
  final int? firmwareVersion;

  /// The properties of the gamepad, if available.
  ///
  /// Do not use this directly, instead, use `has_` getters below.
  final int? properties;

  /// A const constructor.
  const GamepadInfo({
    required this.guid,
    required this.name,
    required this.path,
    required this.serial,
    required this.steamHandle,
    required this.productId,
    required this.productVersion,
    required this.realType,
    required this.type,
    required this.vendor,
    required this.firmwareVersion,
    required this.properties,
  });

  bool _hasProperty(String name) => properties != null
    && sdlHasProperty(properties!, name);

  /// Whether the gamepad has an LED with an adjustable brightness
  bool get hasLedWithBrightness => _hasProperty(SDL_PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN);

  /// Whether the gamepad has an LED with an adjustable color.
  bool get hasLedWithColor => _hasProperty(SDL_PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN);

  /// Whether the gamepad has LEDs that correspond to the player index.
  bool get hasPlayerLed => _hasProperty(SDL_PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN);

  /// Whether the gamepad has dual rumble control.
  bool get hasDualRumble => _hasProperty(SDL_PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN);

  /// Whether the gamepad supports rumbling its triggers.
  bool get hasTriggerRumble => _hasProperty(SDL_PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN);
}
