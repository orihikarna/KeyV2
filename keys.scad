// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

include <./includes.scad>
include <./keyfonts.scad>

$wall_thickness = 3.2;
$cherry_bevel = true;
$stem_type = "rounded_cherry";
$stabilizer_type = "rounded_cherry";
$stem_throw = 3.8;
$stem_float = 3.4;
$rounded_cherry_stem_d = 5.7;//5.5;//5.3;//5.75;
$support_type = "flared"; // [flared, bars, flat, disable]
//$support_type = "flat";
$stem_support_type = "disable";
//$font="Arial Narrow:style=Bold";
//$font="Trebuchet MS:style=Bold";
//$font="Avenir Next:style=Bold";
//$font="Futura:style=Bold";
//$font="Gill Sans:style=Bold";
//$font="Lucida Grande:style=Bold";
//$font="Menlo:style=Bold";
//$font="PT Sans Caption:style=Bold";
$font="Skia:style=Bold";
//$font="Tahoma:style=Bold";
//$font="Verdana:style=Bold";

sep_x = 1.06;
sep_y = 1.06;

slop = 0.1;//0.06;
//slop = 0.3;//0.2;

module bottom_mark(text = "■", depth = 0.8) {
  difference() {
    children();
    //translate([-4.5,-4.5, $stem_throw + 0.5 + depth])
    translate([0, -6.0, depth - 0.001])
      rotate([180,0,0]) {
        linear_extrude(height = depth + 0.001) {
          text(text = text, font = $font, size = 3, halign = "center", valign = "center");
        }
      }
  }
}

module led_slit(n, w = 4.0, h = 1.2) {
  sc = 2.0;
  length = [0, 12, 8.8, 9, 10.0][n];
  difference() {
    children();
    //translate( [0, 5.0, -8.8] )
    translate([0, 5.3, -1])
      rotate([12, 0, 0])
        linear_extrude(length, scale = 0.4) {
          $fn = 36;
          square(sc * [w, h], center = true);
            translate(sc * [+w/2, 0, 0]) circle(sc * h/2);
            translate(sc * [-w/2, 0, 0]) circle(sc * h/2);
        }
  }
}

row_heights = [0, 12.2, 9.6, 9.8, 10.6];

module led_hole(w, h) {
  $fn = 36;
  hull() {
    translate([+w/2, 0, 0]) circle(h/2);
    translate([-w/2, 0, 0]) circle(h/2);
  }
}

module led_slit_char_(row, ch, w = 6.8, h = 2.4) {
  length = row_heights[row];
  difference() {
    children();
    translate([0, 5.4, -1])
      rotate([12, 0, 0]) {
        linear_extrude(length - 5) {
          led_hole( w, h );
        }
        linear_extrude(length)
          draw_font(ch, 0.65, 0.5);
      }
  }
}

module led_slit_char(row, ch1, ch2, w = 6.8 , h = 2.4) {
  length = row_heights[row];
  difference() {
    children();
    translate([0, 5.5, -1])
      rotate([10, 0, 0]) {
        linear_extrude(length - 5)
          led_hole(w * ((ch2 == undef) ? 1 : 1.4), h);
        linear_extrude(length)
          if (ch2 == undef) {
            draw_font(ch1, 0.60, 0.4);
          } else {
            translate([-2.7, 0, 0]) draw_font(ch1, 0.45, 0.4);
            translate([+2.7, 0, 0]) draw_font(ch2, 0.45, 0.4);
          }
      }
  }
}

cols = [
  [
    [1, 2, 3, 4, "5%", "T", "G", "B"],
    [1, 2, 3, 4, "4$", "R", "F", "V"],
    [1, 2, 3, 4, "3#", "E", "D", "C"],
    [1, 2, 3, 4, "2\"", "W", "S", "X"],
    [1, 2, 3, 2, "1!", "Q", "A", "w"],
    [1, 2, 3, 3, "e", "¥|", "t", "^~"],
    [0, 0, 0, 2, " ", " ", " ", "-"],
  ],
  [
    [1, 2, 3, 4, "6&", "Y", "H", "N"],
    [1, 2, 3, 4, "7'", "U", "J", "M"],
    [1, 2, 3, 4, "8(", "I", "K", "<"],
    [1, 2, 3, 4, "9)", "O", "L", ">"],
    [1, 2, 3, 2, "0",  "P", "+", "["],
    [1, 2, 3, 3, "-=", "@`", "*", "]"],
    [0, 0, 0, 2, " ", " ", " ", "-"],
  ],
];

