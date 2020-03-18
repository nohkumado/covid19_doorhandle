/*

   Sechskantmuttern nach DIN 934
   change the m variable below to adjust to the M value you want
   startw is the angle to add, if you want a certain orientation of the nut shape

   add use <muttern934.scad> in your source to add this library

 */


//example
//metrische_mutter_schablone(m, 30, 0.1);

//name dicke zangenbreite
masse = [
  [1,  0,8,2,5], //M1
  [1.2,    1, 3], //M1.2
  [1.4,    1,2, 3	 ], //M1.4
  [1.6,    1,3, 3,2], //M1.6
  [1.7,    1,4, 3,5], //M1.7
  [2,    1,6, 4	 ], //M2
  [2.3,    1,8, 4,5], //M2.3
  [2.5,  2, 5], //M2.5
  [2.6,  2, 5], //M2.6
  [3,  2.4, 5.5], //M3
  [3.5,  2.8, 6  ], //M3.5
  [4  ,  3.2, 7  ], //M4  
  [5  ,  4  , 8  ], //M5  
  [6  ,  5  , 10 ], //M6  
  [7  ,  5.5, 11 ], //M7  
  [8  ,  6.5, 13 ], //M8  
  [10 ,  8  , 17 ], //M10 
  [12 ,  10 , 19 ], //M12 
  [14 ,  11 , 22 ], //M14 
  [16 ,  13 , 24 ], //M16 
  [18 ,  15 , 27 ], //M18 
  [20 ,  16 , 30 ], //M20 
  [22 ,  18 , 32 ], //M22 
  [24 ,  19 , 36 ], //M24 
  [26 ,  22 , 41 ], //M26 
  [27 ,  22 , 41 ], //M27 
  [30 ,  24 , 46 ], //M30 
  [33 ,  26 , 50 ], //M33 
  [36 ,  29 , 55 ], //M36 
  [39 ,  31 , 60 ], //M39 
  [42 ,  34 , 65 ], //M42 
  [45 ,  36 , 70 ], //M45 
  [48 ,  38 , 75 ], //M48 
  [50 ,  38 , 75 ], //M50 
  [52 ,  42 , 80 ], //M52 
  [56 ,  45 , 85 ], //M56 
  [60 ,  48 , 90 ], //M60 
  [64 ,  51 , 95 ], //M64 
  [68 ,  54 , 100], //M68 
  [72 ,  58 , 105], //M72 
  [76 ,  61 , 110], //M76 
  [80 ,  64 , 115], //M80 
  [85 ,  68 , 120], //M85 
  [90 ,  72 , 130], //M90 
  [95 ,  75 , 135], //M95 
  [100,  80 , 145], //M100
  [105,  82 , 150], //M105
  [110 ,  88 , 155], //M110 
  [120 ,  95 , 175], //M120 
  ];

module metrische_mutter_schablone(mass,startw = 30, toleranz = 0)
{
  winkel = 360/6;		// 6 Ecken

  data = masse[search(mass, masse, num_returns_per_match=0, index_col_num=0)[0]];
  echo("benutze Daten ",data);

  sechseck= [for(i = [1 : 6]) [
    (data[2]+toleranz)*cos(i*winkel+startw), (data[2]+toleranz)*sin(i*winkel+startw)] ];
  linear_extrude(height = data[1]+2*toleranz) polygon(sechseck);
}
