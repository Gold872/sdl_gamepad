// ignore_for_file: avoid_print

import "package:sdl_gamepad/sdl_gamepad.dart";

Future<void> main(List<String> args) async {
  if (!SdlLibrary.init()) {
    final error = SdlLibrary.getError();
    print("Could not initialize SDL: $error");
    return;
  }
  if (args.isEmpty) {
    final gamepads = SdlGamepad.getConnectedGamepadIds();
    if (gamepads.isEmpty) {
      print("There are no connected gamepads");
      return;
    }
    print("Connected gamepads: ");
    for (final gamepadId in gamepads) {
      final info = SdlGamepad.getInfoForGamepadId(gamepadId);
      print("- Gamepad #$gamepadId");
      print("  Name: ${info.name}");
      print("  Gamepad type: ${info.type}");
      print("  Path: ${info.path}");
    }
    print("\nRun again with the ID, eg, dart example/sdl_gamepad.dart 1");
    return;
  }
  final arg = int.tryParse(args.first);
  if (arg == null) {
    print("If you provide an argument, it must be a gamepad ID (integer)");
    return;
  }
  final gamepad = SdlGamepad.fromGamepadIndex(arg);
  if (!gamepad.isConnected) {
    print("That gamepad is not connected");
    return;
  }
  while (true) {
    final state = gamepad.getState();
    final left = "Left stick: ${state.normalLeftJoystickX}/${state.normalLeftJoystickY}";
    final right = "Right stick: ${state.normalRightJoystickX}/${state.normalRightJoystickY}";
    print("$left, $right");
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}
