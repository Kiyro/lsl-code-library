//Acceleration curve for forward motion
//This determines how fast much force to accelerate with, based on your current speed.

float debug(string msg)
{
    if (debugmessages) 
        llWhisper(0,msg);
        return TRUE;
}

float power_curve(float speed)
{
    //sh added to stop fast speeds close to ground
    if (low) 
    {
        debug("too low for speed increase");
        return 0.0;
    }   
    if (speed < 3) //when speed is less than 3 multiply extra force by 0;
    {
        debug("speed less than 3");
        return 0.0;
    }
    if (speed < 5) // sh speed < 5
    {
        //if (after_burner != 1) 
        //    sonic = TRUE;
        
        debug("speed less than 5");
                    //sh changed from 8.0 to 0.0
        return 8.0; //when speed between 3 and 5  multiply extra force by 8;
    }
    if (speed < 10) 
    {
        debug("speed less than 10");
        return 15.0; //when speed is between 5 and 10 multiply extra force by 15;
    }
    if (speed < 15)
    { 
        debug("speed less than 20");
        return 20.0;
    }
    if (speed < 20) 
    {
        debug("speed less than 20");
        return 40.0;
    }
    if (speed < 25) 
    {
        debug("speed less than 25");
        return 60.0;
    }
    if (speed < 30) 
    {
        debug("speed less than 30");
        return 100.0;
    }
    if (speed > 45) // && sonic) 
    {
        //sonic = FALSE;
        debug("speed greater than 45");
        //llTriggerSound("sonic_boom", 10);
    }
return 200;
}
//integer sonic = FALSE;    
integer sonic = TRUE;         // default when enabled (wn)
integer moving = FALSE;
//integer moving = TRUE;
//integer after_burner = 1;
integer after_burner = 10;    //default for wings enabled (wn)
integer low = TRUE;
integer low_message_sent = 3; //set to dumb value
integer debugmessages = FALSE;
key gOwner;

default
{
       
    state_entry()
    {
        gOwner = llGetOwner();
         integer deactive_key = llListen(0,"",gOwner, "");
         
         llSetTimerEvent(1);

         llWhisper(0,"Angel Wings modified Psyke v0.2");
         integer debugmessages = FALSE;
    } 
    
    timer()
    {
        vector pos = llGetPos();
            float ground = pos.z - llGround(ZERO_VECTOR);
           
           // LOW ALTITUDE //
            if (ground < 30)
            {   
                low = TRUE;
                if (low_message_sent != TRUE)
                {
                    low_message_sent = TRUE;
                    llWhisper(0,"Low Altitude: Speed increase disabled");   
                }
                    
            }
            // HIGH ALTITUDE //
            else
            {   
                low = FALSE; 
                if (low_message_sent != FALSE)
                {
                    low_message_sent = FALSE;
                    llWhisper(0,"High Altitude: Speed increase enabled!");   
                }
            }    
            
            if (ground > 35) 
            {
                llSetForce(<0,0,llGetMass()*9.8>,FALSE);
                
            }
            else
            {
                llSetForce(<0,0,0>,FALSE);
            }
            
           
        }
            
        
    
    on_rez(integer start_param)
    {
      gOwner = llGetOwner();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "wn") 
        {
            llWhisper(0, "Speed increase enabled.");
            after_burner = 10;
            sonic = TRUE;
        }
        if (message == "wf")
        {
            after_burner = 1;
            sonic = FALSE;   
            llWhisper(0, "Speed increase disabled.");
        }
    
    }

    attach(key on)
    {
        gOwner = llGetOwner();
        if (on != NULL_KEY)
        {
            //llLoopSound("boom", 1.0);
            moving = TRUE;
            integer perm = llGetPermissions();
            
            if (perm != (PERMISSION_TAKE_CONTROLS))
            {
                llRequestPermissions(on, PERMISSION_TAKE_CONTROLS);
            }
            else
            {
                llTakeControls(CONTROL_FWD | CONTROL_ML_LBUTTON, TRUE, TRUE);
            }
        }
        else
        {
            moving = FALSE;
            llStopSound();
            llReleaseControls();
        }
    }

    run_time_permissions(integer perm)
    {
        if (perm)
        {
            llTakeControls(CONTROL_FWD | CONTROL_ML_LBUTTON, TRUE, TRUE);
        }
    }
    
    control(key owner, integer level, integer edge)
    {
        // Look for the jump key going down for the first time.
        if (!(level & CONTROL_FWD))
        {
             llSetForce(<0,0,0>, FALSE);
             llSetTimerEvent(1);
            
        }
        else
        {
            vector fwd;
            //fwd = unit vector pointing in the direction your facing
            llSetTimerEvent(0);
            fwd = llRot2Fwd(llGetRot());
           
              
              //llWhisper(0, (string) llVecMag(llGetVel()));  //speedometer debugger
            
            
            //This determines your force: power_curve(float speed)  is the function from the top
            // It returns the force that should be used. llVecMag() returns your vector velocity
            //llVecMag(vector) get the magnitude of the vector, in this case your speed.
            
            fwd *= 10 * after_burner * power_curve( llVecMag(llGetVel()) ); 
            
            llSetForce(fwd, FALSE);
        }
        
        if (  ((level & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON)
            &&((edge & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON))
        {
            rotation rot = llGetRot();
            vector fwd;
            fwd = llRot2Fwd(rot);
            fwd = llVecNorm(fwd);
            vector offset = llGetPos();
            offset.z -= 1.0;
            rotation delta = llEuler2Rot(<0, PI_BY_TWO, 0>);
            rot = delta * rot;
            
        }
    }
    
}
