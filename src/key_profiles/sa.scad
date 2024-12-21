module sa_row(n=3, column=0, slop=0.125, length=1) {
  $key_shape_type = "sculpted_square";
  $bottom_key_width = 16.4;//16.0;//18.4;
  $bottom_key_height = 16.4;//16.0;//18.4;
  $width_difference  = 4.2;//5.7;
  $height_difference = 4.2;//5.7;
  $dish_type = (n == 0) ? "saddle" : "spherical";
  $dish_depth = (n == 0) ? 2.1 : 1.05;//0.85;
  $dish_skew_x = 0;
  $dish_skew_y = 0;
  $top_skew = 0;
  $inverted_dish = (n == 0);
  $key_length = length;
  $stem_slop = slop;
  $height_slices = 10;
  // might wanna change this if you don't minkowski
  // do you even minkowski bro
  $corner_radius = 1.0;

  $stabilizers = $key_length >= 6 ? [[-50, 0], [50, 0]] : $key_length >= 2 ? [[-12,0],[12,0]] : [];

  // this is _incredibly_ intensive
  /* $rounded_key = true; */

  $top_tilt_y = side_tilt(column);
  extra_height = ($double_sculpted ? extra_side_tilt_height(column) : 0) + $extra_bottom_height + 1.0;

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
    $total_depth = 10 + extra_height;
    $top_tilt = -11;
    children();
  } else if (n == 2) {
    //$total_depth = 12.925 + extra_height;
    //$top_tilt = -7;
    //$total_depth = 12.5 + extra_height;
    $total_depth = 8.0 + extra_height;
    $top_tilt = 2;
    children();
  } else if (n == 3) {
    //$total_depth = 12.5 + extra_height;
    //$top_tilt = 0;
    //$total_depth = 11.0 + extra_height;
    //$top_tilt = -6;
    $total_depth = 8.5 + extra_height;
    $top_tilt = 6;
    children();
  } else if (n == 4) {
    //$total_depth = 12.925 + extra_height;
    //$top_tilt = 7;
    //$total_depth = 10.2 + extra_height;
    //$top_tilt = 3;
    $total_depth = 9.5 + extra_height;
    $top_tilt = 10;
    children();
  } else {
    $total_depth = 10.5 + extra_height;
    $top_tilt = 0;
    children();
  }
}
