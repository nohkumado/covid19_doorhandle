use <muttern934.scad>
function type2index(norm)=
          (norm == "DIN7991")? 0 :
          (norm == "ISO10642")? 1:
          (norm == "DIN965")? 2:
(norm == "DIN912")? 3:
(norm == "DIN933")? 4: 0;



// DIN7991 = 0;
// ISO10642 = 1;
// DIN965  = 2; //Phillips-Kreuzschlitz PH, DIN 965 (austauschbar mit ISO 7046) Technische Daten für DIN 965 
// DIN912 = 3; // zylinder Kopf Schrauben
// DIN933 = 4; //sechskantkopf


//the width of the rest
width = 50; 
// the height of the thing
size = 120; 
//the thickness, solidity of the knob enclosure
thick = 4;  
//the diameter of the knob
knobdia = 19; 
// the length of the knob (needed especially for courved knobs
knoblen = 135; 
// spacing between the jaws of the thing
luft = 1;     
// the mesure of the deviation from the straight line (together with the length its possible to compute the radius of the knb arc, e.g straigt = 0 , arc = 2.915
hub = 0;
//side on which the screws are
screwonleft = true;
//screws metric values!
screwsize = 6;//[1,1.2,1.6,2,2.5,3,4,5,6,8,10]
//screwtype screwnorm : e.g. DIN965/ISO 7046  = 2 (Phillips), DIN912 cylinder head, DIN933  Hexhead 
screwtype = "DIN7991";//["DIN7991","ISO10642","DIN965","DIN912","DIN933"]
//hex gives a hex nut cut, everything else nothing
nuttype = "none"; //["none","hex"]
//add maker logo
addLogo = true;


function radFromHub(sehne,hub) = (hub==0) ? 0 : (sehne /(2*sin(4*(90-atan(sehne/(2*hub))))));

//echo("alpha=",(size*360)/(2*PI*5*width));
//echo("sehne=",(asin(size/(2*5*width))));
//beta = atan(knoblen/(2*hub));
alpha = (hub ==0) ? 0 : 4*(90-atan(knoblen/(2*hub)));
//radius = knoblen /(2*sin(alpha));
knobrad = radFromHub(knoblen,hub);
//echo("rad = ",radius, "knobrad = ",knobrad, " beta = ",beta, " alpha = ",alpha);

$fn = 150;


//lever side
doorknob(lever = true, clear = 1,hexonleft = screwonleft, metrisch=screwsize,styp = type2index(screwtype), ntyp = nuttype, logo = addLogo)
{
   //put here the shape of your handlet will be diffed with  knob(knobdia+2*thick+2*luft, width,knobrad);
   knob(knobdia+luft, knoblen+2,2*knobrad);
}

//handle side
doorknob(lever = false, clear = 1,hexonleft = screwonleft, metrisch=screwsize,styp = type2index(screwtype), ntyp = nuttype, logo = false)
          knob(knobdia+luft, knoblen+2,2*knobrad);

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

module doorknob(lever = true, clear = 0.5,hexonleft = false,metrisch = 4, styp = type2index("DIN7991"), ntyp = "hex", logo = true)
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
          armlever(w= width, thick=thick, angle=beta, logo = logo);
        translate([rhx,0,rhz*knobdia]) outerHinge(dia=12, w=0.9*width);
      }
      else
      {
        translate([-thick,0,(knobdia+thick)/2-1])
          rotate([0,22,0])
          armlever(w= width*.6, thick=thick, angle=beta/3, logo= false);
        translate([lhx,0,lhz*knobdia]) innerHinge(dia=12, w=0.9*width);
      }
          flanschhoehe = max(0.8*knobdia,2*metrisch+4);
          flanschbreite = max(width,4*metrisch+20);
          flanschtiefe = max(4*thick,mschraubmass(styp,metrisch)[3]+mmuttermass(metrisch)[1]+2*clear+2*thick); 
          stiefe = max(30,flanschtiefe+10);
echo(str("act:",4*thick," vs ",flanschtiefe));
      difference()
      {
        union()
        {
          knob(knobdia+2*thick+2*luft, width,knobrad);
          echo(str("flansch daten (",metrisch,") ",4*thick),width,flanschhoehe,flanschbreite);
          translate([0,0,-knobdia-(flanschhoehe-0.8*knobdia)/2-metrisch*cos(30)/2])//flansch
            cube([flanschtiefe,flanschbreite,flanschhoehe+metrisch*cos(30)],center = true);
          //cube([4*thick,knoblen/2,0.8*knobdia],center = true);
        }
        union()
        {
          //color("magenta")
          children(); //the doorhandle shape to remove
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
          mittez =  -knobdia/2-flanschhoehe/2-metrisch*cos(30)/2;
          //mittez =  -knobdia/2-flanschhoehe/2-metrisch*cos(30);
          if(hexonleft)
          {
            if(ntyp == "hex")
            {
              translate([-flanschtiefe/2-.1,flanschbreite/4,mittez]) rotate([0,90,0]) metrische_mutter_schablone(metrisch,30, 0.1);
              translate([-flanschtiefe/2-.1,-flanschbreite/4,mittez]) rotate([0,90,0]) metrische_mutter_schablone(metrisch,30, 0.1);
            }

            translate([flanschtiefe/2+2,flanschbreite/4,mittez]) rotate([0,-90,0]) metrische_schraube_schablone(typ = styp , mass= metrisch,laenge = stiefe, toleranz = 0.1);
            translate([flanschtiefe/2+2,-flanschbreite/4,mittez]) rotate([0,-90,0]) metrische_schraube_schablone(typ = styp , mass= metrisch,laenge = stiefe, toleranz = 0.1);
          }
          else
          {
            if(ntyp == "hex")
            {
              //flanschtiefe = max(4*thick,mschraubmass(styp,metrisch)[3]+mmuttermass(metrisch)[1]+2*clear+2*thick); 
              translate([flanschtiefe/2-0.9*mmuttermass(metrisch)[1],flanschbreite/4,mittez]) rotate([0,90,0]) metrische_mutter_schablone(metrisch,30,  0.1);
              translate([flanschtiefe/2-0.9*mmuttermass(metrisch)[1],-flanschbreite/4,mittez]) rotate([0,90,0]) metrische_mutter_schablone(metrisch,30,  0.1);
            }
            translate([-flanschtiefe/2-0.1,flanschbreite/4,mittez])  rotate([0,90,0]) metrische_schraube_schablone(typ = styp , mass= metrisch,laenge = stiefe, toleranz = 0.1);
            translate([-flanschtiefe/2-0.1,-flanschbreite/4,mittez]) rotate([0,90,0]) metrische_schraube_schablone(typ = styp , mass= metrisch,laenge = stiefe, toleranz = 0.1);
          }
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



module armlever(w, thick, angle = 40, logo = true)
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
          if(logo)
        rotate([0,-angle/2,0])
          translate([0,0,1.6*width])
             makerLogo(size = .8*width, h=5);
}

module makerLogo(size = 80, h = 1)
{
color("red")
scale([1,size/80,size/80])
translate([0,-48,-45])
rotate([90,0,90])
         linear_extrude(height=h)
         import("logo_simpli.svg");
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
