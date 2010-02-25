// CATEGORY:Defense
// CREATOR:Wedensday Grimm
// DESCRIPTION:Anti-push script
// ARCHIVED BY:Ferd Frederix

// no mover
// Wednesday Grimm
// June 10, 2003
// 
// This script makes physical objects stay still
// if this script is on an object attached to your avatar, you can't be 
// pushed around
//
// THEY'RE NOT GOING TO PUSH YOU AROUND ANYMORE!!!
//

// True if we are staying still
integer nTarget;

// set up everything we need
startup()
{
    // listen to the owner for a command
    llListen(0, "", llGetOwner(), "");
    
    // we are not staying still at startup    
    nTarget = FALSE;
    llStopMoveToTarget();
}

default
{
    state_entry()
    {
        startup();        
    }
    
    on_rez(integer param)
    {
        startup();
    }
    
    listen(integer channel, string who, key id, string msg)
    {
        vector targetPos;
        if (msg == "lock")
        {
            // if we are not already staying still, start doing it
            if (nTarget == FALSE)
            {
                // where are we right now?
                targetPos = llGetPos();
                nTarget = TRUE;
                llMoveToTarget(targetPos, 2.0);
            }
        }
        else if (msg == "unlock")
        {
            // stop staying still
            llStopMoveToTarget();
            nTarget = FALSE;
        }
    }   
}// END //
