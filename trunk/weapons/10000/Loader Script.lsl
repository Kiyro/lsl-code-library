integer loading = FALSE;
integer chan;

default
{
    state_entry()
    {
        llSetText("", <255,255,255>, 1.0);
        //Change this to whatever you like.
    }
    
    on_rez(integer start_param)
    {
        llOwnerSay("Connecting...");
        llSensor("Loader" + (string)llGetOwner(), NULL_KEY, SCRIPTED, 10, PI);
        //Checks if a loader is rezed
        chan = start_param;
    }
        
    sensor(integer num_detected)
    {
        llOwnerSay("Loader already rezed!");
        llDie();
        //If it is, kill this one.
    }
    
    no_sensor()
    {
        state connect;
        //This is the only loader, so continue
            
    }
}

state connect
{
    state_entry()
    {
        llListen(chan, "", NULL_KEY, "");
        llSetObjectName("Loader" + (string)llGetOwner());
        llSay(chan, "Connect");
        //Attempts to connect to the gun.
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "Connected" + (string)llGetOwner())
        {
            llSetObjectName("Loader");
            llOwnerSay("Connected!");
            state ready;
            //Connected
        }
    }
}

state ready
{
    state_entry()
    {
        llListen(2757, "", llGetOwner(), "");
        llListen(chan, "", NULL_KEY, "");
    }
    
    touch_start(integer total_number)
    {
        if (!loading)
        {
            llDialog(llDetectedKey(0), "Please make a selection.", ["Load", "Cancel"], 2757);
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id == llGetOwner())
        {
            if (message == "Load" && !loading)
            {
                loading = TRUE;
                llOwnerSay("Loading bullets, please wait...");
                llSetObjectName("Loader" + (string)llGetOwner());
                llSay(chan, "Readyload" + (string)llGetOwner());
            }
            else if (message == "Cancel" && !loading)
            {
                llOwnerSay("Loading Canceled");
                llDie();
            }
        }  
        else if (message == "Ready" + (string)llGetOwner())
        {
            //Gun has deleted its bullets, give it new ones.
            integer finding = TRUE;
            integer counter = 0;
            while (finding)
            {
                if (llGetInventoryName(INVENTORY_OBJECT, counter) != "" && counter < 12)
                {
                    llGiveInventory(id, llGetInventoryName(INVENTORY_OBJECT, counter));
                    counter ++;
                }
                else
                {
                    //Gave it all of our bullets
                    finding = FALSE;
                    llSay(chan, "Done" + (string)llGetOwner());
                    llSetObjectName("Loader");
                    llOwnerSay("Bullets have been loaded!");
                    llDie();
                }
            }
        }
    }
}