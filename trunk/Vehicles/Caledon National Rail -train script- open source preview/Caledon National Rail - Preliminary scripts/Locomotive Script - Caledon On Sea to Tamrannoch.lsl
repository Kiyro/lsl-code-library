// Train Script 526

//Desmond Shang

vector test;
vector test1;

vector pos;
vector globalloc;

rotation rot;

float smooth;
integer count;

setGlobalPos(vector globalDest) 
{
    vector localDest;
    do 
    {
        localDest = globalDest - llGetRegionCorner();
        llSetPos(localDest);
    } while (llVecDist(llGetPos(), localDest) > 0.1);
}

default 
{
    on_rez(integer start_param) 
    { 
         llResetScript(); 
    }   
        
    state_entry() 
    {

       rot = <0,0,0.7071,0.7071>;
       pos = <194.125,169.00,23.345>; 
       
       globalloc.x = 907*256+pos.x;  // Caledon On Sea
       globalloc.y = 1024*256+pos.y; // Caledon On Sea
       globalloc.z = pos.z;       
       
       
       smooth = 1.0;

       setGlobalPos(globalloc);              
       llSetRot(rot); 

       llSay(0,"Caledon National Railways #526 to Tamrannoch, leaving in 30 seconds!");
       llSay(0,"All Aboooooard!");


       llSleep(25);

       llPreloadSound("railclack1");
       llPreloadSound("whistle2");
       llSleep(5);
       llTriggerSound("whistle2", 1.0);
       llLoopSound("railclack1", 1.0);

       llSay(0,"Off we go!");

// leaving Caledon On Sea                                      
       count = 2;  
       while (count > 0)
       {
           globalloc.y = globalloc.y - smooth;
           setGlobalPos(globalloc);            
           count--;
       } // at y = 167
       llSay(1,"choo");
       
       count = 172;  // 167 - 168 goes to 255
       while (count > 0)
       {
           globalloc.y = globalloc.y - smooth;
           setGlobalPos(globalloc);            
           count--;
       }

       smooth = 0.2; // (5 times smaller increments)
       count = 80;  // 
       while (count > 0)
       {
           globalloc.y = globalloc.y - smooth;
           setGlobalPos(globalloc);            
           count--;
       }
       smooth = 1.0;

// synch after sim border (from 246)
       llSay(0,"Tamrannoch sim border Stop!");
       llSleep(15);
       llSay(1,"choo1"); 

       llTriggerSound("whistle2", 1.0);
       llLoopSound("railclack1", 1.0);

// now to go south along Tam street (y decreases from 182 to 74, southbound)

       count = 170;  // 246 - 170 = 76
       while (count > 0)
       {
           globalloc.y = globalloc.y - smooth;
           setGlobalPos(globalloc);            
           count--;
       }

       llTriggerSound("whistle2", 1.0);
       llSleep(3);
       llStopSound();

       llSay(0,"Welcome to Tamrannoch!  End of Line!");
       llSay(0,"Caledon National Railways #526 Derezzing in 30 seconds!");
       llSleep(30);
       llDie();

    }
}