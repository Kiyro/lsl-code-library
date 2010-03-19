vector targetPos = <13, 119, 40>; //The target location

reset()
{
    vector target;
    
    target = (targetPos- llGetPos()) * (ZERO_ROTATION / llGetRot());
    llSitTarget(target, ZERO_ROTATION);
    llSetSitText(llGetObjectName());
}
default
{
    state_entry()
    {
        reset();
    }
    
    on_rez(integer startup_param)
    {
        reset();
    }
    
    changed(integer change)
    {
        llUnSit(llAvatarOnSitTarget());
        reset();
    }    
}

