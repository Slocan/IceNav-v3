// IceNav case for Makerfabs MA028IPST + GEP-M10-DQ GPS
// Units: mm
//
// Coordinate system (screen facing +Z, USB at Y=0):
//   X = board width  (tabs included)
//   Y = board length (USB edge -> GPS edge)
//   Z = thickness    (base floor -> screen)
//
// USB-TTL center is 21.8 mm from the left edge when viewing the screen
// (USB-NATIVE left / USB-TTL right on the component side).

/* [Render] */
part = "preview"; // [preview, base, lid, fit_jig]
explode = 15;     // preview only: separate lid from base

/* [Board] */
board_l = 67.0;          // PCB length (USB -> opposite edge)
board_w = 60.0;          // PCB width including mounting tabs
board_body_w = 48.0;     // PCB body width without tabs
board_usb_extra = 1.1;   // USB shells past PCB edge (68.1 - 67)
screen_pcb_h = 5.5;      // screen + PCB only (mounting-tab stack)
stack_h = 12.3;          // screen + PCB + Mabee connectors
stack_usb_h = 8.8;       // screen + PCB + USB shells
screen_l = 66.7;
screen_w = 47.6;

/* [Mounting] */
hole_d = 3.0;
hole_spacing_l = 61.0;   // along board length (Y)
hole_spacing_w = 54.0;   // across board width (X)
screw_clear_d = 3.2;
screw_head_d = 6.0;
screw_head_h = 2.2;
boss_od = 6.5;           // must stay clear of cavity walls (~0.5 mm)
// Blind M3 self-tapping pilots (2.8 = easier drive / less crack risk in PETG)
tap_d = 2.8;
floor_remain = 1.0;      // solid plastic left under each blind hole

/* [USB-TTL cutout] */
usb_from_left = 21.8;    // center of USB-TTL from left edge (screen view)
usb_cut_w = 10.0;
usb_cut_h = 4.2;
usb_cut_clear = 0.4;

/* [GPS bay — GEP-M10-DQ] */
gps_body = 21.8;
gps_conn_w = 23.7;       // widest at connector side
gps_h = 8.2;
gps_clear = 0.6;
gps_cable_gap = 4.0;     // space between board edge and GPS body
gps_cover_t = 0.8;       // thin lid window over antenna (RF-friendly)
gps_corner_r = 2.0;      // outer rounding on GPS neck

/* [Case shell] */
wall = 2.0;
floor_t = 2.0;
lid_t = 2.0;
pcb_clear = 0.5;
window_inset = 1.0;      // lid lip over glass edge
lip_h = 1.2;             // lid/base mating lip
fit_tol = 0.25;          // lid lip clearance
main_corner_r = 3.0;

/* [Quad Lock underside mount] */
ql_enable = true;
// "twist" = case-side male (recess + 4 T-lugs); "pad" = flat pad for official Universal Adaptor
ql_style = "twist"; // [twist, pad]
ql_adaptor = "original"; // [original, mag]  (pad style only)
ql_pad_h = 1.2;
ql_boss_h = 4.0;
ql_amps = false;
ql_amps_tap_d = 3.3;
ql_mark_depth = 0.4;
// Case-side twist-lock (finger well + four T-lugs). Tune clearances after a test print.
ql_well_d = 31.5;        // finger-well / hub opening diameter
ql_lug_outer_d = 35.0;   // tip-to-tip across opposite lugs
ql_lug_w = 7.6;          // lug width (mount notches ~8 mm)
ql_lug_stem_h = 1.0;     // stem under T-flange (thin)
ql_lug_flange_h = 1.1;   // T-flange thickness (catches under mount)
ql_lug_flange_extra = 1.4; // flange overhang past stem (radially inward)
ql_bump_h = 3.2;         // raised boss height below case floor
ql_bump_d = 42.0;        // raised boss outer diameter
ql_clear = 0.2;          // general clearance shrink
ql_insert_rot = 45;      // lug angle at insert (twist ~45° to lock)

/* [Derived — do not edit in Customizer] */
eps = 0.05;
inner_w = board_w + 2 * pcb_clear;
inner_l = board_l + board_usb_extra + 2 * pcb_clear;
cavity_h = stack_h + 1.0;            // clearance for Mabee under PCB

