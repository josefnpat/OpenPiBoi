$fn = 128;

// Set to 0.01 for higher definition curves (renders slower)
$fs = 0.25;

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							sphere(r = radius);
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							rotate(a = rotate)
							cylinder(h = diameter, r = radius, center = true);
						}
					}
				}
			}
		}
	}
}

// These measurements are in mm
x = 101;
y = 50;
z = 17.2;

padding = 2;

bottom_z = z *3/4;
top_z = z *1/4;

display_w = 40;
display_h = 30;

button_size = 4;
dpad_thickness = 6;

ss_w = 6;
ss_h = 2;

// Extra size to ensure culling
bore = 0.125;

// Bottom
/**/
translate([0,0,0]){
    translate([-x/2,-y/2,0]) cube([x,y,padding]);
    translate([-x/2,-y/2,0]) cube([x,padding,bottom_z]);
    translate([-x/2, y/2-padding,0]) cube([x,padding,bottom_z]);
    translate([-x/2,-y/2,0]) cube([padding,y,bottom_z]);
    translate([ x/2-padding,-y/2,0]) cube([padding,y,bottom_z]);
}
/**/

// Top
translate([0,y+10,0]){ // Put the lide next to the base
//translate([0,0,z]){ // Put it on top
    rotate(a=[0,180,0]){ // Lid upside down
    //rotate(a=[0,0,0]){ // Lid on top
        
        difference(){
            
            // front plate  
            translate([-x/2,-y/2,-padding])
                cube([x,y,padding],apply_to="zmax");
            
            display_x_offset = (x - display_w)/2;
            display_y_offset = (y - display_h)/2;
            
            display_side_width = (x - display_w)/2;
            
            // screen
            translate(
                [-x/2+display_x_offset,-y/2+display_y_offset,-padding-bore])
                cube([display_w,display_h,padding+bore*2]);
            
            // Buttons
            
            button_a = display_w/2 + display_side_width / 3;
            translate([button_a,0,-padding/2])
                cylinder(h=padding+bore*2,r=button_size,center=true);
            button_b = display_w/2 + display_side_width * 2 / 3;
            translate([button_b,0,-padding/2])
                cylinder(h=padding+bore*2,r=button_size,center=true);
                
            // D-pad
            
            dpad_center = display_side_width / 2;
            
            translate([-display_side_width/2-display_w/2,0,-padding/2])
                cube([ dpad_thickness*3, dpad_thickness,padding+bore*2],center=true);

            translate([-display_side_width/2-display_w/2,0,-padding/2])
                cube([ dpad_thickness, dpad_thickness*3,padding+bore*2],center=true);
                
            // Select/start
            
            ss_center = -display_h/2 - (y - display_h)/4;
            
            translate([-ss_w,ss_center,-padding*1.5])
                cube([ss_w,ss_h,padding+bore*2+padding*2],center=true);
                
            translate([ss_w,ss_center,-padding*1.5])
                cube([ss_w,ss_h,padding+bore*2+padding*2],center=true);
            
        }
        
        // Edges
        
        
        translate([-x/2,-y/2,-top_z])
            cube([x,padding,top_z-padding]);
        translate([-x/2, y/2-padding,-top_z])
            cube([x,padding,top_z-padding]);
        translate([-x/2,-y/2,-top_z])
            cube([padding,y,top_z-padding]);
        translate([ x/2-padding,-y/2,-top_z])
            cube([padding,y,top_z-padding]);

        
        // Inlay edges
        
        translate([-x/2+padding,-y/2+padding,-top_z-padding])
            cube([x-padding*2,padding,top_z]);
        
        translate([-x/2+padding,y/2-padding*2,-top_z-padding])
            cube([x-padding*2,padding,top_z]);
        
        translate([-x/2+padding,-y/2+padding,-top_z-padding])
            cube([padding,y-padding*2,top_z]);
        
        translate([x/2-padding*2,-y/2+padding,-top_z-padding])
            cube([padding,y-padding*2,top_z]);
        
    }
}