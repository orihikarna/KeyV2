// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

include <./includes.scad>

//$key_length = 1.25;
//$stem_slop = 0.3;
$cherry_bevel = true;
$stem_type = "rounded_cherry";
$stem_throw = 5.5;
$stem_float = 1.0;
$rounded_cherry_stem_d = 5.5;
$support_type = "flared"; // [flared, bars, flat, disable]
//$support_type = "flat";

// example key
//dcs_row(5) legend("●", size=9) key();
//sa_row(0) key();

sep = 1.2;

module copy_x(num) {
    for (x = [0:num-1]) translate_u( 0, sep * (x - (num-1)/2.0) ) children();
}

module copy_y(num) {
    for (y = [0:num-1]) translate_u( sep * (y - (num-1)/2.0), 0 ) children();
}


/*
// row
for (n = [1:1:4]) {
    translate_u(-sep*(n-2.5), -sep/2) rotate( [0, 0, -90] )
        sa_row(n, 0, 1) key();
    translate_u(-sep*(n-2.5), +sep/2) rotate( [0, 0, -90] ) legend( "○", size = 9) 
        sa_row(n, 0, 2) key();
}

// thumbs
translate_u(-sep*1.35, sep*3/2) sa_row(0, 0, 1) key();
translate_u(        0, sep*3/2) legend( "_", size = 8) sa_row(0, 0, 0, +2) key();
translate_u(+sep*1.35, sep*3/2) legend( "○", size = 9) sa_row(0, 0, 2, +4) key();
*/

// thumb
for (n = [0:0]) translate_u(-1.25*(n-0.5)) rotate( [0, 0, -90 + 180*n] )
    legend( ["=", "o"][n], size = 7 )
    sa_row(0, 0, 0) key();

// example layout
/* preonic_default("dcs"); */
