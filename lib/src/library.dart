import "dart:async";

import "package:sdl3/sdl3.dart" as sdl;

/// A manager class for the SDL library.
///
/// Be sure to call [init] before using any SDL functionality and to call
/// [dispose] when you're done.
class SdlLibrary {
  bool isInitialized = false;
  Timer? _eventLoopTimer;

  void _update(_) {
    // print("Updating SDL");
    sdl.sdlUpdateGamepads();
    sdl.sdlUpdateJoysticks();
  }

  /// Initializes the SDL library and starts the event loop.
  bool init({Duration eventLoopInterval = const Duration(milliseconds: 10)}) {
    // print("Init SDL");
    if (isInitialized) return true;
    final result = sdl.sdlInit(sdl.SDL_INIT_GAMECONTROLLER | sdl.SDL_INIT_JOYSTICK) == 0;
    sdl.sdlSetGamepadEventsEnabled(true);
    _eventLoopTimer = Timer.periodic(eventLoopInterval, _update);
    isInitialized = true;
    return result;
  }

  /// Closes the library and stops the event loop.
  void dispose() {
    // print("Cancelled SDL");
    _eventLoopTimer?.cancel();
    sdl.sdlQuit();
    isInitialized = false;
  }
}
