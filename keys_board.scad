include <./keyfonts.scad>

$extra_bottom_height = 2.0;

sep_x = 1.06;
sep_y = 1.06;

unit = 16.4;

// copied
module translate_u(x = 0, y = 0, z = 0) {
  translate([x * unit, y * unit, z * unit])
    children();
}

module led_hole(w, h, r = 0.4) {
  hull()
    for(y = [-1, +1])
      for(x = [-1, +1])
        translate([(w / 2 - r) * x, (h / 2 - r) * y, 0])
          circle(r, $fn = 36);
}

row_heights = [0, 9.8, 7.0, 7.2, 8.0];

module led_slit_char(row, ch1, ch2, w = 6.8, h = 2.4) {
  length = row_heights[row] + $extra_bottom_height + 1.0;
  difference() {
    children();
    translate([0, 5.55, 0])
      rotate([8, 0, 0]) {
        linear_extrude(length - 2)
          led_hole(w * ((ch2 == undef) ? 1.2 : 1.6), h);
        linear_extrude(length + 1)
          if (ch2 == undef) {
            draw_font(ch1, 0.60, 0.4);
          } else {
            translate([-2.7, 0, 0])
              draw_font(ch1, 0.45, 0.4);
            translate([+2.7, 0, 0])
              draw_font(ch2, 0.45, 0.4);
          }
      }
  }
}

module sa_key(row, w_u = 1) {
  if (row == 1)
    import("sa_row1.stl");
  else if (row == 2) {
    if (w_u == 1)
      import("sa_row2.stl");
    else if (w_u == 1.29)
      import("sa_row2_w129.stl");
  } else if (row == 3)
    import("sa_row3.stl");
  else if (row == 4) {
    import("sa_row4.stl");
    if (w_u == 1)
      import("sa_row4.stl");
    else if (w_u == 1.34)
      import("sa_row4_w134.stl");
    else if (w_u == 1.54)
      import("sa_row4_w154.stl");
  }
}

module sa_col(side, col, rot_a = 0) {
  for(n = [0:3]) {
    dat = cols[side][col][n];
    row = dat[0];
    ch1 = dat[1][0];
    ch2 = dat[1][1];
    idx = dat[2];
    // echo(key_pos_angles[idx][6], ch1, ch2);
    $key_bump = (ch1 == "J");
    translate_u(0, sep_y * (1.5 - n), 0)
      led_slit_char(row, ch1, ch2)
        rotate([0, 0, rot_a])
          sa_key(row);
  }
}

module thumb_col(side, col) {
  for(i = [0:2]) {
    dat = thumbs[side][col][i];
    row = dat[0];
    w_u = dat[1];
    offset = dat[2];
    ch1 = dat[3][0];
    ch2 = dat[3][1];
    rot_a = (col == 1 && i == 2) ? ((side == 0) ? -90 : +90) : 0;
    translate_u(sep_x * (col + 6), sep_y * offset, 0)
      rotate([0, 0, 90 + rot_a])
        led_slit_char(row, ch1, ch2)
          rotate([0, 0, -rot_a])
            sa_key(row, w_u);
  }
}

include <../Mozza62/layout/kbd-layout.scad>
include <mozza62.h>

center_key = 8;

// for keyboard
if (false)
  for(side = [0:1]) {// 0:1
    if (true)// top
      for(col = [0:6])// 0:6
        for(n = [0:3]) {// 0:3
          dat = cols[side][col][n];
          row = dat[0];
          ch1 = dat[1][0];
          ch2 = dat[1][1];
          idx = dat[2];
          if (idx >= 0) {
            if (idx == center_key)
              echo(prm[6], "size_w_mm", 1.0 * unit, "w_mm", prm[3], "h_mm", prm[4]);
            prm = key_pos_angles[idx];
            x = prm[0];// - key_pos_angles[center_key][0];
            y = prm[1];// - key_pos_angles[center_key][1];
            r = prm[2];
            $key_bump = (ch1 == "J");
            translate([x, y, 0])
              rotate([0, 0, r])
                led_slit_char(row, ch1, ch2)
                  sa_key(row);
          }
        }
    if (true)// bottom
      for(col = [0:1])// 0:1
        for(i = [0:2]) {// 0:2
          dat = thumbs[side][col][i];
          row = dat[0];
          w_u = dat[1];
          offset = dat[2];
          ch1 = dat[3][0];
          ch2 = dat[3][1];
          idx = dat[4];
          if (idx >= 0) {
            prm = key_pos_angles[idx];
            x = prm[0];// - key_pos_angles[center_key][0];
            y = prm[1];// - key_pos_angles[center_key][1];
            r = prm[2];
            // echo(prm[6], "size_w_mm", w_u * unit, "size_h_mm", unit, "w_mm", prm[3], "h_mm", prm[4], "size_w", (prm[3] - 0.8));
            echo(prm[6], "size_w_mm", w_u * unit, "w_mm", prm[3], "size_w", (prm[3] - 0.8) / unit);
            translate([x, y, 0])
              rotate([0, 0, r])
                led_slit_char(row, ch1, ch2)
                  sa_key(row, w_u);
          }
        }
  }

  // for order
if (true)
  intersection() {
    translate([-50 - 7.0, 0, 0])
      cube([100, 100, 100], true);
    union()
      for(side = [0:0])// [0:1]
        rotate([0, 0 * side, 0 * side])
          translate_u(sep_x * +2, 0, 1.7 * side) {
            if (true)// top
              translate_u(sep_x * (-3.5), 0, 0)
                for(n = [1:1])// [0:3]
                  translate_u(sep_x * n, 0, 0)
                    sa_col(side, n, (n == 6) ? 90 * (side * 2 - 1) : 0);
            if (false)// bottom
              rotate([0, 180, 0])
                translate([8.7, 8.4, 5])
                  translate_u(sep_x * (-3.5), 0, 0) {
                    for(n = [4:6])
                      translate_u(sep_x * n, 0, 0)
                        sa_col(side, n, (n == 6) ? 90 * (side * 2 - 1) : 0);
                    for(n = [0:1])
                      thumb_col(side, n);
                  }
          }
  }


ux = 1.3;
uy = 1;
if (false)
  for(y = [0:13])
    for(x = [0:4]) {
      idx = x + 5 * y;
      if (idx < search("z", font_chars)[0]) {
        ch = font_chars[idx];
        if (ch != " ")
          translate([(12 * ux + 2) * x, -6 * uy * y])
            draw_font(ch, ux, uy);
      }
    }