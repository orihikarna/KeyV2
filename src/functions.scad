include <constants.scad>

// I use functions when I need to compute special variables off of other special variables
// functions need to be explicitly included, unlike special variables, which
// just need to have been set before they are used. hence this file

// cherry stem dimensions
function outer_cherry_stem(slop) = [7.2 - slop * 2, 5.5 - slop * 2];

// cherry stabilizer stem dimensions
function outer_cherry_stabilizer_stem(slop) = [4.85 - slop * 2, 6.05 - slop * 2];

// box (kailh) switches have a bit less to work with
function outer_box_cherry_stem(slop) = [6 - slop, 6 - slop];

// .005 purely for aesthetics, to get rid of that ugly crosshatch
function cherry_cross(slop, extra_vertical = 0) = [
  // horizontal tine
  //[4.03 + slop, 1.25 + slop / 3],
  [4.40+ slop, 1.25 + slop],
  // vertical tine
  //[1.15 + slop / 3, 4.23 + extra_vertical + slop / 3 + SMALLEST_POSSIBLE],
  [1.25 + slop, 4.40 + slop],
];

// actual mm key width and height
function total_key_width(delta = 0) = $bottom_key_width + $unit * ($key_length - 1) - delta;
function total_key_height(delta = 0) = $bottom_key_height + $unit * ($key_height - 1) - delta;

// actual mm key width and height at the top
function top_total_key_width() = $bottom_key_width + ($unit * ($key_length - 1)) - $width_difference;
function top_total_key_height() = $bottom_key_height + ($unit * ($key_height - 1)) - $height_difference;

function side_tilt(column) = asin($unit * column / $double_sculpt_radius);
// tan of 0 is 0, division by 0 is nan, so we have to guard
function extra_side_tilt_height(column) = side_tilt(column) ? ($double_sculpt_radius - (unit * abs(column)) / tan(abs(side_tilt(column)))) : 0;
