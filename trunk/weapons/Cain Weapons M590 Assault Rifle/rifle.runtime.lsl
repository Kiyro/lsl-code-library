// runtime environment // ready jack // 13 Nov 2005 // v1.0

float delay = 3.0;
integer reset;
integer rezzed;
integer worn;
integer removed;

out(string message) {
    llWhisper(0, message);
    //llMessageLinked(LINK_SET, 0, "environment " + message, NULL_KEY);
}

default
{
    state_entry()
    {
        ++reset;
        if (llGetAttached()) ++worn;
        llSetTimerEvent(delay);
    }
    
    on_rez(integer param) 
    {
        ++rezzed;
        llSetTimerEvent(delay);
    }
    
    attach(key who)
    {
        if (who != NULL_KEY) {
            ++worn;
        } else {
            ++removed;
        }
        llSetTimerEvent(delay);
    }
    
    timer()
    {
        llSetTimerEvent(0);
        
        if (reset && !worn)
                out("reset on ground");
        else if (reset && worn)
        llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH);
                //out("reset while worn"); 
        else if (worn && rezzed && removed) 
        {
                llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH);
                //llSetScriptState("rifle.anims",TRUE);
                //out("worn from inventory");
            }
        else if (worn && rezzed && !removed) 
        {     
                llResetOtherScript("rifle.anims");
                llResetOtherScript("rifle.main");
        }
        else if (worn && !rezzed) 
        {
                llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH);
                //llSetScriptState("rifle.anims",TRUE);
                //out("worn from ground");
        }
        else if (!worn && !rezzed && removed) 
        {
                //out("dropped while attached");
                //llSetScriptState("rifle.anims",FALSE);
                llReleaseControls();
        }
        else out("unexpected runtime environment");
        
        worn = removed = rezzed = reset = 0;
    }
    run_time_permissions(integer perm)
    {
        llTakeControls(CONTROL_ML_LBUTTON | CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT,TRUE,TRUE);
    }
}
