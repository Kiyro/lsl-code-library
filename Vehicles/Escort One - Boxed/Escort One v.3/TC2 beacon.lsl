// Cubey's (very) simple vehicle beacon - Help prevent vehicle litter!
//
// January 03 2005 - Cubey Terra
// This script is free to copy, modify, and distribute. Share and enjoy!
//
// This script simply sends an IM at regular intervals to the owner.
// Any lost vehicles can be found. This reduces the number of stray
// vehicles that tend to litter the world.

// It can be used as-is to "ping" the owner every x number of hours.
// Simply place it in your vehicle and set the change the "hours" variable
// below to the number of hours between beacon pings.

// It also listens for link messages from other scripts in the object, 
// with which you can turn the beacon on/off and set the beacon interval.
//
// To turn on the beacon, use this link message in another script:
// llMessageLinked(LINK_SET, 0, "beacon on", "");
// The beacon is on by default.
//
// Similarly, to turn off the beacon, use this link message in another script:
// llMessageLinked(LINK_SET, 0, "beacon off", "");
//
// To set the interval in hours, use this link message in another script:
// llMessageLinked(LINK_SET, numberOfHours, "beacon interval", "");
// where numberOfHours is an integer indicating the number of hours (of course) :).
// 
// To get a status message, use this link message in another script:
// llMessageLinked(LINK_SET, numberOfHours, "beacon status", "");


integer hours = 24; // Number of hours between beacon IMs. Change this to suit your needs.


//No need to change anything below this line (unless you really want to, that is)
// ---------------------------------------------------------------------------

integer active = TRUE;
integer currentHours;

beaconStatus()
{
    if (active)        
    {
        llInstantMessage(llGetOwner(),"Beacon is ON. Message interval set to " + (string)hours + ". Next message in less than "+ (string)(hours - currentHours) + " hours. Hours elapsed since last message: " + (string)currentHours + ".");
    }
    else
    {
        llInstantMessage(llGetOwner(),"Beacon is OFF. Message interval set to " + (string)hours + ". You will not be messaged.");
    }
}

init()
{
    currentHours = 0;
    if (active) {llSetTimerEvent(3600);}
}

default
{
    state_entry()
    {
        init();
    }
    
    on_rez(integer num)
    {
        init();
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        string message = llToLower(str);
        
        // Listening for message to turn on or off.
        if (message == "beacon off")
        {
            active = FALSE;
            llSetTimerEvent(0.0);
            beaconStatus();
        }
        else if (message == "beacon on")
        {
            active = TRUE;
            currentHours = 0;
            llSetTimerEvent(3600); // 1 hour timer?
            beaconStatus();
        }
        
        // To set the beacon interval from an external script, send the link message
        // "beacon interval" and send the number of hours as an integer.
        else if (message == "beacon interval") 
        {
            hours = num;
            currentHours = 0;
            beaconStatus();
        }
        
        else if (message == "beacon status")
        {
            beaconStatus();
        }
    }
    
    timer()
    {
        if (active)
        {
            currentHours += 1;
            if (currentHours == hours)
            {
                vector pos = llGetPos();
                llInstantMessage(llGetOwner(),"Locator beacon: Your vehicle is located at " +  llGetRegionName() + "(" + (string)llRound(pos.x)+","+(string)llRound(pos.y)+") at an altitude of " + (string)llRound(pos.z) + " meters.");
                currentHours = 0;
            }
        }
    }
}
