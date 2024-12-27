include <keyfonts_dat.h>

module draw_font(ch, ux, uy, line_ratio = 0.75) {
  fnt = font_table[search(ch, font_chars)[0]];
  nblobs = fnt[0];
  if (nblobs >= 1) {
    for(k = [1:nblobs]) {
      // fnt = nblobs, offset_blob1, offset_blob2, ..., blobs_points
      bgn = 1 + nblobs + ((k == 1) ? 0 : fnt[k - 1]);
      end = 1 + nblobs + fnt[k] - 1;

      line_rad = line_ratio * uy;

      smooth_rad = 0.7 * uy;
      fn = 36;
      offset(smooth_rad, $fn = fn)
        offset(-2 * smooth_rad, $fn = fn)
          offset(smooth_rad, $fn = fn)
            union()
              for(i = [bgn:end])
                hull() {
                  j = (i == end) ? (bgn) : (i + 1);// cyclic
                  translate([fnt[i][0] * ux, fnt[i][1] * uy])
                    circle(line_rad, $fn = 32);
                  translate([fnt[j][0] * ux, fnt[j][1] * uy])
                    circle(line_rad, $fn = 32);
                }
    }
  }
}