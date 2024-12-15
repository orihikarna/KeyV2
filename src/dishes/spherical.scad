module spherical_dish(width, height, depth, inverted) {
  // same thing as the cylindrical dish here, but we need the corners to just touch - so we have to find the hypotenuse of the top
  chord = sqrt(width * width + height * height) / 2;//getting diagonal of the top

  // the distance you have to move the dish up so it digs in depth millimeters
  chord_length = (chord * chord - depth * depth) / (2 * depth);
  // the radius of the dish
  // rad = (chord * chord + depth * depth) / (2 * depth);
  direction = inverted ? -1 : 1;

  translate([0, 0, 0 * direction]) {
    if (geodesic) {
      $fa = 20;
      scale([chord / depth, chord / depth]) {
        geodesic_sphere(r = depth);
      }
    } else {
      // $fa=6.5;
      // $fa=20;
      // rotate 1 because the bottom of the sphere looks like trash.
      scale([chord / depth, chord / depth]) {
        sphere(r = depth, $fn = 64);
      }
    }
  }
}