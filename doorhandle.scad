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
knobrad = 0;
knoblen = 130.5;
luft = 1;

difference()
{
  union()
  {
    doorknob(lever = true);

    difference()
    {
      union()
      {
        doorknob(lever = false);

        translate([2*thick-2,0,(knobdia+thick)/2])
          rotate([0,20,0])
          armlever(w= width*.6, size=size, thick=thick, angle=20);

        ecken = [
          [0,0],
          [0,knobdia/2],
          [knobdia/1,knobdia/4],
        ];
          translate([4,0,knobdia+thick])
            rotate([0,-210,0])
            rotate([90,0,0])
            linear_extrude(height = 0.85*width, center = true, convexity = 10, scale=1.0)
            polygon(ecken);
      }
      scale([1.1,1.1,1.1])doorknob(lever = true);
    }
  }


  union()
  {
    translate([3.7*thick+.1,-knoblen/11,+1.7*knobdia])
      rotate([0,-78,0])
      metrische_schraube_schablone(typ = DIN7991 , mass= 5,laenge = 30, toleranz = 0.1);
    translate([3.7*thick+.1,knoblen/11,+1.7*knobdia])
      rotate([0,-78,0])
      metrische_schraube_schablone(typ = DIN7991 , mass= 5,laenge = 30, toleranz = 0.1);
    translate([3.7*thick+.1-2.0*thick,-knoblen/11,+1.75*knobdia])
      rotate([0,-78,0])
      metrische_mutter_schablone(4,30,  0.1, ueberlaenge=true);
    translate([3.7*thick+.1-2.0*thick,knoblen/11,+1.75*knobdia])
      rotate([0,-78,0])
      metrische_mutter_schablone(4,30,  0.1, ueberlaenge=true);
  }

}

module doorknob(lever = true)
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
      color("red")
        if(lever)
        {
          translate([-0.75*knobdia+0.5,0,0])
            cube([1.5*knobdia,knoblen+2,2*size],center = true);
        }
        else
        {
          translate([0.75*knobdia-0.5,0,0])
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

}
