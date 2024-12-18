include <../functions.scad>

// extra length to the vertical tine of the inside cherry cross
// splits the stem into halves - allows easier fitment
extra_vertical = 0.6;

module inside_cherry_cross(slop) {
  // inside cross
  // translation purely for aesthetic purposes, to get rid of that awful lattice
  translate([0,0,-SMALLEST_POSSIBLE-$stem_float]) {
    linear_extrude(height = $stem_throw + $stem_float) {
      square(cherry_cross(slop, extra_vertical)[0], center=true);
      square(cherry_cross(slop, extra_vertical)[1], center=true);
    }
  }

  // Guides to assist insertion and mitigate first layer squishing
  if ($cherry_bevel){
    for (i = cherry_cross(slop, extra_vertical)) hull() {
      translate([0, 0, -SMALLEST_POSSIBLE-$stem_float]) linear_extrude(height = 0.01, center = false) offset(delta = 0.2) square(i, center=true);
      translate([0, 0, 0.5 - $stem_float]) linear_extrude(height = 0.01, center = false)  square(i, center=true);
    }
  }
}

module cherry_stem(depth, slop) {
  difference(){
    // outside shape
    linear_extrude(height = depth) {
      offset(r=1){
        square(outer_cherry_stem(slop) - [2,2], center=true);
      }
    }

    inside_cherry_cross($stem_inner_slop);
  }
}
