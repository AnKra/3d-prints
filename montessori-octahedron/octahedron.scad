
//
// The octahedron consists of two hollow pyramids which can be glued together later on.
//

outside_base_edge_length = 50; // 50 mm
wall_thickness = 1.2;          // 1.2 mm
add_hole_for_hanging = false;  // false by default, can be set to true for the upper pyramid of octahedron so that the final octahedron can be hung on a string

outside_height = (outside_base_edge_length / 2.0) * sqrt(2.0);

module outside_pyramid() {
    linear_extrude(height = outside_height, center = false, convexity = 10, twist = 0, scale = 0, $fn = 100)
    square([outside_base_edge_length, outside_base_edge_length], center = true);
}

module inside_pyramid(wall_thickness_) {
    inside_base_edge_length = outside_base_edge_length - (2.0 * wall_thickness_);
    inside_height = (inside_base_edge_length / 2.0) * sqrt(2.0);

    linear_extrude(height = inside_height, center = false, convexity = 10, twist = 0, scale = 0, $fn = 100)
    square([inside_base_edge_length, inside_base_edge_length], center = true);
}

$fn=50;
module hollow_pyramid() {
    minkowski() {
        cylinder(r=1, h=0.1);
        difference() {
            outside_pyramid();
            inside_pyramid(wall_thickness);
        }
    }
}

if(add_hole_for_hanging) {
    difference() {
        hollow_pyramid();
        translate ([0, outside_base_edge_length / 2.0, 0.8 * outside_height]) rotate ([90, 0, 0]) cylinder (h = outside_base_edge_length, r = 1.0, center = false, $fn = 100);
    }
} else {
    hollow_pyramid();
}