gps_pocket_w = gps_conn_w + 2 * gps_clear;
gps_pocket_l = gps_body + 2 * gps_clear;

// Main body is a closed box around the board; GPS bay is a narrower centered neck.
// End-wall "shoulders" remain on either side of the GPS opening.
main_outer_w = inner_w + 2 * wall;
main_outer_l = wall + inner_l + wall;

gps_outer_w = gps_pocket_w + 2 * wall;
gps_outer_x = (main_outer_w - gps_outer_w) / 2;

board_x0 = wall + pcb_clear;
board_y0 = wall + pcb_clear + board_usb_extra;

hole_x0 = board_x0 + (board_w - hole_spacing_w) / 2;
hole_y0 = board_y0 + (board_l - hole_spacing_l) / 2;

screen_x = board_x0 + (board_w - screen_w) / 2;
screen_y = board_y0 + (board_l - screen_l) / 2;

gps_x = gps_outer_x + wall;
// GPS pocket starts gps_cable_gap past the board edge
gps_y = board_y0 + board_l + gps_cable_gap;

// Neck length beyond the main-body end wall
gps_bay_ext = (gps_y - main_outer_l) + gps_pocket_l + wall;

outer_w = main_outer_w;
outer_l = main_outer_l + gps_bay_ext;
outer_h = floor_t + cavity_h + lid_t;

usb_x = board_x0 + usb_from_left;

boss_top_z = floor_t + cavity_h - screen_pcb_h;
gps_shelf_h = max(0.8, cavity_h - gps_h - 0.5);

// Quad Lock Universal Adaptor pad (official stick-on sizes)
ql_pad_w = (ql_adaptor == "mag") ? 60.0 : 48.0;
ql_pad_l = (ql_adaptor == "mag") ? 60.0 : 60.0;
ql_pad_x = (main_outer_w - ql_pad_w) / 2;
ql_pad_y = (main_outer_l - ql_pad_l) / 2;
ql_cx = main_outer_w / 2;
ql_cy = main_outer_l / 2;
amps_short = 30.17;
amps_long = 38.05;
ql_well_r = ql_well_d / 2 - ql_clear;
ql_lug_outer_r = ql_lug_outer_d / 2 - ql_clear;

module rounded_rect(size, r) {
    offset(r = r)
        offset(r = -r)
            square([size[0], size[1]]);
}

// Board rectangle + centered GPS neck (2D, for lid / jig)
module shell_profile_raw() {
    union() {
        square([main_outer_w, main_outer_l]);
        translate([gps_outer_x, main_outer_l - 0.5])
            square([gps_outer_w, gps_bay_ext + 0.5]);
    }
}

module shell_profile() {
    // Fillet only convex corners; keep sharp re-entrant shoulder corners
    offset(r = main_corner_r)
        offset(r = -main_corner_r)
            shell_profile_raw();
}

module shell_profile_inset(inset) {
    offset(r = -inset)
        shell_profile_raw();
}

// Explicit 3D outer solid — avoids 2D-offset eating the shoulder walls
module shell_solid(h) {
    union() {
        cube([main_outer_w, main_outer_l, h]);
        translate([gps_outer_x, main_outer_l - 0.5, 0])
            cube([gps_outer_w, gps_bay_ext + 0.5, h]);
    }
}

module mount_hole_centers() {
    for (x = [0, hole_spacing_w], y = [0, hole_spacing_l])
        translate([hole_x0 + x, hole_y0 + y])
            children();
}

module usb_cutout() {
    z0 = boss_top_z - (stack_usb_h - screen_pcb_h) - usb_cut_clear;
    translate([
        usb_x - usb_cut_w / 2 - usb_cut_clear,
        -eps,
        max(floor_t + 0.5, z0)
    ])
        cube([
            usb_cut_w + 2 * usb_cut_clear,
            wall + board_usb_extra + pcb_clear + 2,
            usb_cut_h + 2 * usb_cut_clear
        ]);
}

module amps_hole_centers() {
    for (x = [-amps_short / 2, amps_short / 2],
         y = [-amps_long / 2, amps_long / 2])
        translate([ql_cx + x, ql_cy + y])
            children();
}

// One T-lug: radial stem + inward flange that catches under the mount
module ql_t_lug() {
    stem_len = ql_lug_outer_r - ql_well_r + 0.4;
    flange_len = stem_len + ql_lug_flange_extra;
    w = ql_lug_w - 2 * ql_clear;

