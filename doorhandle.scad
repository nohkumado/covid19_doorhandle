use <muttern934.scad>
$fn = 150;
//import("muttern934.scad");
DIN7991 = 0;
ISO10642 = 1;
DIN965  = 2; //Phillips-Kreuzschlitz PH, DIN 965 (austauschbar mit ISO 7046) Technische Daten für DIN 965 
DIN912 = 3; // zylinder Kopf Schrauben


//
width = 60;
size = 120;
thick = 4;
knobdia = 22.3;
knobrad = 18.54;
knoblen = 135;
luft = 1;
hub = 2.915;

beta = atan(knoblen/(2*hub));
alpha = 4*(90-atan(knoblen/(2*hub)));
radius = knoblen /(2*sin(alpha));
//echo("rad = ",radius, " beta = ",beta, " alpha = ",alpha);




union()
{
 //lever side
 union()
 {
   doorknob(lever = true, clear = 1);
   translate([5,0,1.5*knobdia]) outerHinge(dia=12, w=0.9*width);
 }

  //handle side
  difference()
  {
    union()
    {
      doorknob(lever = false, clear = 1);

      translate([2*thick-2,0,(knobdia+thick)/2])
        rotate([0,20,0])
        armlever(w= width*.6, size=size, thick=thick, angle=20);

      ecken = [
        [0,0],
        [0,knobdia/2],
        [knobdia*1.0,knobdia/4],
      ];
        translate([2,0,knobdia+2*thick+2])
          rotate([0,-230,0])
          rotate([90,0,0])
          linear_extrude(height = 0.85*width, center = true, convexity = 10, scale=1.0)
          polygon(ecken);
        translate([5,0,1.5*knobdia]) innerHinge(dia=12, w=0.9*width);
    }
    scale([1.1,1.1,1.1])
      union()
      {
        doorknob(lever = true, clear = 0);
        translate([5,0,1.5*knobdia]) outerHinge(dia=12, w=0.9*width);
      }
  }
}



module doorknob(lever = true, clear = 0.5)
{
  translate([2*thick,0,(knobdia+thick)/2])
    rotate([0,20,0])
    armlever(w= width, size=size, thick=thick);
  difference()
  {
    union()
    {
      //knob(knobdia+2*thick+2*luft, knoblen/2,knobrad);
      knob(knobdia+2*thick+2*luft, width,knobrad);
      translate([0,0,-knobdia])
        cube([4*thick,width,0.8*knobdia],center = true);
      //cube([4*thick,knoblen/2,0.8*knobdia],center = true);
    }
    union()
    {
      knob(knobdia+luft, knoblen+2,knobrad);
        if(lever)
        {
          translate([-0.75*knobdia+clear,0,0])
            cube([1.5*knobdia,knoblen+2,2*size],center = true);
        }
        else
        {
          translate([0.75*knobdia-clear,0,0])
            cube([1.5*knobdia,knoblen+2,2*size],center = true);
        }
      translate([-2*thick-.1,knoblen/8,-knobdia])
        rotate([0,90,0])
        metrische_mutter_schablone(4,30,  0.1);
      translate([-2*thick-1,-knoblen/8,-knobdia])
        rotate([0,90,0])
        metrische_mutter_schablone(4,30,  0.1);
      translate([2*thick+.1,knoblen/8,-knobdia])
        rotate([0,-90,0])
        metrische_schraube_schablone(typ = DIN7991 , mass= 5,laenge = 30, toleranz = 0.1);
      translate([2*thick+.1,-knoblen/8,-knobdia])
        rotate([0,-90,0])
        metrische_schraube_schablone(typ = DIN7991 , mass= 5,laenge = 30, toleranz = 0.1);

    }
  }
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
else
  {
rotate([0,-90,0])
translate([-radius,0,0])
rotate([0,0,-alpha/2])
rotate_extrude(angle=alpha)
translate([radius,0,0])
circle(d=knobdia);
  }


}

module hinge(dia = 12,w = 10)
{

  //outer shell
  // translate([0,w/2,0])
  // rotate([90,0,0])
  //  cylinder(d=dia, h=w);
  //inner shell
  outerHinge(dia = dia,w = w);
  innerHinge(dia = dia,w = w);

}

module outerHinge(dia = 12,w = 10)
{

  difference()
  {
    translate([0,w/2,0])
      rotate([90,0,0])
      cylinder(d=dia, h=w);
    scale([1.05,1.05,1.05])innerHinge(dia = dia,w = w);
  }

}
module innerHinge(dia = 12,w = 10)
{

  difference()
  {
    color("red")
      translate([0,w/4,0])
      rotate([90,0,0])
      cylinder(d=dia+.1, h=w/2);
    translate([0,w/4+1,0])
      rotate([90,0,0])
      cylinder(d=dia/2, h=w/2+2);
  }

}
