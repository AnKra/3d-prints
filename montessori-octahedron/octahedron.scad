
// Parameters
outside_base_edge_length = 50; // [mm]
wall_thickness = 1.2;          // [mm]

outside_height = (outside_base_edge_length / 2.0) * sqrt(2.0);

module outside_pyramid()
{
    linear_extrude(height = outside_height, center = false, convexity = 10, twist = 0, scale = 0, $fn = 100)
    square([outside_base_edge_length, outside_base_edge_length], center = true);
}

module inside_pyramid(wall_thickness_)
{
    inside_base_edge_length = outside_base_edge_length - (2.0 * wall_thickness_);
    inside_height = (inside_base_edge_length / 2.0) * sqrt(2.0);

    linear_extrude(height = inside_height, center = false, convexity = 10, twist = 0, scale = 0, $fn = 100)
    square([inside_base_edge_length, inside_base_edge_length], center = true);
}

difference()
{
    outside_pyramid();
    inside_pyramid(wall_thickness);
}

