<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

Read and control gamepads via the [SDL3](https://wiki.libsdl.org/SDL3/FrontPage) backend (thanks to [`package:sdl3`](https://pub.dev/packages/sdl3))

## Features

- Open gamepads by their device ID or player index
- Extensive rumble support, including DualSense trigger rumble
- Query the current state of the gamepad and what buttons are pressed
- Query other USB, device, and power info from the gamepad.

## Getting started

This package requires a compiled dynamically linked binary of SDL3 on your system. That means a `.dll` (Windows), `.dylib` (Mac), or `.so` (Linux). See the page on [building SDL 3.0](https://wiki.libsdl.org/SDL3/Installation) for more details. When [Native Assets](https://github.com/dart-lang/sdk/issues/50565) are made generally available, this requirement will be handled for you.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
if (!SdlLibrary.init()) {
  print("Could not open SDL");
  return;
};

final gamepad = SdlGamepad.fromPlayerIndex(0);
if (!gamepad.isConnected) {
  print("Gamepad is not connected");
  return;
}

final state = gamepad.state();
print("Is A pressed? ${state.buttonA}");

SdlLibrary.dispose();
```

## Additional information

This package is merely a wrapper on the amazing [sdl3 package](https://pub.dev/packages/sdl3) by [sansuido](https://github.com/sansuido), check out his other projects and support him!

This package is intending to be only a thin wrapper around the sdl3 package to just make the APIs more Dart-friendly. If something is missing, please file an issue, but adding features not already present in sdl3 is out-of-scope for this project.
