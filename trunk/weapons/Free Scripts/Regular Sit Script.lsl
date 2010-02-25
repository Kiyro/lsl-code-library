// Quick and dirty regularsit
// Ben Linden


default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }
    
    on_rez(integer param)
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        
    }
    
    run_time_permissions(integer perms)
    {
        if(perms)
        {
            llSetTimerEvent(1.0);
        }
        else
        {
            llSetTimerEvent(0.0);
        }
    }

    timer()
    {
        if(llGetAnimation(llGetOwner()) == "Sitting")
        {
            llStopAnimation("sit");
            llStartAnimation("sit_generic");
        }
        else
        {
            llStopAnimation("sit_generic");
        }
    }
}
