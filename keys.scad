// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

include <./includes.scad>

$wall_thickness = 3.6;
//$key_length = 1.25;
//$stem_slop = 0.3;
$cherry_bevel = true;
$stem_type = "rounded_cherry";
$stem_throw = 5.0;
$stem_float = 0;//1.0;
$rounded_cherry_stem_d = 5.75;
$support_type = "flared"; // [flared, bars, flat, disable]
//$support_type = "flat";
$stem_support_type = "disable";

sep = 1.0 + 1.0/unit;

module copy_x(num) {
    for (x = [0:num-1]) translate_u( 0, sep * (x - (num-1)/2.0) ) children();
}

module copy_y(num) {
    for (y = [0:num-1]) translate_u( sep * (y - (num-1)/2.0), 0 ) children();
}

slop = 0.125;

module row(sgn = +1) {
    for (n = [1:1:3]) translate_u(0,sgn*sep*(2-n),0)
        rotate([0,0,90*(1-sgn)]) sa_row(n,0,slop) key();
    translate_u(0,sep*2,0)
        rotate([0,0,90*(1-sgn)]) sa_row(4,0,slop) key();
}

module thumb_row() {
    translate_u(0,sep*(-1.0),0) rotate([0,0,-90]) sa_row(0,0,slop,1.00) key();
    translate_u(0,sep*(0.15),0) rotate([0,0,-90]) sa_row(0,0,slop,1.25) key();
    translate_u(0,sep*(1.60),0) rotate([0,0,-90]) sa_row(0,0,slop,1.50) key();
}

for (n = [-1:1:0]) {
    //translate_u(-sep*(n+0.5),0,-28.0/unit)                         row(-1);
    //translate_u(-sep*(n+0.5),3.0/unit,-1.0/unit) rotate([0,180,0]) row(+1);
}
for (n = [0:1]) {
    translate_u(-sep*(n+0.5),0,0)                                  row(-1);
    translate_u(-sep*(n+0.5),3.0/unit,27.0/unit) rotate([0,180,0]) row(+1);
}
for (n = [0:0]) {
    translate_u(+sep*(n+0.5),0,0)                           thumb_row();
    translate_u(+sep*(n+0.5),0,27.0/unit) rotate([0,180,0]) thumb_row();
}

//translate_u(-sep/2,0,        0)                                          row(-1);
//translate_u(+sep/2,0,        0)                   legend( "-", size = 9) row(-1);
//translate_u(-sep/2,4.0/unit,25.0/unit) rotate([0,180,0]) legend( "=", size = 9) row(+1);
//translate_u(+sep/2,0,27.0/unit) rotate([0,180,0]) legend( "≡", size = 9) row(+1);

// example key
//dcs_row(5) legend("●", size=9) key();
//sa_row(0) key();

// example layout
/* preonic_default("dcs"); */
