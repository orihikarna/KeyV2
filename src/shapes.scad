$fs=.1;
unit = 16.4;//16.0;//19.05;

include <shapes/ISO_enter.scad>
include <shapes/sculpted_square.scad>
include <shapes/rounded_square.scad>
include <shapes/square.scad>
include <shapes/oblong.scad>

// size: at progress 0, the shape is supposed to be this size
// delta: at progress 1, the keycap is supposed to be size - delta
// progress: how far along the transition you are.
// it's not always linear - specifically sculpted_square
module key_shape(size, delta, progress = 0) {
  if ($key_shape_type == "iso_enter") {
    ISO_enter_shape(size, delta, progress);
  } else if ($key_shape_type == "sculpted_square") {
    sculpted_square_shape(size, delta, progress);
  } else if ($key_shape_type == "rounded_square") {
    rounded_square_shape(size, delta, progress);
  } else if ($key_shape_type == "square") {
    square_shape(size, delta, progress);
  } else if ($key_shape_type == "oblong") {
    oblong_shape(size, delta, progress);
  } else {
    echo("Warning: unsupported $key_shape_type");
  }
}

function skin_key_shape(size, delta, progress = 0) =
  $key_shape_type == "rounded_square" ?
    skin_rounded_square(size, delta, progress) :
    $key_shape_type == "sculpted_square" ?
      skin_sculpted_square_shape(size, delta, progress) :
      echo("Warning: unsupported $key_shape_type for skin shape. disable skin_extrude_shape or pick a new shape");
