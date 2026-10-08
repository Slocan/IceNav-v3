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
boss_od = 6.5;          // must stay clear of cavity walls (~0.5 mm)
// Blind M3 self-tapping pilots in bosses (do not pierce the floor)
tap_d = 2.5;
tap_depth = 8.0;
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

/* [Case shell] */
wall = 2.0;
floor_t = 2.0;
lid_t = 2.0;
pcb_clear = 0.5;
window_inset = 1.0;      // lid lip over glass edge
lip_h = 1.2;             // lid/base mating lip
fit_tol = 0.25;          // lid lip clearance

/* [Derived — do not edit in Customizer] */
eps = 0.05;
inner_w = board_w + 2 * pcb_clear;
inner_l = board_l + board_usb_extra + 2 * pcb_clear;
cavity_h = stack_h + 1.0;            // clearance for Mabee under PCB
gps_pocket_w = gps_conn_w + 2 * gps_clear;
gps_pocket_l = gps_body + 2 * gps_clear;
gps_bay_l = gps_cable_gap + gps_pocket_l + wall;
outer_w = inner_w + 2 * wall;
outer_l = inner_l + gps_bay_l + 2 * wall;
outer_h = floor_t + cavity_h + lid_t;

board_x0 = wall + pcb_clear;
board_y0 = wall + pcb_clear + board_usb_extra;

hole_x0 = board_x0 + (board_w - hole_spacing_w) / 2;
hole_y0 = board_y0 + (board_l - hole_spacing_l) / 2;

screen_x = board_x0 + (board_w - screen_w) / 2;
screen_y = board_y0 + (board_l - screen_l) / 2;

gps_x = board_x0 + (board_w - gps_pocket_w) / 2;
gps_y = board_y0 + board_l + gps_cable_gap;

usb_x = board_x0 + usb_from_left;

// Boss tops sit under the PCB/tabs; Mabee hangs into the cavity below.
boss_top_z = floor_t + cavity_h - screen_pcb_h;
gps_shelf_h = max(0.8, cavity_h - gps_h - 0.5);
tap_h = min(tap_depth, boss_top_z - floor_remain);

module rounded_rect(size, r) {
    offset(r = r)
        offset(r = -r)
            square([size[0], size[1]]);
}

module shell_profile() {
    rounded_rect([outer_w, outer_l], 3);
}

module mount_hole_centers() {
    for (x = [0, hole_spacing_w], y = [0, hole_spacing_l])
        translate([hole_x0 + x, hole_y0 + y])
            children();
}

module boss_columns() {
    mount_hole_centers()
        cylinder(d = boss_od, h = boss_top_z, $fn = 32);
}

module usb_cutout() {
    // USB sits on the PCB underside; place cutout under the board plane
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

module base() {
    difference() {
        cube([outer_w, outer_l, floor_t + cavity_h]);

        // Cavity carved *around* bosses (avoids non-manifold union)
        difference() {
            translate([wall, wall, floor_t])
                cube([inner_w, inner_l, cavity_h + 1]);

            mount_hole_centers()
                translate([0, 0, floor_t - 0.01])
                    cylinder(d = boss_od, h = boss_top_z - floor_t + 0.02, $fn = 32);
        }

        // Clearance above boss tops (PCB / screw access)
        mount_hole_centers()
            translate([0, 0, boss_top_z])
                cylinder(d = boss_od + 0.4, h = cavity_h, $fn = 32);

        translate([gps_x, gps_y, floor_t + gps_shelf_h])
            cube([gps_pocket_w, gps_pocket_l, cavity_h - gps_shelf_h + 1]);

        translate([
            board_x0 + (board_w - 12) / 2,
            board_y0 + board_l - 0.1,
            floor_t
        ])
            cube([12, gps_cable_gap + 0.2, min(gps_h + 1, cavity_h) + 1]);

        translate([wall / 2, wall / 2, floor_t + cavity_h - lip_h])
            cube([outer_w - wall, outer_l - wall, lip_h + 1]);

        usb_cutout();

        // Blind self-tap pilots: open at boss top, 1 mm floor remains
        mount_hole_centers()
            translate([0, 0, floor_remain])
                cylinder(d = tap_d, h = boss_top_z - floor_remain + 0.01, $fn = 24);
    }
}

module lid() {
    win_w = screen_w - 2 * window_inset;
    win_l = screen_l - 2 * window_inset;
    win_x = screen_x + window_inset;
    win_y = screen_y + window_inset;

    difference() {
        union() {
            linear_extrude(lid_t, convexity = 4)
                shell_profile();

            translate([wall / 2 + fit_tol, wall / 2 + fit_tol, -lip_h])
                linear_extrude(lip_h + 0.1, convexity = 4)
                    rounded_rect(
                        [outer_w - wall - 2 * fit_tol, outer_l - wall - 2 * fit_tol],
                        2.4
                    );
        }

        translate([win_x, win_y, -lip_h - 1])
            cube([win_w, win_l, lid_t + lip_h + 2]);

        mount_hole_centers() {
            translate([0, 0, -lip_h - 1])
                cylinder(d = screw_clear_d, h = lid_t + lip_h + 2, $fn = 24);
            translate([0, 0, lid_t - screw_head_h])
                cylinder(d = screw_head_d, h = screw_head_h + 0.1, $fn = 24);
        }

        // thin RF window over GPS antenna
        if (gps_cover_t < lid_t)
            translate([gps_x + gps_clear, gps_y + gps_clear, gps_cover_t])
                cube([gps_body, gps_body, lid_t - gps_cover_t + 0.1]);
    }
}

module fit_jig() {
    h = 3.0;
    difference() {
        linear_extrude(h, convexity = 4)
            shell_profile();
        translate([wall, wall, 1])
            cube([inner_w, inner_l, h]);
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
        translate([gps_x, gps_y, h - 0.6])
            cube([gps_pocket_w, gps_pocket_l, 1]);
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
            board_x0 + (board_w - gps_body) / 2,
            board_y0 + board_l + gps_cable_gap + gps_clear,
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
