## MA028IPST case (IceNav)

Parametric OpenSCAD case for:

- [Makerfabs MaTouch ESP32-S3 Parallel 2.8" (MA028IPST)](https://www.makerfabs.com/matouch-esp32-s3-parallel-ips-with-touch-2-8.html)
- [GEP-M10-DQ GPS](https://geprc.com/) (21.8 × 21.8 × 8.2 mm)

### Layout

- Screen / lid on top, USB edge at the bottom of the model
- **USB-TTL** cutout only (21.8 mm from left edge when viewing the screen)
- GPS bay is a **narrow centered neck** around the module (not full board width); connector toward the board; antenna facing the lid with a 0.8 mm RF window
- Blind Ø**2.8** mm self-tap pilots for M3
- Underside **Quad Lock twist-lock** male interface (default), or set `ql_style = "pad"` for the official Universal Adaptor stick-on pad
- No openings for SD, RST, FLASH, or USB-NATIVE

### Measured inputs

| Item | mm |
|---|---|
| Board L × W (tabs included) | 67 × 60 |
| Body width (no tabs) | 48 |
| Max length at USB | 68.1 |
| Screen | 66.7 × 47.6 |
| Mount holes | Ø3, 61 × 54 centers |
| Screen + PCB (tab stack) | 5.5 |
| Stack (screen+PCB+Mabee) | 12.3 |
| Stack at USB | 8.8 |
| USB-TTL center from left (screen view) | 21.8 |

### Files

- `ma028ipst_case.scad` — base, lid, fit jig, preview
- Export STLs with OpenSCAD Customizer `part` = `base` / `lid` / `fit_jig`

```bash
openscad -D 'part="fit_jig"' -o ma028ipst_fit_jig.stl ma028ipst_case.scad
openscad -D 'part="base"'    -o ma028ipst_base.stl    ma028ipst_case.scad
openscad -D 'part="lid"'     -o ma028ipst_lid.stl     ma028ipst_case.scad
```

### Print notes

1. Print **fit_jig** first to check board drop-in, hole alignment, and USB-TTL position.
2. Suggested: PETG or ABS, 0.2 mm layers, 3 perimeters.
3. Lid has a thinned 0.8 mm window over the GPS antenna — avoid painting/plating that area.
4. Bosses rise to the PCB underside (`screen_pcb_h = 5.5`); Mabee connectors hang into the cavity below.
5. Blind Ø2.8 mm self-tap pilots for M3 — they stop 1 mm above the outer floor. Suggested screw length ~10–12 mm. (Use 2.5–2.6 if you want a tighter bite.)
6. If USB-TTL is mirrored left/right on your unit, set `usb_from_left = board_w - 21.8`.
7. **Quad Lock:** Default `ql_style = "twist"` builds the **case-side** interface on the base underside: raised boss with finger well and four T-lugs (drops into a Quad Lock mount head). Tune `ql_clear` / `ql_lug_w` after a test print. Set `ql_style = "pad"` for the official VHB Universal Adaptor instead. Mechanism is patented — personal use only.

### Tune after first fit

Edit the parameters at the top of `ma028ipst_case.scad` (wall, clearances, `window_inset`, `gps_cable_gap`, USB cutout size).
