//
//  This basic script acts as a gun, by doing the following: 
//
//  Attach gun to right hand so that aiming animation is correct.
//

default
{
    run_time_permissions(integer perm)
    { 
        if (perm)
        {
            llAttachToAvatar(ATTACH_RHAND);
            llStartAnimation("motorcycle_sit");
        }
    }
    
    
    attach(key on)
    {
        if (on != NULL_KEY)
        {
            integer perm = llGetPermissions();
            
            if (perm != (PERMISSION_TRIGGER_ANIMATION | PERMISSION_ATTACH))
            {
                llRequestPermissions(on, PERMISSION_TRIGGER_ANIMATION | PERMISSION_ATTACH);
            }
            else
            {
                llStartAnimation("motorcycle_sit");
            }
            
        }
        else
        {
            llStopAnimation("motorcycle_sit");
        }
    }            
}
