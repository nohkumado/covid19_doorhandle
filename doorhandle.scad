use <muttern934.scad>
//import("muttern934.scad");
DIN7991 = 0;
ISO10642 = 1;
DIN965  = 2; //Phillips-Kreuzschlitz PH, DIN 965 (austauschbar mit ISO 7046) Technische Daten für DIN 965 
DIN912 = 3; // zylinder Kopf Schrauben


//translate([-30,0,0]) rotate([90,0,0])rotate([0,0,90])import ("../Doorhandle.STL");

//metrische_mutter_schablone(4,0,  0.1);
//DIN7991
//translate ([12,00,0])metrische_schraube_schablone(typ = 0 , mass= 5,laenge = 30, toleranz = 0.1);
//
width = 60;
size = 120;
thick = 4;
knobdia = 22.3;
knobrad = 0;
knoblen = 130.5;
luft = 1;


  translate([2*thick,0,(knobdia+thick)/2])
rotate([0,20,0])
  armlever(w= width, size=size, thick=thick);
difference()
{
  knob(knobdia+2*thick+2*luft, knoblen/2,knobrad);
  knob(knobdia+luft, knoblen+2,knobrad);
}






module armlever(w, size, thick, angle = 40)
{
  width = w/2;
  rund = width*.2;
  points = 
    [
    [0,0],
    [width-rund,0],
    [width,rund],
    [width-thick,rund+thick],
    [width-thick-rund,thick],
    [0,thick]
    ];
    cappoints = 
      [
      [0,0],
      [width-rund,0],
      [width,rund],
      [width-thick,rund+thick],
      [0,thick+thick]
      ];

      rotate([-90,0,0])
        translate([-5*width,0,0])
        rotate([0,0,-angle])
        translate([5*width,0,0])
        {
          translate([-5*width,0,0])
            rotate_extrude(angle=angle, convexity = 30,$fn=100)
            {
              translate([5*width,0,0])
                rotate([0,0,90])
                {
                  polygon(points);
                  mirror([1,0,0])polygon(points);
                }
            }

          translate([-5,0,0])
            rotate([0,90,-5])
            linear_extrude(height = 10, center = true, convexity = 10, scale=0.8)
            {
              polygon(cappoints);
              mirror([1,0,0])polygon(cappoints);
            }
        }
}


module knob(knobdia, len, knobrad)
{
  if(knobrad == 0)
  {
    translate([0,len/2,0])
      rotate([90,0,0])
      cylinder(d=knobdia, h=len);
  }

}
