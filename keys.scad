// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

include <./includes.scad>

$wall_thickness = 3.2;
$cherry_bevel = true;
$stem_type = "rounded_cherry";
$stabilizer_type = "rounded_cherry";
$stem_throw = 5.5;
$stem_float = 0;//1.0;
$rounded_cherry_stem_d = 5.75;
$support_type = "flared"; // [flared, bars, flat, disable]
//$support_type = "flat";
$stem_support_type = "disable";
$font="Arial Narrow:style=Bold";

sep = 1.0 + 1.0/unit;

slop = 0.06;

module bottom_mark( text = "●", depth = 0.5 ) {
    difference() {
        children();
        translate([-4.5,-4.5, $stem_throw + 0.5 + depth])
            rotate([180,0,0]) {
                linear_extrude( height = depth + 0.001 ) {
                    text( text = text, font = $font, size = 3, halign = "center", valign = "center");
                }
            }
    }
}

module thumb_ud( length ) {
    //translate_u(0,0,0)
        rotate([0,0,90]) sa_row(0,0,slop,length) children();
    translate_u(0,0,26.5/unit) rotate([0,180,0])
        rotate([0,0,90]) sa_row(0,0,slop,length) children();
}

module thumb_ud_col() {
    translate_u(0,sep*(-1.00)) thumb_ud(1.00) children();
    translate_u(0,sep*(0.125)) thumb_ud(1.25) children();
    translate_u(0,sep*(1.750)) thumb_ud(2.00) children();
}

module sa_ud( n ) {
    // bottom
    translate_u(0, sep*(n-2.5), 0)
        rotate([0,0,180])
            bottom_mark() sa_row(n,0,slop) children();
    if (true) {// top
        translate_u(0, sep*(n-2.5), 28.0/unit) rotate([0,180,0])
            bottom_mark() sa_row([0, 3, 2, 1, 4][n],0,slop) children();
    }
}

module sa_ud_col() {
    sa_ud( 1 ) children();
    sa_ud( 2 ) children();
    sa_ud( 3 ) children();
    sa_ud( 4 ) children();
}

module sa_set() {
    for (n = [0:0]) translate_u(-sep*(n+0.5)) sa_ud_col() children();
    //translate_u(sep*0.5) thumb_ud_col() children();
}

sa_set() key();

module row(sgn = +1, _slop) {
    for (n = [1:1:3]) translate_u(0,sgn*sep*(2-n),0)
        rotate([0,0,90*(1-sgn)]) sa_row(n,0,_slop) key();
    translate_u(0,sep*2,0)
        rotate([0,0,90*(1-sgn)]) sa_row(4,0,_slop) key();
    translate_u(0,3*sep+0.125,0)
        rotate([0,0,90]) sa_row(0,0,_slop,1.25) key();
}

/*
translate_u(-sep*3/2,  0)                                                            row(-1, 0.05);
translate_u(-sep*3/2,4.0/unit,26.5/unit) rotate([0,180,0]) legend( ".",    size = 6) row(+1, 0.06);
translate_u(-sep*1/2,  0)                                  legend( ":",    size = 6) row(-1, 0.07);
translate_u(-sep*1/2,4.0/unit,26.5/unit) rotate([0,180,0]) legend( ":.",   size = 6) row(+1, 0.08);
translate_u(+sep*1/2,  0)                                  legend( "::",   size = 6) row(-1, 0.09);
translate_u(+sep*1/2,4.0/unit,26.5/unit) rotate([0,180,0]) legend( "::.",  size = 6) row(+1, 0.10);
translate_u(+sep*3/2,  0)                                  legend( ":::",  size = 6) row(-1, 0.11);
translate_u(+sep*3/2,4.0/unit,26.5/unit) rotate([0,180,0]) legend( ":::.", size = 6) row(+1, 0.12);
*/

// example key
//dcs_row(5) legend("●", size=9) key();
//sa_row(0) key();

// example layout
/* preonic_default("dcs"); */

include <../mywork/keycapst.scad>
