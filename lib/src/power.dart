import "dart:ffi";

import "package:collection/collection.dart";
import "package:ffi/ffi.dart";
import "package:sdl3/sdl3.dart" as sdl;

import "gamepad.dart";
import "utils.dart";

/// The current power state of a gamepad.
///
/// This does not include the current power level, just how the gamepad is getting power. Note that
/// wireless USB receivers or dongles may report an inaccurate state -- eg, a receiver could emit
/// [noBattery] while the wireless gamepad itself is [onBattery].
enum GamepadPowerState {
  /// Could not determine the gamepad's state.
  error(-1),

  /// The state is unknown.
  unknown(0),

  /// The gamepad is using its battery.
  onBattery(1),

  /// The gamepad is connected via a wire and doesn't have a battery.
  noBattery(2),

  /// The gamepad is connected via a wire and is charging its battery.
  charging(3),

  /// The gamepad is connected via a wire and its battery is fully charged.
  charged(4);

  /// The C++ value of this state.
  ///
  /// See: https://wiki.libsdl.org/SDL3/SDL_PowerState
  final int value;
  const GamepadPowerState(this.value);

  /// Parses a state by its C++ value.
  ///
  /// See: https://wiki.libsdl.org/SDL3/SDL_PowerState
  static GamepadPowerState fromValue(int value) =>
    values.firstWhereOrNull((state) => state.value == value) ?? error;
}

/// Methods to get power info about a gamepad.
extension GamepadPower on SdlGamepad {
  /// The current battery level of the gamepad, as a percentage (0 - 100).
  ///
  /// You should never take a battery status as absolute truth. Batteries (especially failing
  /// batteries) are delicate hardware, and the values reported here are best estimates based
  /// on what that hardware reports. It's not uncommon for older batteries to lose stored power
  /// much faster than it reports, or completely drain when reporting it has 20 percent left, etc.
  int? get battery => using((arena) {
    late final batteryPointer = arena<Int32>();
    sdlGamepad.getPowerInfo(batteryPointer);
    return batteryPointer.value.nullIf(-1);
  });

  /// Gets the current power state of the gamepad.
  GamepadPowerState get powerState => using((arena) {
    final state = sdlGamepad.getPowerInfo(nullptr);
    return GamepadPowerState.fromValue(state);
  });
}
