include <./keyfonts.scad>

include <mozza62.h>
include <../Mozza62/layout/kbd-layout.scad>

$extra_bottom_height = 2.0;

center_key = 8;

unit = 16.4;

sep_x = unit * 1.06;
sep_y = unit * 1.06;

module sa_key(row, w_u = 1, bump = false) {
  if (row == 1)
    import("sa_row1.stl");
  else if (row == 2) {
    if (w_u == 1)
      import("sa_row2.stl");
    else if (w_u == 1.29)
      import("sa_row2_w129.stl");
  } else if (row == 3)
    if (bump)
      import("sa_row3_bump.stl");
    else
      import("sa_row3.stl");
  else if (row == 4) {
    if (w_u == 1)
      import("sa_row4.stl");
    else if (w_u == 1.34)
      import("sa_row4_w134.stl");
    else if (w_u == 1.54)
      import("sa_row4_w154.stl");
  }
}

module led_hole(w, h, r = 0.4) {
  hull()
    for(y = [-1, +1])
      for(x = [-1, +1])
        translate([(w / 2 - r) * x, (h / 2 - r) * y, 0])
          circle(r, $fn = 36);
}

row_heights = [0, 9.8, 7.0, 7.2, 8.0];

module led_slit_char(row, ch1, ch2, w = 6.8, h = 2.4, hole_rad = 0.4, line_rad = 0.3, thick_hole = 10, thick_chars = 1.0, hole_top_scale = 1.0) {
  length = row_heights[row] + $extra_bottom_height + 1.0;
  z_offset = length - (thick_hole + thick_chars);
  translate([0, 5.55, 0])
    rotate([8, 0, 0])
      translate([0, 0, z_offset]) {
        hole_top_height = 0.6;
        linear_extrude(thick_hole - hole_top_height + 0.001)
          led_hole(w * ((ch2 == undef) ? 1.2 : 1.6), h, hole_rad);
        translate([0, 0, thick_hole - hole_top_height])
          linear_extrude(hole_top_height, scale = hole_top_scale)
            led_hole(w * ((ch2 == undef) ? 1.2 : 1.6), h, hole_rad);
        linear_extrude(thick_hole + thick_chars + 1.0)
          if (ch2 == undef) {
            draw_font(ch1, 0.60, 0.4, line_rad);
          } else {
            translate([-2.7, 0, 0])
              draw_font(ch1, 0.45, 0.4, line_rad);
            translate([+2.7, 0, 0])
              draw_font(ch2, 0.45, 0.4, line_rad);
          }
      }
}

module _key(row, chs, x, y, r, w_u = 1) {
  translate([x, y, 0])
    rotate([0, 0, r])
      difference() {
        sa_key(row, w_u, chs[0] == "J" || chs[0] == "F");
        led_slit_char(row, chs[0], chs[1]);
      }
}

module top_key(side, col, idx, x = undef, y = undef, r = undef) {
  dat = fingers[side][col][idx];
  row = dat[0];
  chs = dat[1];
  key_no = dat[2];
  if (key_no >= 0) {
    prm = key_pos_angles[key_no];
    // if (key_no == center_key)
    //   echo(prm[6], "size_w_mm", 1.0 * unit, "w_mm", prm[3], "h_mm", prm[4]);
    $key_bump = (chs[0] == "J");
    _key(row, chs, (is_undef(x)) ? prm[0] : x, (is_undef(y)) ? prm[1] : y, (is_undef(r)) ? prm[2] : r);
  }
}

module bottom_key(side, col, idx, x = undef, y = undef, r = undef) {
  dat = thumbs[side][col][idx];
  row = dat[0];
  chs = dat[1];
  key_no = dat[2];
  if (key_no >= 0) {
    w_u = dat[3];
    offset = dat[4];
    prm = key_pos_angles[key_no];
    // if (key_no == center_key)
    //   echo(prm[6], "size_w_mm", 1.0 * unit, "w_mm", prm[3], "h_mm", prm[4]);
    //   echo(prm[6], "size_w_mm", w_u * unit, "w_mm", prm[3], "size_w", (prm[3] - 0.8) / unit);
    _key(row, chs, (is_undef(x)) ? prm[0] : x, (is_undef(y)) ? prm[1] : (y + offset * unit * 0), (is_undef(r)) ? prm[2] : r, w_u);
  }
}

module _char(row, chs, x, y, r, w_u, shrink, thick_hole, thick_chars = 1.0, hole_top_scale = 1.0) {
  color("lightgreen")
    translate([x, y, 0])
      rotate([0, 0, r])
        intersection() {
          sa_key(row, w_u);
          hole_rad = 0.4 - 0.05 * shrink;
          line_rad = 0.3 - 0.05 * shrink;
          led_slit_char(row, chs[0], chs[1], hole_rad = hole_rad, line_rad = line_rad, thick_hole = thick_hole, thick_chars = thick_chars, hole_top_scale = hole_top_scale);
        }
}

