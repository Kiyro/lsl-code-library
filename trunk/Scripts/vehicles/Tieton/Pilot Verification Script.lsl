key avatar;
vector pos = <0.5, 0.0, -0.4>;  //adjust the position to fit object -must be 
//nonzero in at least one direction or script will not work!
rotation rot = ZERO_ROTATION; //adjust rotation (1 in any vector gives 90 deg)

default
{
    state_entry()
    {
        llSitTarget(pos, rot);
    }
    changed(integer change)
    {
        avatar = llAvatarOnSitTarget();
       if(change & CHANGED_LINK)
       {
           if(avatar == NULL_KEY)
           {
                //  You have gotten off
                llStopAnimation("sit");
                llReleaseControls();
                llResetScript();
           }
           else if(avatar == llAvatarOnSitTarget())
           {
                // You have gotten on
                llRequestPermissions(avatar,PERMISSION_TRIGGER_ANIMATION );   
           }
        }
    }
        run_time_permissions(integer perms)
        {
        if(perms)
        {
            llStopAnimation("sit");
            llStartAnimation("sit knees up2");
        }
        else
        {
            llUnSit(avatar);
        }
    }
}
