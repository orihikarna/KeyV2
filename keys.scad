// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

include <./includes.scad>
include <./keyfonts.scad>

$bottom_hole_height = 1.2;
$extra_bottom_height = 2.0;

$wall_thickness = 2.4;//3.2;
$cherry_bevel = true;
$stem_type = "rounded_cherry";
$stabilizer_type = "rounded_cherry";
$stem_throw = 4.0;
$stem_float = 1.6;
// $rounded_cherry_stem_d = 5.3;// my printer
// $rounded_cherry_stem_d = 5.7; // DMM
$rounded_cherry_stem_d = 5.5;// JLC
//slop = 0.3;//0.2; // my printer
// slop = 0.1;// DMM
slop = 0.1;// JLC
$support_type = "flared";// [flared, bars, flat, disable]
$stem_support_type = "disable";
$font = "Skia:style=Bold";

sep_x = 1.06;
sep_y = 1.06;

module sa_key(row, w_u = 1) {
  if (row != 0) {
    sa_row(row, 0, slop, 1.0 * w_u)
      children();
  }
}

center_key = 8;
size_delta = -1;

if (false) {
  intersection() {
    translate([-50, 0, 0])
      cube([100, 100, 100], true);
    union() {
      for(prm = key_pos_angles) {
        //if (prm[5] <= 30) {
        if (prm[5] == center_key) {
          x = prm[0] - key_pos_angles[center_key][0];
          y = prm[1] - key_pos_angles[center_key][1];
          r = prm[2] * 0;
          translate([x, y, 0])
            rotate([0, 0, r]) {
              if (false) {
                square([prm[3] + size_delta, prm[4] + size_delta], center = true);
              } else {
                row = 1;
                w_u = prm[3] / 17.0;
                // $key_bump = true;
                sa_key(row, w_u)
                  key();
              }
            }
        }
      }
    }
  }
}

$key_bump = true;
intersection() {
  // translate( [50, 0, 0] ) cube( [100, 100, 100], true );
  sa_key(1)
    // sa_key(2)
    // sa_key(3)
    // sa_key(4)
    // sa_key(2, 1.29)
    // sa_key(4, 1.34)
    // sa_key(4, 1.54)
    key();
}