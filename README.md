# Q-SYS Room Control (Lua sample project)

A small, working example of Q-SYS Lua scripting for a single-room AV system: power, source select, volume with a safety ceiling, mute, an auto-off timer, a TCP display driver, and a touchscreen UCI with a startup splash.

Built to be read and adapted. Every script is short and commented.

## What's inside

| Path | Purpose |
|------|---------|
| `src/room_control.lua` | Main logic: power, 3-way source select, volume ceiling, mute, auto-off timer |
| `src/display_tcp.lua` | TCP client for a display: auto-reconnect, line-based replies, trigger-button commands |
| `src/uci_pages.lua` | UCI helper: shows a "System starting up" splash layer on power-on |
| `docs/setup.md` | Control pins and component names to create in Designer |
| `docs/uci_layout.md` | UCI build guide: layers, element positions, control bindings |

## Concepts demonstrated

- Control `EventHandler` callbacks
- Looking up named components with `Component.New`, with error handling
- `Timer.New` for auto-off and splash timing
- `TcpSocket` with `ReconnectTimeout` and `ReadLine`
- UCI control from Lua with `Uci.SetLayerVisibility`
- Config tables at the top of each script, so site-specific values are easy to change

## Quick start

1. Install [Q-SYS Designer](https://www.qsys.com) (free; no hardware needed to test).
2. Follow `docs/setup.md` to add the Script components and control pins.
3. Paste each file from `src/` into its Script component.
4. Build the panel from `docs/uci_layout.md`.
5. Press **F5** to Emulate, then open the UCI viewer.

The display commands in `display_tcp.lua` are placeholders. Replace them with your display's protocol before testing against real hardware.

## Design overview

```
 UCI "RoomPanel"
      |
      v
 RoomControl (room_control.lua) ---> SourceSelector, MainGain components
      |
      +--> UciHelper (uci_pages.lua)      splash on power-on
      |
 DisplayDriver (display_tcp.lua) ---> TCP ---> Display
```

## Status

Sample code. It has not been tested on a Core. Check API calls (especially `Uci.SetLayerVisibility`) against your Designer version's Lua reference.

## License

MIT. See [LICENSE](LICENSE).
