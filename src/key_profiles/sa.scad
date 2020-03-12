module sa_row(n=3, column=0) {
  $key_shape_type = "sculpted_square";
  $bottom_key_width = 18.4;
  $bottom_key_height = 18.4;
  $width_difference = 5.7;
  $height_difference = 5.7;
  $dish_type = (n == 0) ? "saddle" : "spherical";
  $dish_depth = (n == 0) ? 2.25 : 0.85;
  $dish_skew_x = 0;
  $dish_skew_y = 0;
  $top_skew = 0;
  $inverted_dish = (n == 0);
  $key_length = (n == 0) ? 1.25 : 1;
  $stem_slop = 0;
  $height_slices = 10;
  // might wanna change this if you don't minkowski
  // do you even minkowski bro
  $corner_radius = 0.25;

  // this is _incredibly_ intensive
  /* $rounded_key = true; */

  $top_tilt_y = side_tilt(column);
  extra_height = $double_sculpted ? extra_side_tilt_height(column) : 0;

  // 5th row is usually unsculpted or the same as the row below it
  // making a super-sculpted top row (or bottom row!) would be real easy
  // bottom row would just be 13 tilt and 14.89 total depth
  // top row would be something new entirely - 18 tilt maybe?
  if (n == 0) {
    $total_depth = 10 + extra_height;
    $top_tilt = 7;
    children();
  } else if (n == 1) {
    //$total_depth = 14.89 + extra_height;
    //$top_tilt = -13;
    $total_depth = 14 + extra_height;
    $top_tilt = -13;
    children();
  } else if (n == 2) {
    //$total_depth = 12.925 + extra_height;
    //$top_tilt = -7;
    $total_depth = 12 + extra_height;
    $top_tilt = -8;
    children();
  } else if (n == 3) {
    //$total_depth = 12.5 + extra_height;
    //$top_tilt = 0;
    $total_depth = 11 + extra_height;
    $top_tilt = -4;
    children();
  } else if (n == 4) {
    //$total_depth = 12.925 + extra_height;
    //$top_tilt = 7;
    $total_depth = 11.4 + extra_height;
    $top_tilt = 5;
    children();
  } else {
    $total_depth = 12.5 + extra_height;
    $top_tilt = 0;
    children();
  }
}
