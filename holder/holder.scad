

wall_thickness_tube = 1;
wall_thickness_holder = 2;

tube_length = 26 + 2 * wall_thickness_tube;
tube_depth = 20 + 2 * wall_thickness_tube;
tube_height = 65;

cap_angle = 55;
a = 0.5 * tube_length;
cap_height = tan(cap_angle) * a ;

holder_depth = 15;
holder_height = 35;

minkowski_radius = 4;

module tube_shape(length, depth, height, translation) {
    minkowski() {
        translate([translation, translation, 0])
            cube([length - minkowski_radius, depth - minkowski_radius, height]);
        cylinder(r=minkowski_radius, h=1);
    };    
}

module tube(length, depth, height, wall_thickness) {
    $fn=100;
    difference() {
        // outer shape
        tube_shape(length, depth, height, 0);
        
        // inner shape
        tube_shape(length - 2 * wall_thickness, depth - 2 * wall_thickness, height, wall_thickness);
    };
}

module holder(depth, height, wall_thickness) {
    // horizontal part
    translate([0, tube_depth, tube_height - wall_thickness_tube])
        cube([tube_length - minkowski_radius, depth, wall_thickness]);

    // vertical part
    translate([0, tube_depth + depth, tube_height - height - wall_thickness_tube + wall_thickness])
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

module cap(length, depth, height, wall_thickness) {
    $fn=100;
    difference() {
        // outer shape
        cap_shape(length, depth, height, 0);
        
        // inner shape
        cap_shape(length - 2 * wall_thickness, depth - 2 * wall_thickness, height, wall_thickness);
    };
}

tube(tube_length, tube_depth, tube_height, wall_thickness_tube);
holder(holder_depth, holder_height, wall_thickness_holder);
cap(tube_length, tube_depth, cap_height, wall_thickness_tube);
