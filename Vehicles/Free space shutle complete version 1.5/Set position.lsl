


default 
{ 
    touch_start(integer total_number) 
    {   
       
       
       
       if(llDetectedKey(0) == llGetOwner())
       
       {
            llPlaySound("3934ffab-f22e-a244-f9a3-d628e65aacf9",1);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.940, 76.520>]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.793, 76.440>]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.693, 76.340>]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.589, 76.150>]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.440, 76.025>]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.389, 75.910>]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.222, 75.733> ]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.189, 75.510>]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.942, 75.362>]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.889, 75.210>]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.732, 75.120>]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.589, 75> ]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.491, 74.929> ]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.389, 74.710>]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.289, 74.710>]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.189, 74.510>]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.036, 74.458>]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196,     74.343> ]);
            llSetPrimitiveParams([ PRIM_POSITION, <196.446, 195.933, 74.243> ]);
        }
        
        
        else if(AGENT )
         {
             llSay(0, "You are not the owner \n Please ask to the owner to activate the stair");
              llPlaySound("4660fd43-c2be-4a02-c0b8-c8fc7783394f",1);
     llSleep(9.99);
     llPlaySound("cb3c6372-c603-aadb-8f1a-45e3c6a5c9c2",1); 
     llSleep(7.37);     
   
     llStopSound();
             
          }  
            
            state phantom; 
        } 
} 
state phantom 
{ 
    touch_start(integer total_number) 
    {    
   
      
         
       
       if(llDetectedKey(0) == llGetOwner())
       
       {
        llPlaySound("3934ffab-f22e-a244-f9a3-d628e65aacf9",1);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 195.933, 74.243> ]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446,  196   ,  74.343> ]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.136, 74.458>]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.289, 74.510>]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.359, 74.610>]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.389, 74.710>]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.491, 74.929> ]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.589, 75> ]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.732, 75.120>]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.889, 75.210>]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 196.942, 75.362>]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.189, 75.510>]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.222, 75.733> ]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.389, 75.910>]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.440, 76.025>]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.589, 76.150>]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.693, 76.340>]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.793, 76.440>]);
        llSetPrimitiveParams([ PRIM_POSITION, <196.446, 197.807, 76.520>]);
          }
        
        else if(AGENT )
         {
             llSay(0, "You are not the owner \n Please ask to the owner to activate the stair");
              llPlaySound("4660fd43-c2be-4a02-c0b8-c8fc7783394f",1);
     llSleep(9.99);
     llPlaySound("cb3c6372-c603-aadb-8f1a-45e3c6a5c9c2",1); 
     llSleep(7.37);     
   
     llStopSound();
             
          }  
        
        
        state default; 
    } 
} 