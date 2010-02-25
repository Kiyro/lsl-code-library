
key owner;          
integer onoff = 0;  
default
{
    state_entry() 
    { 

        llPreloadSound("LightSaberIdle");
        llListen(0,"","","ls off");
        llListen(0,"","","ls on");

    }

    listen(integer channel, string name, key id, string message)
    {
        owner = llGetOwner();
        if (id == owner)
        {
            
            if ((message == "ls off") && (onoff == 1))
            {   
                llStopSound();
                onoff = 0;            
            }
            
            if ((message == "ls on") && (onoff == 0))
            {   
                llLoopSound("LightSaberIdle",1);
                onoff = 1;  
                           
            }
        }
    }
}