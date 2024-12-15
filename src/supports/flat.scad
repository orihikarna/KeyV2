module flat(stem_type, loft, height) {
  translate([0, 0, loft + 20]) {
    cube([240, 240, 40], center = true);
  }
}