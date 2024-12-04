/// The complete state of a gamepad.
///
/// A "normal" value means a value that is linked to two directions. For example, both triggers
/// contribute to the [normalTriggers] value, so if the left was pressed less than the right,
/// the "normalized" result would be a small positive value. In general, the normal values range
/// from -1.0 to +1.0, inclusive, with -1 meaning all the way to one side, +1 to the other, and
/// 0 indicates that neither button is pressed.
///
/// For digital buttons, a normalized value will only ever be -1, 0, or +1. For analog inputs,
/// including pressure-sensitive triggers, the value will be between -1.0, +1.0.
class GamepadState {
  /// Whether the A button was pressed.
  final bool buttonA;

  /// Whether the B button was pressed.
  final bool buttonB;

  /// Whether the X button was pressed.
  final bool buttonX;

  /// Whether the Y button was pressed.
  final bool buttonY;

  /// Whether the Back or Select button was pressed.
  final bool buttonBack;

  /// Whether the Start or Options button was pressed.
  final bool buttonStart;

  /// Whether the left joystick is being pressed in.
  final bool leftJoystickButton;

  /// Whether the right joystick is being pressed in.
  final bool rightJoystickButton;

  /// The raw value of the left joystick's X axis.
  ///
  /// This value will be between -32768 (left) and 32768 (right), inclusive.
  /// - See [normalLeftJoystickX], which will always be between -1.0 and +1.0.
  final int leftJoystickX;

  /// The raw value of the left joystick's Y axis.
  ///
  /// This value will be between -32768 (down) and 32768 (up), inclusive.
  /// - See [normalLeftJoystickY], which will always be between -1.0 and +1.0.
  final int leftJoystickY;

  /// The raw value of the right joystick's X axis.
  ///
  /// This value will be between -32768 (left) and 32768 (right), inclusive.
  /// - See [normalRightJoystickX], which will always be between -1.0 and +1.0.
  final int rightJoystickX;

  /// The raw value of the left joystick's Y axis.
  ///
  /// This value will be between -32768 (down) and 32768 (up), inclusive.
  /// - See [normalRightJoystickX], which will always be between -1.0 and +1.0.
  final int rightJoystickY;

  /// The raw value of the left trigger.
  ///
  /// This value will be between 0 (released) and 32767 (fully depressed).
  /// - See [normalLeftTrigger] which will always be between 0.0 and 1.0
  /// - See [normalTriggers], which will always be between -1.0 and +1.0
  final int leftTrigger;

  /// The raw value of the left trigger.
  ///
  /// This value will be between 0 (released) and 32767 (fully depressed).
  /// - See [normalLeftTrigger] which will always be between 0.0 and 1.0
  /// - See [normalTriggers], which will always be between -1.0 and +1.0
  final int rightTrigger;

  /// Whether the up button on the directional arrow pad is pressed.
  final bool dpadUp;

  /// Whether the down button on the directional arrow pad is pressed.
  final bool dpadDown;

  /// Whether the left button on the directional arrow pad is pressed.
  final bool dpadLeft;

  /// Whether the right button on the directional arrow pad is pressed.
  final bool dpadRight;

  /// Whether the left shoulder is pressed.
  final bool leftShoulder;

  /// Whether the right shoulder is pressed.
  final bool rightShoulder;

  /// Creates a new representation of the gamepad state.
  const GamepadState({
    required this.buttonA,
    required this.buttonB,
    required this.buttonX,
    required this.buttonY,
    required this.buttonBack,
    required this.buttonStart,
    required this.leftJoystickButton,
    required this.rightJoystickButton,
    required this.leftJoystickX,
    required this.leftJoystickY,
    required this.rightJoystickX,
    required this.rightJoystickY,
    required this.leftTrigger,
    required this.rightTrigger,
    required this.dpadUp,
    required this.dpadDown,
    required this.dpadLeft,
    required this.dpadRight,
    required this.leftShoulder,
    required this.rightShoulder,
  });

  /// A normalized version of [leftTrigger] that is between 0.0 and 1.0.
  double get normalLeftTrigger => leftTrigger.normalizeJoystick;

  /// A normalized version of [rightTrigger] that is between 0.0 and 1.0.
  double get normalRightTrigger => rightTrigger.normalizeJoystick;

  /// A normalized reading of the triggers that is between -1.0 and +1.0.
  ///
  /// - A negative value indicates that the left trigger is more depressed than the right trigger
  /// - A positive value indicates that the right trigger is more depressed than the left trigger
  /// - A value of zero indicates that neither trigger is pressed, or both are pressed equally.
  double get normalTriggers => (rightTrigger - leftTrigger).normalizeJoystick;

  /// A normalized reading of [leftJoystickX] that is between -1.0 and +1.0.
  double get normalLeftJoystickX => leftJoystickX.normalizeJoystick;

  /// A normalized reading of [leftJoystickY] that is between -1.0 and +1.0.
  double get normalLeftJoystickY => leftJoystickY.normalizeJoystick;

  /// A normalized reading of [rightJoystickY] that is between -1.0 and +1.0.
  double get normalRightJoystickX => rightJoystickX.normalizeJoystick;

  /// A normalized reading of [leftJoystickY] that is between -1.0 and +1.0.
  double get normalRightJoystickY => rightJoystickY.normalizeJoystick;

  /// A normalized reading of the D-pad's X-axis that is between -1.0 and +1.0.
  ///
  /// - A value of -1.0 indicates that the left arrow is pressed
  /// - A value of +1.0 indicates that the right arrow is pressed
  /// - A value of 0 indicates that neither or both arrows are pressed
  int get normalDpadX => _normalizeButtons(dpadLeft, dpadRight);

  /// A normalized reading of the D-pad's Y-axis that is between -1.0 and +1.0.
  ///
  /// - A value of -1.0 indicates that the left arrow is pressed
  /// - A value of +1.0 indicates that the right arrow is pressed
  /// - A value of 0 indicates that neither or both arrows are pressed
  int get normalDpadY => _normalizeButtons(dpadDown, dpadUp);

  /// A normalized reading of the shoulders that is between -1.0 and +1.0.
  ///
  /// - A value of -1.0 indicates that the left shoulder is pressed
  /// - A value of +1.0 indicates that the right shoulder is pressed
  /// - A value of 0 indicates that neither or both shoulders are pressed
  int get normalShoulders => _normalizeButtons(leftShoulder, rightShoulder);
}

int _normalizeButtons(bool negativeButton, bool positiveButton) {
  final left = negativeButton ? -1 : 0;
  final right = positiveButton ? 1 : 0;
  return left + right;
}

extension on int {
  /// The "deadzone" of the gamepad.
  static const epsilon = 0.01;

  /// Normalizes joystick inputs to be between -1 and 1.
  double get normalizeJoystick {
    final value = (this - 128) / 32768;
    return (value.abs() < epsilon) ? 0 : value.clamp(-1, 1);
  }
}
