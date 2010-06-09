//
// Semi Auto Script
//  

float SPEED         = 75.0;         
integer LIFETIME    = 10;             
                                    
float DELAY         = 0.2;           

vector vel;                          
vector pos;                         
rotation rot;                       

integer have_permissions = FALSE;                            
integer armed = TRUE;       
string instruction_not_held = 
                          "Choose 'Acquire->attach->left hand' from my menu to wear and use me.";
                                    

fire()
{
    if (armed)
    {
        armed = FALSE;
        rot = llGetRot();               
        vel = llRot2Fwd(rot);           
        pos = llGetPos();               
        pos = pos + vel;               
        pos.z += 0.75;                 
                                        
                                         
        vel = vel * SPEED;       
        
        
        llTriggerSound("Report", 1.0); 
        llRezObject("Bullet", pos, vel, rot, LIFETIME); 
                                    
                                            
        llSetTimerEvent(DELAY);         
    }
}

default
{
    state_entry()
   
    {
        if (!have_permissions) 
        {
            llRequestPermissions(llGetOwner(),  
                PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS);   
        }
    }
    on_rez(integer param)
    {
        
        llPreloadSound("Report");        
    }

     run_time_permissions(integer permissions)
    {
       
        if (permissions == PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS)
        {

            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            llStartAnimation("hold_R_rifle");
            have_permissions = TRUE;
        }
    }

    attach(key attachedAgent)
    {
       
        if (attachedAgent != NULL_KEY)
        {
            
            llRequestPermissions(llGetOwner(),  
                PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS);   
        }
        else
        {
           
            if (have_permissions)
            {
                llStopAnimation("hold_R_rifle");
                llStopAnimation("aim_R_rifle");
                llReleaseControls();
                llSetRot(<0,0,0,1>);
                have_permissions = FALSE;
            }
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
    
    touch_end(integer num)
    {
        
        if (have_permissions) 
        {
;        }
        else 
        {   
            llWhisper(0, instruction_not_held);
        }
    }
    
    timer()
    {
       
        llSetTimerEvent(0.0);
        armed = TRUE;
    }
  
}
 