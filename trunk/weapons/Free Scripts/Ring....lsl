default
{
    state_entry()
    {
        llListen(0, "", llGetOwner(), "");
    }

    listen(integer channel, string name, key id, string message)
    {
        if(message=="ring"){
            llLoopSound("da73f914-c96a-7f5d-f4b4-6e4c711cba3d",1);
        }
        if(message=="hang up"){
            llStopSound();
        }
    }
            
    }

