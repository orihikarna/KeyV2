module saddle_dish(width, height, depth, inverted) {
    $fa = 4;
    direction = inverted ? 1 : -1;
    hdepth = depth / 2;
    radius = height * height / (8 * hdepth) + hdepth / 2;
    xdivs = 16;
    dx = 1 / xdivs;
    intersection() {
        translate( [-width, -height, depth * (direction - 1)] )
            cube( [2 * width, 2 * height, 2 * depth] );
        translate( [0, 0, - direction * radius] )
            union() {
                for (nx = [-1:xdivs-1+1]) {
                    x0 = -0.5 + dx * nx;
                    x1 = -0.5 + dx * (nx + 1);
                    hull() {
                        translate( [width * x0 - 0.01, 0, direction * hdepth * ((x0 * x0) * 4 + 1)] )
                            rotate( [0, 90, 0] ) cylinder( dx / 8, radius, center = true );
                        translate( [width * x1 + 0.01, 0, direction * hdepth * ((x1 * x1) * 4 + 1)] )
                            rotate( [0, 90, 0] ) cylinder( dx / 8, radius, center = true );
                    }
                }
            }
    }
}
