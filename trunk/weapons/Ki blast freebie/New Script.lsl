//
//  Popgun
//
//  This script is a basic gun- it waits for a mouseclick in mouselook and
//  then fires a bullet in the direction the user is facing. 
//  It also animates the avatar holding it, to create a convining hold and 
//  firing look for the gun. 
// 
//  This script can be used as a good basis for other weapons. 
//  
integer CHANNEL = 50;
integer listenHandle;
float SPEED         = 50;

vector vel;                         //  Used to store velocity of arrow to be shot 
vector pos;                         //  Used to store position of arrow to be shot
rotation rot;                       //  Used to store rotation of arrow to be shot

integer have_permissions = FALSE;       
integer armed = TRUE;

integer Countdown = 0;                          
fire1()
{
        llSetTimerEvent(0.5);    
        rot = llGetRot();               //  Get current avatar mouselook direction
        vel = llRot2Fwd(rot);           //  Convert rotation to a direction vector
        pos = llGetPos();               //  Get position of avatar to create arrow
        pos = pos + vel;                //  Create arrow slightly in direction of travel
        pos.z += 0.75;                  //  Correct creation point upward to eye point 
                                        //  from hips,  so that in mouselook we see arrow 
                                        //  travelling away from the camera. 
        vel = vel * SPEED;              //  Multiply normalized vector by speed 
        llRezObject("Ki blast 1/3", pos, vel, rot,0); 
        llMessageLinked(LINK_SET,CHANNEL,"smalloff",NULL_KEY);
        llMessageLinked(LINK_SET,CHANNEL,"bigoff",NULL_KEY);
        llStopAnimation("readytoshoot");
}
//////////////////
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
        llPreloadSound("kamehameha_fire ( converted )");
    }

     run_time_permissions(integer permissions)
    {
        if (permissions == PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS)
        {
            if (!have_permissions)
            {
                llInstantMessage(llGetOwner(),"Enter mouse look, and hold the left mouse button down longer for more powerful Ki-Blasts");
            }
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
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
                llReleaseControls();
                llSetRot(<0,0,0,1>);
                have_permissions = FALSE;
            } 
        }
    }

control(key name, integer held, integer change) 
    {
integer HoldDown = CONTROL_ML_LBUTTON;



if (held == HoldDown)
            {
            llStartAnimation("readytoshoot");  
            llMessageLinked(LINK_SET,CHANNEL,"small",NULL_KEY);
            llMessageLinked(LINK_SET,CHANNEL,"smalloff",NULL_KEY);
            llMessageLinked(LINK_SET,CHANNEL,"big",NULL_KEY);
            }
    if (~held & change & HoldDown)
        {
            fire1();
            }
        }
}
 