default
{
    state_entry()
    {
        llListen(0, "", llGetOwner(), "");
    }

    listen(integer channel, string name, key id, string message)
    {
        if(message=="ignite"){
            llLoopSound("Crackling Fire",1);
        }
        if(message=="extinguish"){
            llStopSound();
        }
    }
            
    }

