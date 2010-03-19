
vector fwd;
vector pos;
rotation rot;  

key holder;             //  Key of avatar holding gun 
integer on = TRUE;

integer attached = FALSE;  
integer permissions = FALSE;
integer armed = TRUE;
key owner;

fire()
{
    if(armed)
    {
    //  
    //  Actually fires the ball 
    //  
    armed = FALSE;
    integer shot = llRound(llFrand(1.0));
    rot = llGetRot();
    fwd = llRot2Fwd(rot);
    pos = llGetPos();
    pos = pos + fwd;
    pos.z += 0.75;                  //  Correct to eye point
    fwd = fwd * 30.0;
    llSay(57, (string)owner + "shoot");
    llStartAnimation("shoot_L_bow");
    llTriggerSound(llGetInventoryName(INVENTORY_SOUND, shot), 0.8);
    llRezObject("arrow", pos, fwd, rot, 0); 
    llSetTimerEvent(2.0);
    }

    
}

default
{
    
    run_time_permissions(integer permissions)
    {
        if (permissions > 0)
        {
            llWhisper(0, "Enter Mouselook to shoot me, Say 'pickup' to pickup arrows, say 'id' to identify yours.");
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            llStartAnimation("hold_L_bow");
            attached = TRUE;
            permissions = TRUE;
            owner = llGetOwner();
        }
    }

    attach(key attachedAgent)
    {
        //
        //  If attached/detached from agent, change behavior 
        // 
        if (attachedAgent != NULL_KEY)
        {
            string name = llKey2Name(llGetOwner());
            
            on = TRUE;
            attached = TRUE;
            if (!permissions)
            {
                llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH);   
            }
            
        }
        else
        {
           
            attached = FALSE;
            llStopAnimation("hold_L_bow");
            llReleaseControls();
           

        }
    }

    control(key name, integer levels, integer edges) 
    {
        if (  ((edges & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON)
            &&((levels & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) )
        {
            fire();
        }
    }
    
    timer()
    {
        llSetTimerEvent(0.0);
        armed = TRUE;
    }
    
        
  
}
 