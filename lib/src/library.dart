import "package:ffi/ffi.dart";
import "package:sdl3/sdl3.dart" as sdl;

/// A manager class for the SDL library.
///
/// Be sure to call [init] before using any SDL functionality and to call
/// [dispose] when you're done.
class SdlLibrary {
  /// Whether the library has already been initialized.
  static bool isInitialized = false;

  /// Initializes the SDL library and starts the event loop.
  static bool init({Duration eventLoopInterval = const Duration(milliseconds: 100)}) {
    if (isInitialized) return true;
    // For hint details, see: https://github.com/libsdl-org/SDL/issues/10576
    sdl.sdlSetHint(sdl.SDL_HINT_JOYSTICK_THREAD, "1");
    final result = sdl.sdlInit(sdl.SDL_INIT_GAMECONTROLLER);
    if (!result) return false;
    isInitialized = true;
    return true;
  }

  /// Closes the library and stops the event loop.
  static void dispose() {
    sdl.sdlPumpEvents();
    while (true) {
      final arena = Arena();
      final eventPointer = arena.allocate<sdl.SdlEvent>(1);
      final hasEvent = sdl.sdlPollEvent(eventPointer);
      if (!hasEvent) break;
    }
    sdl.sdlQuit();
    isInitialized = false;
  }

  /// Gets the previous error since the last call to [clearError], if any.
  static String? getError() => sdl.sdlGetError();

  /// Clears the error from [getError].
  static void clearError() => sdl.sdlClearError();
}
