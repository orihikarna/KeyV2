include <../functions.scad>
include <cherry.scad>

module rounded_cherry_stem(depth, slop) {
  difference(){
    translate( [0, 0, -$stem_float])
      cylinder(d=$rounded_cherry_stem_d, h=depth + $stem_float);

    // inside cross
    // translation purely for aesthetic purposes, to get rid of that awful lattice
    inside_cherry_cross(slop);
  }
}
