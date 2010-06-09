// FLuer seat and control script
// By Jillian Callahan

//Please leave the credits intact!
//This script is NOT INTENDED FOR SALE! It's for learning about scripting!

string sitText = "Fly!"; // When someone wants to sit here, this replaces that "Sit" text in the pie menu
vector sittingPosition = <0.25,0, -.75>; //This is the position. X, Y, Z This is what you need to mess with.

key agentKey = NULL_KEY;
integer permissionResult = FALSE;
integer RUNNING = FALSE;
integer HOLD = FALSE;
integer open = 0;

init()
{
    llSetCameraEyeOffset(<-9.0, 0.0, 3.0>);
    llSetCameraAtOffset(<0.0, 0.0, 1.75>);
    llSetSitText(sitText);
    llSitTarget(sittingPosition,ZERO_ROTATION);
}

instruct()
{
    llOwnerSay("MOUSELOOK flyer. The mouse steers the plane (pitch and yaw).");
    llOwnerSay("WS (or arrows) to control the throttle.");
    llOwnerSay("EC (or PgUp and PgDn) to move vertically.");
    llOwnerSay("Shift AD (or shift left and right arrow) to hover laterally.");
    llOwnerSay("AD (or left and right arrow) in mouselook to hover laterally.");
//    llOwnerSay("Say \"h\" to toggle hold-position.");
    llOwnerSay("Say \"start\" to start the engines.");
    llOwnerSay("Say \"stop\" to stop the engines.");
}

default
{
    state_entry()
    {
        init();
    }

    on_rez(integer times)
    {
        init();
    }
    touch_start(integer num_times)
    {
        if(llDetectedKey(0) == llGetOwner())
        {
            if(open == 1)
            {
                llMessageLinked(LINK_SET, 0, "canopy_close", NULL_KEY);
                open = 0;
            }
            else
            {
                llMessageLinked(LINK_SET, 0, "canopy_open", NULL_KEY);
                open = 1;
            }
        }
    }
    changed(integer change)
    {
        if(change & CHANGED_LINK)
        {
            key av = llAvatarOnSitTarget();
            if( (av != NULL_KEY) && (agentKey == NULL_KEY) ) // Fresh sit
            {
                if (av == llGetOwner())
                {
                    agentKey = av;
                    llListen(0, "", agentKey, "");
                    llOwnerSay("Say \"START\" to begin piloting.");
                    llOwnerSay("Reminder: This is a MOUSELOOK flyer. You steer with the mouse!");
                }
                else
                {
                    llUnSit(av);
                    llSay(0, "Sorry, only my owner may pilot me.");
                }
            }
            else if ( (av == NULL_KEY) && (agentKey != NULL_KEY) ) // Probably stand
            {
                llSetStatus(STATUS_PHYSICS, FALSE);
                if (RUNNING)
                {
                    llSetTimerEvent(0.0);
                    llMessageLinked(1, 0, "pilot", NULL_KEY);
                }
                llResetScript();
            }
        }
    }
    
    listen(integer chan, string name, key id, string msg)
    {
        msg = llToLower(msg);
        if ( msg == "start" )
        {
            llMessageLinked(1, 0, "pilot", agentKey); // Tell the main script who;s piloting
            llSetStatus(STATUS_PHYSICS, TRUE);
            llSetTimerEvent(0.5);
            llOwnerSay("Say \"help\" for instructions.");
            RUNNING = TRUE;
            HOLD = FALSE;
            llMessageLinked(LINK_SET,0, "canopy_close", NULL_KEY);
            llOwnerSay("PCS is the primary combat system for this ship. It also supports DCS and CCC");
            llOwnerSay("Say \"pcs on\" to turn on PCS combat system");
            llOwnerSay("Say \"dcs on\" to turn on DCS combat system");
            llOwnerSay("Say \"ccc on\" to turn on CCC combat system"); 
            llOwnerSay("Say \"pcs off\", \"dcs off\" or \"ccc off\" to turn off combat");
            open = 0;
        }
        else if ( msg == "stop" )
        {
            llSetTimerEvent(0.0);
            llMessageLinked(1, 0, "pilot", NULL_KEY); // Tell the main script that we no longer have a pilot
            llSetStatus(STATUS_PHYSICS, FALSE);
            llOwnerSay("Shutdown complete.");
            RUNNING = FALSE;
            HOLD = FALSE;
            if(open == 0)
            {
                llMessageLinked(LINK_SET,0, "canopy_open", NULL_KEY);            
                llMessageLinked(LINK_SET,0, "wing_close", NULL_KEY);            
                open = 1;
            }
        }
        else if ( msg == "h" )
        {
            if (RUNNING)
            {
                if (HOLD)
                {
                    llSetStatus(STATUS_PHYSICS, TRUE);
                    llSetTimerEvent(0.5);
                    HOLD = FALSE;
                    llOwnerSay("Hold released.");
                }
                else
                {
                    llSetTimerEvent(0.0);
                    llSetStatus(STATUS_PHYSICS, FALSE);
                    HOLD = TRUE;
                    llOwnerSay("Hold active!");
                }
            }
        }
        else if ( msg == "help" )
        {
            instruct();
        }
        else if(msg == "ccc on" || msg == "dcs on" || msg == "pcs on")
        {
            llMessageLinked(LINK_SET,0, "wing_open", NULL_KEY);            
        }
        else if(msg == "ccc off" || msg == "dcs off" || msg == "pcs off")
        {
            llMessageLinked(LINK_SET,0, "wing_close", NULL_KEY);            
        }
            
    }
    
    timer()
    {
        if (!llGetStatus(STATUS_PHYSICS)) // Checks to make sure physics is still on.
        {
            llSetPos(llGetPos() + <0.0, 0.0, 1.0>); // if not, move up one meter and try turning it on
            llSetStatus(STATUS_PHYSICS, TRUE);
        }
    }
}