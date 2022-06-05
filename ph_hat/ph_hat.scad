//////////////////////////////////////////////////
// concept
//////////////////////////////////////////////////
//
//                             ........................
//                  ..............................................
//           ...........................................................
//       ................................ HAT ...............................
//    ..........................................................................
//  .............................................................................
//                           ||                        ||
//                           ||                        ||
//                          POLE                      POLE
//                           ||                        ||
//                           ||   ..................   ||
//                           ||   ..................   ||
//                           ||   ..... SCARF ......   ||
//                           ||   ..................   ||
//                           || **..................** ||
//                        ***||****.................***||***
//                            ********** FOOT **********

//////////////////////////////////////////////////
// constants
//////////////////////////////////////////////////

hat_diameter = 187;
hat_height = 20 / 3 * 10;
hat_wall_thickness = 1;
hat_fn = 300;  // 300

scarf_distance_to_hat = 25;
scarf_height = 60;
scarf_diameter = 44;
scarf_wall_thickness = 2;

foot_height = 4;
bulb_diameter = 60;  // alternative: 10
bulb_spacing = 10;

pole_outer_diameter = 8;
pole_inner_diameter = 3;
number_of_poles = 3;

print_hat = true;
print_foot = false;

//////////////////////////////////////////////////
// useful variables
//////////////////////////////////////////////////

scarf_radius = scarf_diameter / 2;

foot_diameter = bulb_diameter + 2 * bulb_spacing;
foot_radius = foot_diameter / 2;

pole_outer_radius = pole_outer_diameter / 2;
pole_inner_radius = pole_inner_diameter / 2;
pole_offset = foot_radius - pole_outer_radius;

//////////////////////////////////////////////////
// HAT ///////////////////////////////////////////
//////////////////////////////////////////////////

function sphere_outer_radius(hat_height, hat_diameter) = (hat_height / 2) + (pow(hat_diameter, 2) / (8 * hat_height));

function sphere_translation_z(sphere_outer_radius, hat_height) = sphere_outer_radius - hat_height;

module hat(hat_height, hat_diameter, hat_wall_thickness, hat_fn) {
    // calculate radius of outer shpere
    sphere_outer_radius = sphere_outer_radius(hat_height, hat_diameter);

    // calculate radius of inner shpere
    sphere_inner_radius = sphere_outer_radius - hat_wall_thickness;

    // occlude part of sphere by cube
    cube_size = 2 * sphere_outer_radius;

    sphere_translation_z = sphere_translation_z(sphere_outer_radius, hat_height);

    difference() {
        translate([0, 0, -sphere_translation_z])
        difference() {
            sphere(r=sphere_outer_radius, $fn=hat_fn);
            sphere(r=sphere_inner_radius, $fn=hat_fn);
        }
        translate([-0.5 * cube_size, -0.5 * cube_size, -cube_size])
        cube(size=cube_size, center=false);
    }
}

//////////////////////////////////////////////////
// POLES /////////////////////////////////////////
//////////////////////////////////////////////////

module pole(position_offset, height, outer_radius, inner_radius, x, y) {
    translate([x, y, -position_offset])
    difference() {
        cylinder(h=height, r=outer_radius, $fn=30);
        cylinder(h=height, r=inner_radius, $fn=30);
    }
}

module poles_raw(pole_offset, pole_height, pole_outer_radius, pole_inner_radius, pole_distance_from_center, number_of_poles) {
    alpha = 360 / number_of_poles;
    
    for ( i = [0 : number_of_poles - 1] ) {
        alpha_i = alpha * i;
        pole(
            pole_offset,
            pole_height,
            pole_outer_radius,
            pole_inner_radius,
            pole_distance_from_center * sin(alpha_i),
            pole_distance_from_center * cos(alpha_i)
        );
    }
}

module poles(scarf_distance_to_hat, scarf_height, hat_height, hat_diameter, pole_distance_from_center, number_of_poles, hat_height, hat_fn) {
    sphere_outer_radius = sphere_outer_radius(hat_height, hat_diameter);

    sphere_translation_z = sphere_translation_z(sphere_outer_radius, hat_height);
    
    pole_offset = scarf_distance_to_hat + scarf_height;
    pole_height = pole_offset + hat_height;

    // cut off the part of the poles which jut out of the hat
    difference() {
        poles_raw(pole_offset, pole_height, pole_outer_radius, pole_inner_radius, pole_distance_from_center, number_of_poles);
        translate([0, 0, -sphere_translation_z])
        difference() {
            sphere(r=sphere_outer_radius + hat_height, $fn=hat_fn);
            sphere(r=sphere_outer_radius, $fn=hat_fn);
        }
    }
}

//////////////////////////////////////////////////
// SCARF WITH FOOT ///////////////////////////////
//////////////////////////////////////////////////

module scarf(scarf_distance_to_hat, scarf_height, scarf_radius, scarf_wall_thickness) {
    cylinder_distance_to_hat = scarf_distance_to_hat + scarf_height;
    cylinder_radius_outer = scarf_radius + scarf_wall_thickness;
    cylinder_radius_inner = scarf_radius;

    difference() {
        translate([0, 0, -cylinder_distance_to_hat])
        cylinder(h=scarf_height, r=cylinder_radius_outer, $fn=100);
        translate([0, 0, -cylinder_distance_to_hat])
        cylinder(h=scarf_height, r=(cylinder_radius_inner), $fn=100);
    }
}

module foot(scarf_distance_to_hat, scarf_height, foot_height, foot_radius, scarf_radius) {
    cylinder_distance_to_hat = scarf_distance_to_hat + scarf_height + foot_height;
    cylinder_radius_outer = foot_radius;
    cylinder_radius_inner = scarf_radius;

    difference() {
        translate([0, 0, -cylinder_distance_to_hat])
        cylinder(h=foot_height, r=cylinder_radius_outer, $fn=100);
        translate([0, 0, -cylinder_distance_to_hat])
        cylinder(h=foot_height, r=cylinder_radius_inner, $fn=100);
        poles_raw(scarf_distance_to_hat + scarf_height + foot_height, 0.5 * foot_height, pole_outer_radius, 0, pole_offset, number_of_poles);
        poles_raw(scarf_distance_to_hat + scarf_height + 0.5 * foot_height, 0.5 * foot_height, pole_inner_radius, 0, pole_offset, number_of_poles);
    }    
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

if(print_hat) {
    hat(hat_height, hat_diameter, hat_wall_thickness, hat_fn);
    poles(scarf_distance_to_hat, scarf_height, hat_height, hat_diameter, pole_offset,   number_of_poles, hat_height, hat_fn);
}

if(print_foot) {
    scarf(scarf_distance_to_hat, scarf_height, scarf_radius, scarf_wall_thickness);
    foot(scarf_distance_to_hat, scarf_height, foot_height, foot_radius, scarf_radius);
}
