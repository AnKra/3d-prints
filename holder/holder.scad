

wall_thickness = 1;

tube_length = 31 + 2 * wall_thickness;
tube_depth = 25 + 2 * wall_thickness;
tube_height = 65;
cap_height = 7;

holder_depth = 15;
holder_height = 75;

minkowski_radius = 4;

module tube_shape(length, depth, height, translation) {
    minkowski() {
        translate([translation, translation, 0])
            cube([length - minkowski_radius, depth - minkowski_radius, height]);
        cylinder(r=minkowski_radius, h=1);
    };    
}

module tube(length, depth, height) {
    $fn=100;
    difference() {
        // outer shape
        tube_shape(length, depth, height, 0);
        
        // inner shape
        tube_shape(length - 2 * wall_thickness, depth - 2 * wall_thickness, height, wall_thickness);
    };
}

module holder(depth, height) {
    // horizontal part
    translate([0, tube_depth, tube_height])
        cube([tube_length - minkowski_radius, depth, wall_thickness]);

    // vertical part
    translate([0, tube_depth + depth, tube_height - height + wall_thickness])
        cube([tube_length - minkowski_radius, wall_thickness, height]);
}

module cap_shape(length, depth, height, translation) {
    translate([0.5 * (length - minkowski_radius) + translation, 0.5 * (depth - minkowski_radius) + translation, 0])
    rotate([180, 0, 0]) 
    linear_extrude(height = height, convexity = 10, scale=0.1, $fn=100)
    minkowski() {
        square([length - minkowski_radius, depth - minkowski_radius], center=true);
        circle(r=minkowski_radius);
    }
    cylinder(r=1);
}

module cap(length, depth, height) {
    $fn=100;
    difference() {
        // outer shape
        cap_shape(length, depth, height, 0);
        
        // inner shape
        cap_shape(length - 2 * wall_thickness, depth - 2 * wall_thickness, height, wall_thickness);
    };
}

tube(tube_length, tube_depth, tube_height);
holder(holder_depth, holder_height);
cap(tube_length, tube_depth, cap_height);
