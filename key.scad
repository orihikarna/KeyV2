include <util.scad>
include <stems.scad>
include <dishes.scad>
/* [Settings] */

// keytop thickness, aka how many millimeters between the inside and outside of the top surface of the key
keytop_thickness = 1;
// wall thickness, aka the thickness of the sides of the keycap. note this is the total thickness, aka 3 = 1.5mm walls
wall_thickness = 3;
/* [Brim] */
//brim radius. 11 ensconces normal keycap stem in normal keycap
brim_radius = 8;
//brim depth
brim_depth = .3;
//whether stabilizer connectors are enabled
stabilizers = false;
// stem offset in units NOT MM. for stepped caps lock basically
stem_offset = 0;
// font used for text
font="Arial";
// font size used for text
font_size = 8;
// whether or not to render fake keyswitches to check clearances
clearance_check = true;

/* [Key profile] */

// width of the very bottom of the key
bottom_key_width = 18.16;
// height (from the front) of the very bottom of the ke
bottom_key_height = 18.16;
// how much less width there is on the top. eg top_key_width = bottom_key_width - width_difference
width_difference = 6;
// how much less height there is on the top
height_difference = 4;
// how deep the key is, before adding a dish
total_depth = 11.5;
// the tilt of the dish in degrees. divided by key height
top_tilt = -6;
// how skewed towards the back the top is (0 for center)
top_skew = 1.7;
// what type of dish the key has. 0 for cylindrical, 1 for spherical, 2 for something else idk TODO
dish_type = 0;
// how deep the dish 'digs' into the top of the keycap. this is max depth, so you can't find the height from total_depth - dish_depth. besides the top is skewed anyways
dish_depth = 1;
// how skewed in the x direction the dish is
dish_skew_x = 0;
// how skewed in the y direction (height) the dish is
dish_skew_y = 0;
//length in units of key
key_length = 1;
//height in units of key. should remain 1 for most uses
key_height = 1;
//print brim for connector to help with bed adhesion
has_brim = false;
// invert dishing. mostly for spacebar
inverted_dish = false;
// array of positions of all stems. includes stabilizers as well, for now
// ternary is a bad hack to keep the stabilizers flag working
connectors = stabilizers ? [[0,0],[-50,0],[50,0]] : [[0,0]];
// whether or not we use the functions to generate an ISO enter
// NOTE this uses data in the profile so be sure to set the profile to ISO enter too
ISOEnter = false;
//should the key be rounded? unnecessary for most printers, and very slow
rounded_key = false;
// 'cherry', 'alps' or 'cherry_rounded'
stem_profile = "cherry";
// how much higher the stem is than the bottom of the keycap.
// inset stem requires support but is more accurate in some profiles
stem_inset = 0;
// how many degrees to rotate the stems. useful for sideways keycaps, maybe
stem_rotation = 0;
//text to be rendered in the center of the key, if any
text = "";
// is the text on the key inset? inset text is still experimental
inset_text = false;


/* [Hidden] */
$fs = .1;
//beginning to use unit instead of baked in 19.05
unit = 19.05;
//minkowski radius. radius of sphere used in minkowski sum for minkowski_key function. 1.75 default for faux G20
minkowski_radius = 1.75;
//radius of corners of keycap
corner_radius = 1.5;



// derived functions. can't be variables if we want them to change when the special variables do

// actual mm key width and height
function total_key_width() = $bottom_key_width + (unit * ($key_length - 1));
function total_key_height() = $bottom_key_height + (unit * ($key_height - 1));

// actual mm key width and height at the top
function top_total_key_width() = $bottom_key_width + (unit * ($key_length - 1)) - $width_difference;
function top_total_key_height() = $bottom_key_height + (unit * ($key_height - 1)) - $height_difference;

// bottom clipping shape we can use to anchor the stem, just a big ol cube with the inside of
// the keycap hollowed out
module inside(){
	difference(){
		//TODO why 50?
		translate([0,0,50]) cube([100000,100000,100000],center=true);
		shape(wall_thickness, keytop_thickness);
	}
}

// conicalish clipping shape to trim things off the outside of the keycap
// literally just a key with height of 2 to make sure nothing goes awry with dishing etc
module outside(thickness_difference){
	difference(){
		cube([100000,100000,100000],center = true);
		shape_hull(thickness_difference, 0, 2);
	}
}

// key shape including dish. used as the ouside and inside shape in key()
module shape(thickness_difference, depth_difference){
	difference(){
		union(){
			shape_hull(thickness_difference, depth_difference, 1);
			if ($inverted_dish) { dish(depth_difference); }
		}
		if (!$inverted_dish) {
			dish(depth_difference);
		} else {
		  // needed to trim the edges of an inverted dish
			inside();
		}
	}
}

// shape of the key but with soft, rounded edges. much more realistic, MUCH more complex. orders of magnitude more complex
module rounded_shape() {
	minkowski(){
		shape(minkowski_radius*2, minkowski_radius);
		difference(){
			sphere(r=minkowski_radius, $fn=24);
			translate([0,0,-minkowski_radius])
				cube([2*minkowski_radius,2*minkowski_radius,2*minkowski_radius], center=true);
		}
	}
}

// basic key shape, no dish, no inside
// modifier multiplies the height and top differences of the shape,
// which is only used for dishing to cut the dish off correctly
// $height_difference used for keytop thickness
module shape_hull(thickness_difference, depth_difference, modifier){
	if ($ISOEnter) {
		ISOEnterShapeHull(thickness_difference, depth_difference, modifier);
	} else {
		hull(){
			// $bottom_key_width + ($key_length -1) * unit is the correct length of the
			// key. only 1u of the key should be $bottom_key_width long; all others
			// should be 1u
			roundedRect([total_key_width() - thickness_difference, total_key_height() - thickness_difference, .001],corner_radius);

			//depth_difference outside of modifier because that doesnt make sense
			translate([0,$top_skew,$total_depth * modifier - depth_difference]){
				rotate([-$top_tilt / $key_height,0,0]){
					roundedRect([
						total_key_width()  - thickness_difference - $width_difference  * modifier,
						total_key_height() - thickness_difference - $height_difference * modifier,
						.001
					],corner_radius);
				}
			}
		}
	}
}

