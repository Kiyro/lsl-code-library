string aim = "rifle.anim.aim";
string stand = "rifle.anim.standing";
integer defaultanims = FALSE;
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
            if(defaultanims)
            {
                llStopAnimation("hold_r_rifle");
            }
            else
            {
                llStopAnimation(aim);
                llStopAnimation(stand);
            }
            state off;
        }
        else
        {
            GetPerms(llGetOwner());
            if(llGetPermissions() == PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH && defaultanims)
            {
                llStartAnimation("hold_r_rifle");
            }
            on = TRUE;
        }
    }
    on_rez(integer start_param)
    {
        GetPerms(llGetOwner());
    }
    run_time_permissions(integer perm)
    {
        if(defaultanims)
        {
            llStartAnimation("hold_r_rifle");
        }
        else
        {
            llSetTimerEvent(1);
        }
    }
    timer()
    {
        if(on && llGetPermissions() == PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS)
        {    
            if(llGetAgentInfo(llGetOwner()) & AGENT_MOUSELOOK && !defaultanims)
            {
                llStopAnimation(stand);
                llStartAnimation(aim);
            }
            else if(!defaultanims)
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
