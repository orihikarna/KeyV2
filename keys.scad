// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

include <./includes.scad>
include <./keyfonts.scad>

$bottom_hole_height = 2.0;
$extra_bottom_height = 1.2;

$wall_thickness = 3.2;
$cherry_bevel = true;
$stem_type = "rounded_cherry";
$stabilizer_type = "rounded_cherry";
$stem_throw = 4.2;
$stem_float = 3.4 - $extra_bottom_height;
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

module led_slit_char(row, ch1, ch2, w = 6.8 , h = 2.4) {
  length = row_heights[row] + 0.5;
  difference() {
    children();
    translate([0, 5.5, -1 + $extra_bottom_height])
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

cols = [// row, chars
  [
    [[1, "5%", 13], [2, "T", 12], [3, "G", 11], [4, "B", 10]],
    [[1, "4$", 21], [2, "R", 20], [3, "F", 19], [4, "V", 18]],
    [[1, "3#", 29], [2, "E", 28], [3, "D", 27], [4, "C", 26]],
    [[1, "2\"", 37], [2, "W", 36], [3, "S", 35], [4, "X", 34]],
    [[1, "1!", 43], [2, "Q", 42], [3, "A", 41], [3, "^~", 61]],
    [[1, "e", 49], [2, "p", 48], [3, "c", 47], [4, "d", 60]],
    [[0, " ", -1], [2, "w", 53], [3, "t", 52], [0, " ", -1]],
  ],
  [
    [[1, "6&", 9], [2, "Y", 8], [3, "H", 7], [4, "N", 6]],
    [[1, "7'", 17], [2, "U", 16], [3, "J", 15], [4, "M", 14]],
    [[1, "8(", 25], [2, "I", 24], [3, "K", 23], [4, "<", 22]],
    [[1, "9)", 33], [2, "O", 32], [3, "L", 31], [4, ">", 30]],
    [[1, "0", 40], [2, "P", 39], [3, "+", 38], [3, "¥|", 59]],
    [[1, "-=", 46], [2, "@`", 45], [3, "*", 44], [4, "r", 58]],
    [[0, " ", -1], [2, "[", 51], [3, "]", 50], [0, " ", -1]],
  ],
];

thumbs = [// row, width, offset, chars
  [
    [[0, 1.00, -1.50, " ", -1], [4, 1.34, -0.3, "Z", 55], [4, 1.54, 1.20, "s",  57]],
    [[2, 1.29, -1.35, "A",  1], [2, 1.29,    0, "C",  3], [2, 1.29, 1.35, "-",   5]],
  ],
  [
    [[0, 1.00, -1.50, " ", -1], [4, 1.34, -0.3, "/?",54], [4, 1.54, 1.20, "\\_",56]],
    [[2, 1.29, -1.35, "s",  0], [2, 1.29,    0, "|",  2], [2, 1.29, 1.35, "-",   4]],
  ]
];

module sa_key(row, w_u=1) {
  if (row != 0) {
      sa_row(row, 0, slop, 1.0 * w_u)
        children();
  }
}

module sa_col(side, col, rot_a = 0) {
  for (n = [0:3]) {
    dat = cols[side][col][n];
    row = dat[0];
    ch1 = dat[1][0];
    ch2 = dat[1][1];
    $key_bump = (ch1 == "J");
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
  for (i = [0:2]) {
    dat = thumbs[side][col][i];
    row = dat[0];
    w_u = dat[1];
    offset = dat[2];
    ch1 = dat[3][0];
    ch2 = dat[3][1];
    rot_a = (col == 1 && i == 2) ? ((side == 0) ? -90 : +90) : 0;
    translate_u( sep_x * (col+6), sep_y*offset, 0)
      rotate([0, 0, 90 + rot_a])
        led_slit_char(row, ch1, ch2)
          rotate([0, 0, -rot_a])
            sa_key(row, w_u)
              children();
  }
}

if (false)
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
          if (false) {// bottom
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

//include <../mywork/keycapst.scad>

include <../Mozza62/layout/kbd-layout.scad>

center_key = 8;
size_delta = -1;

if (true)
intersection() {
  //translate( [-58, 0, 0] ) cube( [100, 100, 100], true );
  //translate( [0, 0, -50] ) cube( [100, 100, 100], true );
  union() {
    for (side = [1:1]) {// 0:1
      if (true) {// top
        for (col = [0:6]) {// 0:6
          for (n = [0:3]) {// 0:3
            dat = cols[side][col][n];
            row = dat[0];
            ch1 = dat[1][0];
            ch2 = dat[1][1];
            if (dat[2] >= 0) {
              if (dat[2] == center_key) {
                echo(prm[6], "size_w_mm", 1.0 * unit, "w_mm", prm[3], "h_mm", prm[4]);
              }
              prm = key_pos_angles[dat[2]];
              x = prm[0];// - key_pos_angles[center_key][0];
              y = prm[1];// - key_pos_angles[center_key][1];
              r = prm[2];
              $key_bump = (ch1 == "J");
              translate([x, y, 0])
                rotate([0, 0, r]) {
                  //bottom_mark()
                  //led_slit(n)
                  led_slit_char(row, ch1, ch2)
                    sa_key(row)
                      key();
                }
            }
          }
        }
      }
      if (true) {// bottom
        for (col = [0:1]) {// 0:1
          for (i = [0:2]) {// 0:2
            dat = thumbs[side][col][i];
            row = dat[0];
            w_u = dat[1];
            offset = dat[2];
            ch1 = dat[3][0];
            ch2 = dat[3][1];
            if (dat[4] >= 0) {
              prm = key_pos_angles[dat[4]];
              x = prm[0];// - key_pos_angles[center_key][0];
              y = prm[1];// - key_pos_angles[center_key][1];
              r = prm[2];
              // echo(prm[6], "size_w_mm", w_u * unit, "size_h_mm", unit, "w_mm", prm[3], "h_mm", prm[4], "size_w", (prm[3] - 0.8))
              echo(prm[6], "size_w_mm", w_u * unit, "w_mm", prm[3], "size_w", (prm[3] - 0.8) / unit)
              translate([x, y, 0])
                rotate([0, 0, r])
                  led_slit_char(row, ch1, ch2)
                    sa_key(row, w_u)
                      key();
            }
          }
        }
      }
    }
  }
}

if (false) {
  intersection() {
    translate( [-50, 0, 0] ) cube( [100, 100, 100], true );
    union() {
      for (prm = key_pos_angles) {
      //if (prm[5] <= 30) {
      if (prm[5] == center_key) {
        x = prm[0] - key_pos_angles[center_key][0];
        y = prm[1] - key_pos_angles[center_key][1];
        r = prm[2] * 0;
        translate([x, y, 0])
          rotate([0, 0, r]) {
            if (false) {
              square([prm[3] + size_delta, prm[4] + size_delta], center=true);
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