    // Stem (stands out from well wall toward tip)
    translate([ql_well_r - 0.2, -w / 2, 0])
        cube([stem_len, w, ql_lug_stem_h + ql_lug_flange_h]);

    // Inward T-flange (undercut catch), on the outer tip end of the stem
    translate([
        ql_lug_outer_r - flange_len,
        -w / 2,
        ql_lug_stem_h
    ])
        cube([flange_len, w, ql_lug_flange_h]);
}

// Case-side male: raised boss with finger well + four T-lugs
// (matches phone-case interface that drops into a Quad Lock mount head)
module ql_twist_male() {
    lug_z = ql_bump_h - (ql_lug_stem_h + ql_lug_flange_h);

    difference() {
        // Raised circular bump on case back
        cylinder(d = ql_bump_d, h = ql_bump_h, $fn = 72);

        // Finger well / open center (mount engages around this)
        translate([0, 0, -eps])
            cylinder(r = ql_well_r, h = ql_bump_h + 2 * eps, $fn = 72);
    }

    // Four T-lugs around the well (insert orientation)
    translate([0, 0, max(0, lug_z)])
        for (i = [0:3])
            rotate(i * 90 + ql_insert_rot)
                ql_t_lug();
}

module quadlock_pad_positive() {
    translate([ql_pad_x - 3, ql_pad_y - 3, -ql_boss_h + ql_pad_h])
        cube([ql_pad_w + 6, ql_pad_l + 6, ql_boss_h - ql_pad_h + eps]);
    translate([ql_pad_x, ql_pad_y, -ql_boss_h])
        cube([ql_pad_w, ql_pad_l, ql_pad_h]);
}

module quadlock_pad_cuts() {
    translate([ql_cx - ql_pad_w / 2 + 1, ql_cy - 0.3, -ql_boss_h - eps])
        cube([ql_pad_w - 2, 0.6, ql_mark_depth + eps]);
    translate([ql_cx - 0.3, ql_cy - ql_pad_l / 2 + 1, -ql_boss_h - eps])
        cube([0.6, ql_pad_l - 2, ql_mark_depth + eps]);
    difference() {
        translate([ql_pad_x - 0.6, ql_pad_y - 0.6, -ql_boss_h - eps])
            cube([ql_pad_w + 1.2, ql_pad_l + 1.2, ql_mark_depth + eps]);
        translate([ql_pad_x + 0.2, ql_pad_y + 0.2, -ql_boss_h - 1])
            cube([ql_pad_w - 0.4, ql_pad_l - 0.4, ql_mark_depth + 2]);
    }
    if (ql_amps)
        amps_hole_centers()
            translate([0, 0, -ql_boss_h - eps])
                cylinder(d = ql_amps_tap_d, h = ql_boss_h - 1.0, $fn = 24);
}

module quadlock_mount_positive() {
    if (ql_style == "twist")
        translate([ql_cx, ql_cy, 0])
            mirror([0, 0, 1])
                ql_twist_male();
    else
        quadlock_pad_positive();
}

module quadlock_mount_cuts() {
    if (ql_style == "pad")
        quadlock_pad_cuts();
}

module base() {
    H = floor_t + cavity_h;
    cavity_end_y = wall + inner_l;

