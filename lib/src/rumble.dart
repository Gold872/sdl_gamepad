import "package:sdl3/sdl3.dart" as sdl;

import "gamepad.dart";

/// Methods to rumble the gamepad.
extension GamepadRumble on SdlGamepad {
  /// The maximum rumble value of the SDL API. See: [sdl.sdlRumbleGamepad].
  static const _sdlMaxRumble = 0xFFFF;

  int _getRumbleIntensity(double intensity) {
    if (intensity < 0 || intensity > 1) {
      throw RangeError.range(intensity, 0, 1, "rumble intensity");
    }
    return (_sdlMaxRumble * intensity).floor();
  }

  /// Rumbles the gamepad at the given intensity.
  ///
  /// The intensity value should be a percentage between 0.0 (no rumble) and 1.0 (max rumble).
  ///
  /// This function rumbles the *entire* gamepad.
  /// - To control each side independently, use [rumbleSides]
  /// - To rumble just the triggers, use [rumbleTriggers]
  /// - To stop rumbling, use [stopRumble] or pass `0` as the intensity
  void rumble({required Duration duration, double intensity = 1}) => sdlGamepad.rumble(
    _getRumbleIntensity(intensity),
    _getRumbleIntensity(intensity),
    duration.inMilliseconds,
  );

  /// Rumbles each side of the gamepad at the given intensity.
  ///
  /// The intensity value should be a percentage between 0.0 (no rumble) and 1.0 (max rumble).
  ///
  /// This function rumbles each side of the gamepad independently.
  /// - To rumble the entire gamepad, set each side to the same value or use [rumble]
  /// - To rumble just the triggers, use [rumbleTriggers]
  /// - To stop rumbling, use [stopRumble] or pass `0` as the intensity
  void rumbleSides({required Duration duration, double leftIntensity = 1, double rightIntensity = 1}) => sdlGamepad.rumble(
    _getRumbleIntensity(leftIntensity),
    _getRumbleIntensity(rightIntensity),
    duration.inMilliseconds,
  ) == 0;

  /// Rumbles the triggers at the given intensity.
  ///
  /// The intensity value should be a percentage between 0.0 (no rumble) and 1.0 (max rumble).
  ///
  /// This function rumbles *just* the triggers*.
  /// - To rumble the entire gamepad, use [rumble] or use [rumbleSides]
  /// - To stop rumbling, use [stopRumble] or pass `0` as the intensity
  bool rumbleTriggers({required Duration duration, double leftIntensity = 1, double rightIntensity = 1}) => sdlGamepad.rumbleTriggers(
    _getRumbleIntensity(leftIntensity),
    _getRumbleIntensity(rightIntensity),
    duration.inMilliseconds,
  ) == 0;

  /// Stops rumbling. Equivalent to calling [rumble] with zero intensity.
  void stopRumble() => rumble(intensity: 0, duration: const Duration(seconds: 1));
}
