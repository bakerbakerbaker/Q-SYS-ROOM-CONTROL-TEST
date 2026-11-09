# UCI Build Guide: "RoomPanel"

Build this in Designer's UCI editor (Tools > UCI Editor, or add a UCI under Inventory/Schematic).
A UCI lives inside the design file, so this guide describes what to place and bind.

## 1. Create the UCI

- Name: `RoomPanel`
- Target: touchscreen (e.g. 1280x800) and/or web UCI
- Pages: `Main`
- Layers on `Main`: `Background`, `Controls`, `Startup`

## 2. Layer: Background
- Rectangle filling the page, dark neutral color.
- Text label "Room Control" top center.

## 3. Layer: Controls

| Element | Type | Position (1280x800) | Control binding |
|---|---|---|---|
| Power | Toggle Button, text "Power" | x 80, y 80, 200x100 | `RoomControl` > `Power` |
| Laptop | Button, "Laptop" | x 80, y 260, 200x100 | `RoomControl` > `Source`, Button Type: Toggle, **Button Style: Set value = 1** |
| Wireless | Button, "Wireless" | x 300, y 260, 200x100 | `RoomControl` > `Source`, **Set value = 2** |
| Aux | Button, "Aux" | x 520, y 260, 200x100 | `RoomControl` > `Source`, **Set value = 3** |
| Volume | Fader (vertical) | x 900, y 80, 100x500 | `RoomControl` > `Volume` |
| Mute | Toggle Button, "Mute" | x 880, y 620, 140x80 | `RoomControl` > `Mute` |
| Status | Text Box (read-only) | x 80, y 700, 600x50 | `RoomControl` > `Status` |

Tips:
- Binding: select the element, set **Control > Type: Control Pin / Named Control / Component**, then choose the Script component's control. Using the Script component's pins directly is simplest.
- Source buttons light up automatically when the control value equals the button's set value.
- Set Volume fader's Min/Max to match the script (-60 to 0). The script enforces the -6 dB ceiling.

## 4. Layer: Startup (splash)
- Full-page rectangle, solid color, with text "System starting up..."
- Set layer **Visible: No** by default. `uci_pages.lua` shows and hides it.
- Leave the layer name exactly `Startup`.

## 5. Wire the helper script
1. Add a third Script component named `UciHelper` and paste `uci_pages.lua`.
2. Set the Script component Code Name of the first script to `RoomControl` (needed so the helper can find it).
3. In `uci_pages.lua` confirm `CFG.UciName`, `CFG.PageName`, `CFG.SplashLayer` match the names above.

## 6. Test
- Emulate the design, open the UCI viewer, press Power: the splash shows for a few seconds, then Controls appear.
- Press Power again: the splash does not show on power-off, and Mute engages.
