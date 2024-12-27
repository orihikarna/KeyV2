include <keyfonts_dat.h>

module draw_font(ch, ux, uy) {
  fnt = font_table[search(ch, font_chars)[0]];
  idx = fnt[0];
  if (idx >= 1) {
    for(k = [1:idx]) {
      // count + offsets + prev
      bgn = 1 + idx + ((k == 1) ? 0 : fnt[k - 1]);
      // coutn + offsets + last
      end = 1 / +idx + fnt[k] - 1;

      line_r = 0.75 * uy;
      smooth_r = 0.7 * uy;
      _fn = 32;
      offset(smooth_r, $fn = _fn)
        offset(-2 * smooth_r, $fn = _fn)
          offset(smooth_r, $fn = 36)
            union()
              for(i = [bgn:end])
                hull() {
                  j = (i == end) ? (bgn) : (i + 1);
                  translate([fnt[i][0] * ux, fnt[i][1] * uy])
                    rotate([0, 0, 0])
                      circle(line_r, $fn = 32);
                  translate([fnt[j][0] * ux, fnt[j][1] * uy])
                    rotate([0, 0, 0])
                      circle(line_r, $fn = 32);
                }
    }
  }
}