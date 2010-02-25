vector fwd;
vector pos;
rotation rot;  
float power = 1.0;
key holder;

vector centerpos;             //  Key of avatar holding gun 


integer attached = FALSE;  
integer permissions = FALSE;
//integer battlego;

fire_ball()
{
    //  
    //  Actually fires the ball 
    //  
    rot = llGetRot();
    fwd = llRot2Fwd(rot);
    pos = llGetPos();
    pos = pos + fwd;
    pos.z += 0.75;                  //  Correct to eye point
    fwd = fwd * 30.0;
    
    
    llRezObject("Harpoon", pos, fwd, rot, 2); 
    
}

default
{
   state_entry()
   {
       llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH); 
}
     on_rez(integer param)
    {
        //to deal with stack heap collision on re-rez
        llResetScript();
         
    }
    
    run_time_permissions(integer permissions)
    {
        if (permissions > 0)
        {
            llSay(0, "reel em in and kill em");
  
            
            if (!attached)
            {
                llAttachToAvatar(ATTACH_RHAND);
            }
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            //llListen(13, "", "", "");
            //llListen(14, "", "", "");
           // llShout(12, "posquery");
           // llSetTimerEvent(1.0);
            attached = TRUE;
            permissions = TRUE;
            //battlego = FALSE;
        }
    }
   // touch_start(integer total_number)
    //{
     //   if (!attached)
      //  {
            // 
            //  If clicked and not attached, ask to attach to avatar
            //
         //   key avatar = llDetectedKey(0);
         //   key owner = llGetOwner();
         //   if (owner == avatar)
         //   {
        //        llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH);  
      //      }
      //  }
       // llStopAnimation("hold_R_handgun");
       // llReleaseControls();
        //llSetTimerEvent(0.0);
       // llDetachFromAvatar();   

   // }

    attach(key attachedAgent)
    {
        //
        //  If attached/detached from agent, change behavior 
        // 
        if (attachedAgent != NULL_KEY)
        {
            //llTriggerSound("switch", 1.0);
            attached = TRUE;
            
            if (!permissions)
            {
                llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH);   
            }
            
        }
        else
        {
           
            attached = FALSE;
            llStopAnimation("hold_R_handgun");
            //llSetTimerEvent(0.0);
            llReleaseControls();
           

        }
    }

    control(key name, integer levels, integer edges) 
    {
        if (  ((edges & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON)
            &&((levels & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) )
        {
            //llWhisper(0, (string)battlego);
            //if(battlego)
            {
            llSetTimerEvent(1.0);
            llStartAnimation("throw_R");
            }
         
        }
    }
    
    timer()
    {
        llSetTimerEvent(0.0);
        fire_ball();
    }
    
    //timer()
   // {
        
    //    vector dist = llGetPos()-centerpos;
        
    //    float disp = llVecMag(dist);
        
    //    if(disp > 12)
    //    {
            
     //   llStopAnimation("aim_R_handgun");
     //   llStopAnimation("hold_R_handgun");
      //  llReleaseControls();
      //  llSetTimerEvent(0.0);
      //  llShout(0, llKey2Name(llGetOwner()) + " is Out.");
      //  llDetachFromAvatar();
      //  llDie();
      //  }
        
   // }
    
   // listen(integer i, string n, key id, string message)
   // {
    //    if(i == 14)
    //    {
    //        centerpos = (vector)message;
     //   }
     //   if(i == 13)
     //   {
      //      if(message == "go")
      //      {
      //          llWhisper(0, "online");
      //          battlego = TRUE;
        //    }
        //    else
       //     {
        //        battlego = FALSE;
       // //    }
       // }
    //}
  
}

