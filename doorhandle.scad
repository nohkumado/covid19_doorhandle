use <muttern934.scad>
$fn = 150;
//import("muttern934.scad");
DIN7991 = 0;
ISO10642 = 1;
DIN965  = 2; //Phillips-Kreuzschlitz PH, DIN 965 (austauschbar mit ISO 7046) Technische Daten für DIN 965 
DIN912 = 3; // zylinder Kopf Schrauben


//
width = 50; //the width of the rest
size = 120; // the height of the thing
thick = 4;  //the thickness, solidity of the knob enclosure
knobdia = 19; //the diameter of the knob
knoblen = 135; // the length of the knob (needed especially for courved knobs
luft = 1;     // spacing between the jaws of the thing
hub = 2.915;  // the mesure of the deviation from the straight line (together with the length its possible to compute the radius of the knb arc
//hub = 0;


//echo("alpha=",(size*360)/(2*PI*5*width));
//echo("sehne=",(asin(size/(2*5*width))));
//beta = atan(knoblen/(2*hub));
alpha = (hub ==0) ? 0 : 4*(90-atan(knoblen/(2*hub)));
//radius = knoblen /(2*sin(alpha));
knobrad = radFromHub(knoblen,hub);
//echo("rad = ",radius, "knobrad = ",knobrad, " beta = ",beta, " alpha = ",alpha);

function radFromHub(sehne,hub) = (hub==0) ? 0 : (sehne /(2*sin(4*(90-atan(sehne/(2*hub))))));


//lever side
    doorknob(lever = true, clear = 1);

//handle side
    doorknob(lever = false, clear = 1);

/*
 knob,
 if you have a special shape, add it here!
*/
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
    rotate([0,-70,0])//change here 90 for perfecly vertical, 90-20, to have enough space to go trough with the arm
      translate([-knobrad,0,0])
      rotate([0,0,-alpha/2])
      rotate_extrude(angle=alpha)
      translate([knobrad,0,0])
      circle(d=knobdia);
  }


}

module doorknob(lever = true, clear = 0.5)
{
  lhx = 4;
  lhz = 1.665;
  rhx = 4;
  rhz = 1.665;
  difference()
  {
    union()
    {
    beta =(size*360)/(2*PI*5*width);
      if(lever)
      {
    //beta =asin(size/(2*5*width));
        //translate([2*thick+2,0,(knobdia+thick)/2])
        translate([thick+2,0,(knobdia+thick)/2])
          rotate([0,-10,180])
          armlever(w= width, thick=thick, angle=beta);
        translate([rhx,0,rhz*knobdia]) outerHinge(dia=12, w=0.9*width);
      }
      else
      {
        translate([-thick,0,(knobdia+thick)/2-1])
          rotate([0,22,0])
          armlever(w= width*.6, thick=thick, angle=beta/3);
        translate([lhx,0,lhz*knobdia]) innerHinge(dia=12, w=0.9*width);
      }
      difference()
      {
        union()
        {
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
          translate([2*thick-.1,knoblen/8,-knobdia])
            rotate([0,90,0])
            metrische_mutter_schablone(4,30,  0.1);
          translate([2*thick-1,-knoblen/8,-knobdia])
            rotate([0,90,0])
            metrische_mutter_schablone(4,30,  0.1);
          translate([-2*thick+2,knoblen/8,-knobdia])
            rotate([0,-90,0])
            metrische_schraube_schablone(typ = DIN7991 , mass= 4,laenge = 30, toleranz = 0.1);
          translate([-2*thick+2,-knoblen/8,-knobdia])
            rotate([0,-90,0])
            metrische_schraube_schablone(typ = DIN7991 , mass= 4,laenge = 30, toleranz = 0.1);

        }
      }
    }
    if(lever)
    {
color("magenta")
      translate([rhx,0,rhz*665*knobdia]) innerHinge(dia=12+clear, w=0.9*width);
    }
    else
    {
color("magenta")
      translate([lhx,0,lhz*knobdia]) outerHinge(dia=12+clear, w=0.86*width);
    }
  }
}



module armlever(w, thick, angle = 40)
{
  width = w/2;
  rund = width*.2;
  points = 
    [
    [0,0],
    [width-rund,0],
    [width,-rund],
    [width-thick,-rund-thick],
    [width-thick-rund,-thick],
    [0,-thick]
    ];
    cappoints = 
      [
    [0,0],
    [width-rund,0],
    [width,-rund],
    [width-thick,-rund-thick],
    [width-thick-rund,-rund-thick],
    [0,-rund-thick]
      ];

      rotate([-90,0,0])
        translate([-5*width-thick,0,0])
        rotate([0,0,-angle])
        translate([5*width,0,0])
        {
          translate([-5*width,0,0])
            rotate_extrude(angle=angle, convexity = 30,$fn=200)
            {
              translate([5*width,0,0])
                rotate([0,0,90])
                {
                  polygon(points);
                  mirror([1,0,0])polygon(points);
                }
            }

          translate([0,-thick,0])
            rotate([90,-90,-0])
            linear_extrude(height = 10, center = true, convexity = 10, scale=0.8)
            {
              polygon(cappoints);
              mirror([1,0,0])polygon(cappoints);
            }
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
      translate([0,w/4,0])
      rotate([90,0,0])
      cylinder(d=dia+.1, h=w/2);
    translate([0,w/4+1,0])
      rotate([90,0,0])
      cylinder(d=dia/2, h=w/2+2);
  }

}