//dish selector
module dish(depth_difference){
	translate([$dish_skew_x, $top_skew + $dish_skew_y, $total_depth - depth_difference]){
		if($dish_type == 0){
			cylindrical_dish(top_total_key_width(), top_total_key_height(), $dish_depth, $inverted_dish, $top_tilt / $key_height);
		}
		else if ($dish_type == 1) {
			spherical_dish(top_total_key_width(), top_total_key_height(), $dish_depth, $inverted_dish, $top_tilt / $key_height);
		}
		else if ($dish_type == 2){
			sideways_cylindrical_dish(top_total_key_width(), top_total_key_height(), $dish_depth, $inverted_dish, $top_tilt / $key_height);
		}
		// else no dish
	}
}

module keytext() {
	extra_dish_depth = ($dish_type > 2) ? 0 : $dish_depth;
	extra_inset_depth = ($inset_text) ? keytop_thickness/4 : 0;

	translate([$dish_skew_x, $top_skew + $dish_skew_y, $total_depth - extra_dish_depth - extra_inset_depth]){
		rotate([-$top_tilt,0,0]){
			linear_extrude(height=$dish_depth){
				text(text=$text, font=font, size=font_size, halign="center", valign="center");
			}
		}
	}
}

module connectors($stem_profile) {
	difference() {
		for (connector_pos = $connectors) {
			translate([connector_pos[0], connector_pos[1], $stem_inset]) {
				rotate([0, 0, $stem_rotation]){
					connector($stem_profile);
					if ($has_brim) cylinder(r=brim_radius,h=brim_depth);
				}
			}
		}
		inside();
	}
}

//approximate (fully depressed) cherry key to check clearances
module clearance_check() {
	if(clearance_check == true && ($stem_profile == "cherry" || $stem_profile == "cherry_rounded")){
		color([1,0,0, 0.5]){
			translate([0,0,3.6 + $stem_inset - 5]) {
				%hull() {
					cube([15.6, 15.6, 0.01], center=true);
					translate([0,1,5 - 0.01]) cube([10.5,9.5, 0.01], center=true);
				}
				%hull() {
					cube([15.6, 15.6, 0.01], center=true);
					translate([0,0,-5.5]) cube([13.5,13.5,0.01], center=true);
				}
			}
		}
	}
}

module keytop() {
	difference(){
		if ($rounded_key) {
			rounded_shape();
		} else {
			shape(0, 0);
		}
		shape(wall_thickness, keytop_thickness);
	}
}


// The final, penultimate key generation function.
// takes all the bits and glues them together. requires configuration with special variables.
module key() {
	difference() {
		union(){
			keytop();
			if($stem_profile != "blank") connectors($stem_profile);
			if(!$inset_text) keytext();
			clearance_check();
		}
		if ($inset_text) keytext();
	}
}

// actual full key with space carved out and keystem/stabilizer connectors
// this is an example key with all the fixins
module example_key(){
	$bottom_key_width = bottom_key_width;
	$bottom_key_height = bottom_key_height;
	$width_difference = width_difference;
	$height_difference = height_difference;
	$total_depth = total_depth;
	$top_tilt = top_tilt;
	$top_skew = top_skew;
	$dish_type = dish_type;
	$dish_depth = dish_depth;
	$dish_skew_x = dish_skew_x;
	$dish_skew_y = dish_skew_y;
	$key_length = key_length;
	$key_height = key_height;
	$has_brim = has_brim;
	$inverted_dish = inverted_dish;
	$connectors = connectors;
	$ISOEnter = ISOEnter;
	$rounded_key = rounded_key;
	$stem_profile = stem_profile;
	$stem_inset = stem_inset;
  $stem_rotation = stem_rotation;
	$text = text;
	$inset_text = inset_text;

	key();
}

example_key();
//minkowski_key();















// Experimental stuff

// NOT 3D, NOT CENTERED
// corollary is roundedRect
module fakeISOEnter(thickness_difference){
    z = 0.001;
    radius = 2;
		// 1u is the space taken upy by a 1u keycap.
		// unit is the space taken up by a unit space for a keycap.
		// formula is 1u + unit *(length - 1)

		// t is all modifications to the polygon array
		// could do map but can scad even do map?
		t = radius + thickness_difference/2;

		function unit(length) = 19.02 * (length) + (18.16 - 19.02);

    pointArray = [
        [         0 + t,             0 + t],
        [unit(1.5)  - t,             0 + t],
        [unit(1.5)  - t,      unit(1)  - t],
        [unit(1.25) - t,      unit(1)  - t],
        [unit(1.25) - t,      unit(2)  - t],
        [         0 + t,      unit(2)  - t]
    ];

    minkowski(){
        circle(r=radius, $fn=24);
				polygon(points=pointArray);
    }
}

//corollary is shape_hull
module ISOEnterShapeHull(thickness_difference, depth_difference, modifier){
    function unit(length) = 19.02 * (length) + (18.16 - 19.02);
		height = 8 - depth_difference;

    translate([unit(-0.25), unit(.5)]) linear_extrude(height=height*modifier, scale=[.8, .9]){
        translate([unit(-.5), unit(-1.5)]) minkowski(){
            fakeISOEnter(thickness_difference);
        }
    }
}