module top_char(side, col, idx, x, y, r, shrink, thick_hole = 3) {
  dat = fingers[side][col][idx];
  row = dat[0];
  chs = dat[1];
  key_no = dat[2];
  length = -row_heights[row] + 2 + thick_hole - 3;
  // length = 0;
  dz = length * cos(-8);
  dy = length * sin(-8);
  if (key_no >= 0) {
    translate([0, dy, dz])
      _char(row, chs, x, y, r, 1, shrink, thick_hole, thick_chars = 1.27, hole_top_scale = 0.9);
    color("pink")
      translate([x, y + 5.1, -1])
        cube([1.6, 1.6, 5], center = true);
  }
}

module bottom_char(side, col, idx, x, y, r, shrink, thick_hole = 3) {
  dat = thumbs[side][col][idx];
  row = dat[0];
  chs = dat[1];
  key_no = dat[2];
  length = -row_heights[row] + 2 + thick_hole - 3;
  // length = 0;
  dz = length * cos(-8);
  dy = length * sin(-8);
  if (key_no >= 0) {
    // w_u = dat[3];
    translate([0, dy, dz])
      _char(row, chs, x, y, r, 1, shrink, thick_hole, thick_chars = 1.28, hole_top_scale = 0.9);
    translate([x, y + 5.1, -1])
      color("pink")
        cube([1.6, 1.6, 5], center = true);
  }
}

if (false)// for keyboard
  for(side = [0:1]) {
    // 0:1
    if (true)// top
      for(col = [0:6])// 0:6
        for(idx = [0:3])// 0:3
          top_key(side, col, idx);
    if (true)// bottom
      for(col = [0:1])// 0:1
        for(idx = [0:2])// 0:2
          bottom_key(side, col, idx);
  }

  // keycaps for order
if (false) {
  // for order
  sep_x = 0;
  sep_y = 0;
  intersection() {
    // translate([-50 - 1 * unit, 0, 0])
    //   cube([100, 100, 100], true);
    union()
      for(side = [0:0]) {
        // [0:1]
        if (false)// top
          for(col = [5:5])// [0:6]
            for(idx = [3:3])// [0:3]
              top_key(side, col, idx, sep_x * (col - 4), sep_y * (1.5 - idx), 0);
        if (true)// bottom
          translate([sep_x * -2, 0, 0])// +3
            for(col = [1:1])// [0:1]
              for(idx = [2:2])// [0:2]
                bottom_key(side, col, idx, col * sep_x, ([2, 1.4][col] + [1.6, 1.4][col] * -idx) * sep_y, 90);
      }
  }
}

char_sep_x = 0.8 * unit;
if (true) {
  // legend
  char_sep_x = 0;
  union()
    for(side = [0:0])// [0:1]
      translate([0, 0, 12 * (0.5 - side)])
        rotate([0, 180 * side * 0, 180 * side * 0]) {
          if (false)// top
            translate([char_sep_x * -4, 0, 0])
              for(col = [6:6]) {
                // [0:6]
                color("pink")
                  translate([char_sep_x * col, 5.1 - sep_y * 1, -3])
                    // cube([1.6, sep_y * 1 / 3 * 7 + 1.6, 1.6], center = true);
                    cube([1.6, sep_y * 1 / 3 * 3 + 1.6, 1.6], center = true);
                for(idx = [0:3])// [0:3]
                  for(shr = [1:2]) {
                    // [0:2]
                    x = char_sep_x * col;
                    y = sep_y * ((shr - 1.5 - idx * 2) / 3.0);
                    top_char(side, col, idx, x = x, y = y, r = 0, shrink = shr, thick_hole = 7 - shr);
                  }
              }
          if (true)// bottom
            translate([char_sep_x * -2, 0, 0])
              for(col = [1:1]) {
                // [0:1]
                color("pink")
                  //   translate([char_sep_x * col, 5.1 - sep_y * 1, -3])
                  // cube([1.6, sep_y * 1 / 3 * 3 + 1.6, 1.6], center = true);
                  translate([char_sep_x * col, 5.1 - sep_y * 2 / 3, -3])
                    cube([1.6, sep_y * 1 / 3 * 5 + 1.6, 1.6], center = true);
                for(idx = [0:2])// [0:2]
                  for(shr = [1:2]) {
                    // [0:2]
                    x = char_sep_x * col;
                    y = sep_y * (shr - 1.5 - idx * 2) / 3.0;
                    bottom_char(side, col, idx, x = x, y = y, r = 0, shrink = shr, thick_hole = 7 - shr);
                  }
              }
        }
}
if (false) {
  // font test
  for(y = [0:9])
    for(x = [0:9])
      translate([6 * x, 3 * y, 0])
        linear_extrude(1)
          draw_font(font_chars[10 * y + x], 0.45, 0.4, line_rad = 0.3 - 0.1);
}