thumbs = [
  [
    [0, 4, 4, 1.0, 1.3, 1.6, -1.50, -0.3, 1.20, " ", "Z", "s"],
    [2, 2, 3, 1.3, 1.3, 1.3, -1.35, 0,    1.35, "A", "C", "d"],
  ],
  [
    [0, 4, 4, 1.0, 1.3, 1.6, -1.50, -0.3, 1.20, " ", "/?", "\\_"],
    [2, 2, 3, 1.3, 1.3, 1.3, -1.35, 0,    1.35, "s", "|", "r"],
  ]
];

module sa_key(row, w_u=1) {
  // bottom
  if (row != 0) {
      sa_row(row, 0, slop, 1.0 * w_u)
        children();
  }
  if (false) {// top
    translate_u(0, sep_y*(2.5-n), 28.0/unit)
      rotate([0,180,0])
        bottom_mark()
          sa_row(row, 0, slop, 1.0 * w_u)
            children();
  }
}

module sa_col(side, col, rot_a = 0) {
  for (n = [0:3]) {
    dat = cols[side][col];
    row = dat[n];
    ch1 = dat[4+n][0];
    ch2 = dat[4+n][1];
    translate_u(0, sep_y*(1.5-n), 0)
      //bottom_mark()
      //led_slit(n)
      led_slit_char(row, ch1, ch2)
        rotate([0, 0, rot_a])
          sa_key(row)
            children();
  }
}

module thumb_col(side, col) {
  dat = thumbs[side][col];
  for (i = [0:2]) {
    row = dat[i];
    w_u = dat[i+3];
    offset = dat[i+6];
    ch1 = dat[i+9][0];
    ch2 = dat[i+9][1];
    rot_a = (col == 1 && i == 2) ? ((side == 0) ? -90 : +90) : 0;
    translate_u( sep_x * (col+6), sep_y*offset, 0)
      rotate([0, 0, 90 + rot_a])
        led_slit_char(row, ch1, ch2)
          rotate([0, 0, -rot_a])
            sa_key(row, w_u)
              children();
  }
}

intersection() {
  //translate( [-58, 0, 0] ) cube( [100, 100, 100], true );
  //translate( [0, 0, -50] ) cube( [100, 100, 100], true );
  union() {
    for (side = [0:1]) {
      rotate([0, 0 * side, 0 * side])
        translate_u(sep_x * +2, 0, 1.7 * side) {
          if (true) {// top
            translate_u(sep_x * (-3.5), 0, 0) {
              for (n = [0:3]) {
                translate_u(sep_x * n, 0, 0)
                  sa_col(side, n, (n == 6) ? 90 * (side * 2 - 1) : 0)
                    key();
              }
            }
          }
          if (true) {// bottom
            rotate([0, 180, 0])
              translate([8.7, 8.4, 5])
                translate_u(sep_x * (-3.5), 0, 0) {
                  for (n = [4:6]) {
                    translate_u(sep_x * n, 0, 0)
                      sa_col(side, n, (n == 6) ? 90 * (side * 2 - 1) : 0)
                        key();
                  }
                  for (n = [0:1]) thumb_col( side, n ) key();
                }
          }
        }
    }
  }
}

module row(sgn = +1, _slop) {
  for (n = [1:1:3]) translate_u(0, sgn*sep*(2-n), 0)
    rotate([0, 0, 90*(1-sgn)]) sa_row(n, 0, _slop) key();
  translate_u(0, sep*2, 0)
    rotate([0, 0, 90*(1-sgn)]) sa_row(4, 0, _slop) key();
  translate_u(0,3*sep+0.125,0)
    rotate([0, 0, 90]) sa_row(0, 0, _slop, 1.25) key();
}

/*
translate_u(-sep*3/2,  0)                                                            row(-1, 0.05);
translate_u(-sep*3/2,4.0/unit,26.5/unit) rotate([0,180,0]) legend( ".",    size = 6) row(+1, 0.06);
translate_u(-sep*1/2,  0)                                  legend( ":",    size = 6) row(-1, 0.07);
translate_u(-sep*1/2,4.0/unit,26.5/unit) rotate([0,180,0]) legend( ":.",   size = 6) row(+1, 0.08);
translate_u(+sep*1/2,  0)                                  legend( "::",   size = 6) row(-1, 0.09);
translate_u(+sep*1/2,4.0/unit,26.5/unit) rotate([0,180,0]) legend( "::.",  size = 6) row(+1, 0.10);
translate_u(+sep*3/2,  0)                                  legend( ":::",  size = 6) row(-1, 0.11);
translate_u(+sep*3/2,4.0/unit,26.5/unit) rotate([0,180,0]) legend( ":::.", size = 6) row(+1, 0.12);
*/

// example key
//dcs_row(5) legend("●", size=9) key();
//sa_row(0) key();

// example layout
/* preonic_default("dcs"); */

//include <../mywork/keycapst.scad>
