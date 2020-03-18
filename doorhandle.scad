use <../Nuts_and_Bolts/files/nuts_and_bolts_v1.95.scad>;
translate([400,0,0])import ("../Doorhandle.STL");
cut_bit (10, 6);
    translate ([63, 0, 0]) conical_allen_bolt (20, 3, 6, 4, 0.2, 32, "metric", 1, 2.5, 10, 0.4);
    translate ([63, -10, 0]) conical_allen_bolt (4/5, 1/8, 1/4, 1/8, 1/128, 32, "imperial", 0, 3/32, 1/3, 45);
    translate ([63, -20, 0]) conical_allen_bolt (20, 3, 6, 4, 0.2, 32);
    
//  allen_bolt (lenght, thread_d, head_h, head_d, a_depth, tolerance, quality, bool_round, allen_o, thread, pitch);
    translate ([0, 0, 0]) allen_bolt (10, 3, 3.5, 5.5, 3, 0.2, 32, 1, 2.5, "metric", 0.425);
    translate ([0, -10, 0]) allen_bolt (10, 3, 3.5, 5.5, 3, 0.2, 32, 1, 2.5);
    translate ([0, -20, 0]) allen_bolt (10, 3, 3.5, 5.5, 3, 0.2, 32);

//  hex_bolt (lenght, thread_d, head_h, head_d, tolerance, quality, thread, pitch);
    translate ([10, 0, 0]) hex_bolt (3/8, 2/8, 1/8, 3/8, 1/128, 32, 1, "imperial", 28);
    translate ([10, -10, 0]) hex_bolt (3/8, 2/8, 1/8, 3/8, 1/128, 32, 1, "imperial");
    translate ([10, -20, 0]) hex_bolt (3/8, 2/8, 1/8, 3/8, 1/128, 32, 0, "imperial", 28);

//  grub_bolt (lenght, thread_d, a_depth, tolerance, quality, allen_o, thread, pitch);
    translate ([20, 0, 0]) grub_bolt (4, 3, 3, 0.2, 32, 1.5, "metric", 0.425);
    translate ([20, -10, 0]) grub_bolt (4, 3, 3, 0.2, 32, 1.5);
    translate ([20, -20, 0]) grub_bolt (4, 3, 3, 0.2, 32);

//  cone_head_bolt (lenght, thread_d, head_h, head_d, a_depth, tolerance, quality, allen_o, thread, pitch);
    translate ([30, 0, 0]) cone_head_bolt (10, 3, 1.5, 5.5, 2, 0.2, 32, 2, "metric", 0.425);
    translate ([30, -10, 0]) cone_head_bolt (10, 3, 1.5, 5.5, 2, 0.2, 32, 2);
    translate ([30, -20, 0]) cone_head_bolt (10, 3, 1.5, 5.5, 2, 0.2, 32);

//  hex_nut (height, thread_d, size, tolerance, quality, thread, pitch);
    translate ([40, 0, 0]) hex_nut (1/8, 1/4, 3/8, 1/128, 32, 1, "imperial", 28);
    translate ([40, -10, 0]) hex_nut (1/8, 1/4, 3/8, 1/128, 32, 1, "imperial");
    translate ([40, -20, 0]) hex_nut (1/8, 1/4, 3/8, 1/128, 32, 0, "imperial");

//  washer (outer, inner, width, tolerance, quality, thread);
    translate ([53, 0, 0]) washer (3/8, 3/16, 1/16, 1/128, 32, "imperial");
