/// How the gamepad is connected.
enum GamepadConnectionState {
  /// The gamepad's connection state is unknown.
  unknown,

  /// The gamepad's connection state is invalid.
  invalid,

  /// The gamepad is connected physically, with a wire.
  ///
  /// Note that, somewhat surprisingly, this is true of gamepads with a wireless dongles.
  wired,

  /// The gamepad is connected wirelessly, likely over Bluetooth.
  ///
  /// Note that, somewhat surprisingly, this is *not* true of gamepads with a wireless dongle.
  wireless;

  factory GamepadConnectionState.fromSdl(int index) => switch (index) {
        -1 => invalid,
        0 => unknown,
        1 => wired,
        2 => wireless,
        _ => throw ArgumentError.value(
            index,
            "GamepadConnectionState.index",
            "Unrecognized SDL_JOYSTICK_CONNECTION index",
          ),
      };
}