    difference() {
        union() {
            shell_solid(H);
            if (ql_enable)
                quadlock_mount_positive();
        }

        // Board cavity, carved around bosses (stops before end wall)
        difference() {
            translate([wall, wall, floor_t])
                cube([inner_w, inner_l, cavity_h + 1]);

            mount_hole_centers()
                translate([0, 0, floor_t - 0.01])
                    cylinder(d = boss_od, h = boss_top_z - floor_t + 0.02, $fn = 32);
        }

        // Clearance above boss tops
        mount_hole_centers()
            translate([0, 0, boss_top_z])
                cylinder(d = boss_od + 0.4, h = cavity_h, $fn = 32);

        // GPS pocket (narrow bay)
        translate([gps_x, gps_y, floor_t + gps_shelf_h])
            cube([gps_pocket_w, gps_pocket_l, cavity_h - gps_shelf_h + 1]);

        // Centered opening through end wall into GPS neck only —
        // left/right shoulder walls (full board width) stay solid
        translate([gps_x, cavity_end_y - 0.1, floor_t])
            cube([
                gps_pocket_w,
                wall + (gps_y - main_outer_l) + 0.2,
                cavity_h + 1
            ]);

        // Lid lip recess over board cavity only — do not notch the
        // full-height shoulder end-walls at the GPS transition
        translate([wall / 2, wall / 2, H - lip_h])
            cube([main_outer_w - wall, cavity_end_y - wall / 2, lip_h + 1]);

        // Lid lip recess on GPS neck (separate from shoulders)
        translate([gps_outer_x + wall / 2, main_outer_l, H - lip_h])
            cube([gps_outer_w - wall, gps_bay_ext - wall / 2, lip_h + 1]);

        usb_cutout();

        // Blind self-tap pilots
        mount_hole_centers()
            translate([0, 0, floor_remain])
                cylinder(d = tap_d, h = boss_top_z - floor_remain + 0.01, $fn = 24);

        if (ql_enable)
            quadlock_mount_cuts();
    }
}

module lid() {
    win_w = screen_w - 2 * window_inset;
    win_l = screen_l - 2 * window_inset;
    win_x = screen_x + window_inset;
    win_y = screen_y + window_inset;
    inset = wall / 2 + fit_tol;
    cavity_end_y = wall + inner_l;

    difference() {
        union() {
            shell_solid(lid_t);

            // Mating lip into base (matches base recesses; shoulders are full-height)
            translate([inset, inset, -lip_h])
                cube([main_outer_w - 2 * inset, cavity_end_y - inset, lip_h + 0.1]);
            translate([gps_outer_x + inset, main_outer_l, -lip_h])
                cube([gps_outer_w - 2 * inset, gps_bay_ext - inset, lip_h + 0.1]);
        }

        translate([win_x, win_y, -lip_h - 1])
            cube([win_w, win_l, lid_t + lip_h + 2]);

        mount_hole_centers() {
            translate([0, 0, -lip_h - 1])
                cylinder(d = screw_clear_d, h = lid_t + lip_h + 2, $fn = 24);
            translate([0, 0, lid_t - screw_head_h])
                cylinder(d = screw_head_d, h = screw_head_h + 0.1, $fn = 24);
        }

        // Thin RF window over GPS antenna
        if (gps_cover_t < lid_t)
            translate([gps_x + gps_clear, gps_y + gps_clear, gps_cover_t])
                cube([gps_body, gps_body, lid_t - gps_cover_t + 0.1]);
    }
}

module fit_jig() {
    h = 3.0;
    difference() {
        shell_solid(h);
        translate([wall, wall, 1])
            cube([inner_w, inner_l, h]);
        // GPS bay hollow, keep shoulder end-wall except center opening
        translate([gps_x, wall + inner_l - 0.1, 1])
            cube([gps_pocket_w, wall + gps_bay_ext, h]);
        translate([
            usb_x - usb_cut_w / 2 - usb_cut_clear,
            -eps,
            0.5
        ])
            cube([
                usb_cut_w + 2 * usb_cut_clear,
                wall + 2,
                h
            ]);
        mount_hole_centers()
            translate([0, 0, -eps])
                cylinder(d = hole_d + 0.2, h = h + 1, $fn = 24);
    }
}

module board_ghost() {
    color("red", 0.35)
        translate([board_x0, board_y0, boss_top_z])
            cube([board_w, board_l, screen_pcb_h]);
    color("orange", 0.2)
        translate([
            board_x0 + (board_w - board_body_w) / 2,
            board_y0,
            floor_t + cavity_h - stack_h
        ])
            cube([board_body_w, board_l, stack_h - screen_pcb_h]);
    color("black", 0.45)
        translate([screen_x, screen_y, floor_t + cavity_h - 0.6])
            cube([screen_w, screen_l, 0.6]);
    color("dimgray", 0.5)
        translate([
            gps_x + gps_clear,
            gps_y + gps_clear,
            floor_t + gps_shelf_h
        ])
            cube([gps_body, gps_body, gps_h]);
}

if (part == "base")
    base();
else if (part == "lid")
    lid();
else if (part == "fit_jig")
    fit_jig();
else {
    base();
    translate([0, 0, floor_t + cavity_h + explode])
        lid();
    board_ghost();
}
