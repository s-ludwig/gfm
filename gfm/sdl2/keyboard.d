module gfm.sdl2.keyboard;

import derelict.sdl2.sdl;
import gfm.sdl2.sdl;

final class SDL2Keyboard
{
    public
    {
        this(SDL2 sdl2)
        {
            _sdl2 = sdl2;
            clear();            
        }      

        // test if a key is pressed
        bool isPressed(int key)
        {
            SDL_Scancode scan = SDL_GetScancodeFromKey(key);
            return (_state[scan] == PRESSED);
        }

        // test if a key is pressed, and mark it as released
        bool testAndRelease(int key)
        {
            SDL_Scancode scan = SDL_GetScancodeFromKey(key);
            return markKeyAsReleased(key);
        }
    }

    package
    {
        void clear()
        {
            _state[] = RELEASED;
        }

        /// Mark key as pressed and return previous state.
        bool markKeyAsPressed(SDL_Scancode scancode)
        {
            bool oldState = _state[scancode];
            _state[scancode] = PRESSED;
            return oldState;
        }

        /// Mark key as released and return previous state.
        bool markKeyAsReleased(SDL_Scancode scancode)
        {
            bool oldState = _state[scancode];
            _state[scancode] = RELEASED;
            return oldState;
        }
    }

    private
    {
        SDL2 _sdl2;
        bool[SDL_NUM_SCANCODES] _state;

        static const PRESSED = true,
                     RELEASED = false;
    }
}
