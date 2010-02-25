string aim = "rifle.anim.aim";
string stand = "rifle.anim.standing";
integer mouselook;
integer on;
GetPerms(key id)
{
    if (llGetPermissions() != PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH)
    {
        llRequestPermissions(id,PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH);
    }
}
default
{
    state_entry()
    {
        llSetText("",<0,0,0>,0.0);
        GetPerms(llGetOwner());
        on = TRUE;
    }
    attach(key id)
    {
        if(id == NULL_KEY)
        {
            on = FALSE;
            llSetTimerEvent(0);
            llStopAnimation(aim);
            llStopAnimation(stand);
            state off;
        }
        else
        {
            GetPerms(llGetOwner());
            on = TRUE;
        }
    }
    on_rez(integer start_param)
    {
        GetPerms(llGetOwner());
    }
    run_time_permissions(integer perm)
    {
        
        llSetTimerEvent(1);
    }
    timer()
    {
        if(on && llGetPermissions() == PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS)
        {    
            if(llGetAgentInfo(llGetOwner()) & AGENT_MOUSELOOK)
            {
                llStopAnimation(stand);
                llStartAnimation(aim);
            }
            else
            {
                llStopAnimation(aim);
                llStartAnimation(stand);
            }
        }
    }
}
state off
{
    attach(key id)
    {
        if(id != NULL_KEY)
        {
            state default;
        }
    }
}
