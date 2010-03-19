integer auto;
integer barrel;

default
{
    state_entry()
    {
         if (llGetAttached() == 9)
         {
             barrel = 0;
             llStopSound();
             llPreloadSound("ed4a7a85-36d7-ab1a-c1ef-e421ad98d460");
             llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
         }
         else if (llGetAttached() != 0)
         {
             llDetachFromAvatar();
             llOwnerSay("Please attach me to the correct location (Spine)");
         }
    }
    
    attach(key id)
    {
        llResetScript();
    }
    
    run_time_permissions(integer perms)
    {
        if (perms & PERMISSION_TAKE_CONTROLS)
        {
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
        }
    }
    
    control(key id, integer hold, integer press)
    {
        if (CONTROL_ML_LBUTTON & press)
        {
            if (auto)
            {
                auto = FALSE;
                llSetTimerEvent(0);
                llStopSound();
            }
            
            else
            {
                auto = TRUE;
                llSetTimerEvent(0.05);
                llLoopSound("ed4a7a85-36d7-ab1a-c1ef-e421ad98d460", 0.5);
            }
        }
    }
    
    timer()
    {
        llMessageLinked(1, barrel, "DABullet", NULL_KEY);
        if (barrel > 4)
        {
            barrel = 1;
        }
        else
        {
            barrel ++;
        }
    }
    
    attach(key id)
    {
        llResetScript();
    }
}