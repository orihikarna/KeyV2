include <keyfonts_dat.h>

module draw_font(ch, ux, uy, line_rad = 0.3) {
  fnt = font_table[search(ch, font_chars)[0]];
  nblobs = fnt[0];
  if (nblobs >= 1) {
    for(k = [1:nblobs]) {
      // fnt = nblobs, offset_blob1, offset_blob2, ..., blobs_points
      bgn = 1 + nblobs + ((k == 1) ? 0 : fnt[k - 1]);
      end = 1 + nblobs + fnt[k] - 1;

      inf_rad = 0.5 * uy;
      def_rad = 0.4 * uy;
      fn = 36;
      offset(def_rad, $fn = fn)
        offset(-(def_rad + inf_rad), $fn = fn)
          offset(inf_rad, $fn = fn)
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