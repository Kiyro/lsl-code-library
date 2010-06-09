integer channel;
integer lastlisten;
integer leg = 1;

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

init() 
{
    llListenRemove(lastlisten);
    lastlisten = llListen(channel, "", NULL_KEY, "");
}

default
{
    on_rez(integer start_param) 
    { 
         llResetScript(); 
    }           
    
    state_entry()
    {
        channel = 1;
        init();

       rot = <0,0,0.7071,0.7071>;
       pos = <194.125,179.000,22.920>; 
       
       globalloc.x = 907*256+pos.x;  // Caledon On Sea
       globalloc.y = 1024*256+pos.y; // Caledon On Sea
       globalloc.z = pos.z;       
       
       
       smooth = 1.0;

       setGlobalPos(globalloc);              
       llSetRot(rot);                 
        
    }

    listen(integer channel, string name, key id, string message) 
    {
        if (message == "choo")
        {
            // leaving Caledon On Sea                                      
            count = 172;  // 179 - 172 = 7
            while (count > 0)
            {
                globalloc.y = globalloc.y - smooth;
                setGlobalPos(globalloc);            
                count--;
            }                

            smooth = 0.2; // (5 times smaller increments)
            count = 85;  //
            while (count > 0)
            {
                globalloc.y = globalloc.y - smooth;
                setGlobalPos(globalloc);            
                count--;
            }
            smooth = 1.0;
       }
        
        if (message == "choo1") // going to 194, 84
        {
            // flat out to Tam
           count = 170; 
           while (count > 0)
           {
               globalloc.y = globalloc.y - smooth;
               setGlobalPos(globalloc);            
               count--;
           }                

           llSleep(30);
           llDie();           
        }
    }       
}

