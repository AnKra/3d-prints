//////////////////////////////////////////////////
// constants
//////////////////////////////////////////////////

trofast_rail_width = 8.5;
trofast_rail_height = 7.5;
trofast_rail_cover_thickness = 4;

hauck_rail_width = 20.5;
hauck_rail_height = 30;
hauck_rail_offset_x = 4;

total_width = hauck_rail_offset_x + hauck_rail_width + 4.1 + 2 * trofast_rail_width;
total_depth = 180;
total_height = hauck_rail_height + 40 + trofast_rail_height + trofast_rail_cover_thickness;

label_depth = 45;
label_offset_z = 13;

//////////////////////////////////////////////////
// useful variables
//////////////////////////////////////////////////

trofast_rail_depth = total_depth;
trofast_rail_offset_x = total_width - trofast_rail_width;
trofast_rail_offset_z = total_height - trofast_rail_height - trofast_rail_cover_thickness;

hauck_rail_depth = total_depth;

upper_cut_out_width = (total_width - trofast_rail_width) * 0.85;
upper_cut_out_depth = total_depth;
upper_cut_out_height = (total_height - hauck_rail_height) * 0.8;
upper_cut_out_offset_z = total_height;

lower_cut_out_width = (total_width - hauck_rail_width - hauck_rail_offset_x) * 0.9;
lower_cut_out_depth = total_depth;
lower_cut_out_height = (total_height - trofast_rail_height - trofast_rail_cover_thickness) * 0.9;
lower_cut_out_offset_x = total_width - lower_cut_out_width;

label_offset_y = (total_depth / 2) - (label_depth / 2);
label_width = hauck_rail_offset_x;
label_height = hauck_rail_height - label_offset_z;

//////////////////////////////////////////////////
// modules
//////////////////////////////////////////////////

module base_part(width, depth, height) {
    cube([width, depth, height], false);
}

module rail(width, depth, height, offset_x, offset_z) {
    translate([offset_x, 0, offset_z])
    cube([width, depth, height], false);
}

module upper_cut_out(l, w, h, offset_z) {
    l_factor = 0.6;
    difference() {
        translate([0, 0, offset_z - h])
        cube([l, w, h], false);
        prism(l_factor * l, w, h, (1. - l_factor) * l, offset_z - h);
    }
}

module prism(l, w, h, offset_x, offset_z) {
    CubePoints = [
      [ 0,  0,  0 ],  // 0
      [ l,  0,  0 ],  // 1
      [ l,  w,  0 ],  // 2
      [ 0,  w,  0 ],  // 3
      [ 0,  0,  0 ],  // 4*
      [ l,  0,  h ],  // 5
      [ l,  w,  h ],  // 6
      [ 0,  w,  0 ]   // 7*
    ];
    CubeFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      //[7,4,0,3] // left
    ];
    translate([offset_x, 0, offset_z])
    polyhedron(CubePoints, CubeFaces);
}

module label_cut_out(offset_y, width, depth, height) {
    translate([0, offset_y, 0])
    cube([width, depth, height], false);
}

//////////////////////////////////////////////////
// composition
//////////////////////////////////////////////////

difference() {
    base_part(total_width, total_depth, total_height);
    rail(trofast_rail_width, trofast_rail_depth, trofast_rail_height, trofast_rail_offset_x, trofast_rail_offset_z);
    rail(hauck_rail_width, hauck_rail_depth, hauck_rail_height, hauck_rail_offset_x, 0);
    upper_cut_out(upper_cut_out_width, upper_cut_out_depth, upper_cut_out_height, upper_cut_out_offset_z);
    prism(lower_cut_out_width, upper_cut_out_depth, lower_cut_out_height, lower_cut_out_offset_x, 0);
    label_cut_out(label_offset_y, label_width, label_depth, label_height);
}

