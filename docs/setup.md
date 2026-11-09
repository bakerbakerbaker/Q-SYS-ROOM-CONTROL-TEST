# Q-SYS Sample Project: Room Control

Two Script components that demonstrate the core Q-SYS Lua patterns:
control event handlers, named components, timers, and TCP sockets.

| File | What it shows |
|------|---------------|
| `src/room_control.lua` | Power/source/volume/mute logic, a volume ceiling, auto-off timer, safe component lookup |
| `src/display_tcp.lua`  | TCP client with auto-reconnect, line-based replies, trigger-button commands |

## Setup in Q-SYS Designer

1. Add a **Script** component (Schematic Elements > Control > Scripting). Name it `RoomControl`.
2. Open its Properties, add the control pins listed at the top of `src/room_control.lua`
   (Power, Source, Volume, Mute, AutoOffMin, Status) with the types shown there.
3. Paste `src/room_control.lua` into the script editor.
4. Add a **Source Selector** and a **Gain** block. In their Properties, set
   Code Name to `SourceSelector` and `MainGain` so the script can find them.
5. Repeat steps 1-3 for a second Script named `DisplayDriver` using `src/display_tcp.lua`.
6. Add a UCI or Control Pins and wire them to the script controls.
7. Save, then Emulate (F5) or push to a Core to test. Watch the Lua Debug Print window.

## Notes

- The display command strings (`POWR1\r`, etc.) are placeholders. Swap in your display's protocol.
- In real projects, put the Control Script behind a Named Control layer or UCI rather than
  exposing raw pins directly.
- `MaxVolume` in the config is a simple safety ceiling; adjust to your system's gain structure.
