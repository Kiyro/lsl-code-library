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
integer maxammo = 100;
integer ammo = 100;
float SPEED         = 65.0;         //  Speed of arrow in meters/sec
integer LIFETIME    = 7;            //  How many seconds will bullets live 
                                    //  before deleting themselves
float DELAY         = 0.02;          //  Delay between shots to impose 

vector vel;                         //  Used to store velocity of arrow to be shot 
vector pos;                         //  Used to store position of arrow to be shot
rotation rot;                       //  Used to store rotation of arrow to be shot

integer have_permissions = FALSE;   //  Indicates whether wearer has yet given permission 
                                    //  to take over their controls and animation.
                                    
integer armed = TRUE;               //  Used to impose a short delay between firings

string instruction_held_1 = "Use Mouselook (press 'M') to shoot me.";
string instruction_held_2 = "Choose 'Detach' from my menu to take me off.";
                                    //  Echoed to wearer when they are holding the bow
string instruction_not_held = 
                          "Choose 'Acquire->attach->left hand' from my menu to wear and use me.";
                                    //  Echoed to toucher if not worn
                                    

fire()
{
    if(armed == TRUE)
    {
        rot = llGetRot();               //  Get current avatar mouselook direction
        vel = llRot2Fwd(rot);           //  Convert rotation to a direction vector
        pos = llGetPos();               //  Get position of avatar to create arrow
        pos = pos + vel;                //  Create arrow slightly in direction of travel
        pos.z += 0.75;                  //  Correct creation point upward to eye point 
        vel = vel * SPEED;              //  Multiply normalized vector by speed 
        llRezObject("bullet", pos, vel, rot, LIFETIME);         
        llTriggerSound("da0c3f70-fc3c-68f4-e8d6-557fb2270fdb", 1.0); //  Make the sound of the arrow being shot
//        llRezObject("bullet", pos, vel, rot, LIFETIME); 
        ammo -= 1;
    }
    if(ammo <= 0 && armed == TRUE)
    {
        llOwnerSay("Reloading DLT-20a");
        llSetTimerEvent(4);
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
        //
        //  Called when the gun is created from inventory.
        // 
        llPreloadSound("da0c3f70-fc3c-68f4-e8d6-557fb2270fdb");        //  Preload shooting sound so you hear it
    }

     run_time_permissions(integer permissions)
    {
        //
        //  This routine is called when the user accepts the permissions request 
        //  (sometimes this is automatic)
        //  so on receiving permissions, start animation and take controls. 
        // 
        if (permissions == PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS)
        {
            if (!have_permissions)
            {
                llWhisper(0, instruction_held_1);
                llWhisper(0, instruction_held_2);
            }
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            llStartAnimation("hold_R_rifle");
            have_permissions = TRUE;
        }
    }

    attach(key attachedAgent)
    {
        llListen(80, "", "", "");
        llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
        if(attachedAgent != NULL_KEY)
        {
            llOwnerSay("To Draw DLT-20a, type /80 draw. To sling it on your back, type /80 sling.");
        }
    }

    control(key name, integer held, integer change) 
    {
        //  This function is called when the mouse button or other controls 
        //  are pressed, and the controls are being captured. 
        //  
        //  Note the logical AND (single &) used - the levels and edges 
        //  variables passed in are bitmasks, and must be checked with 
        //  logical compare. 
        //  
        //  Checking for both edge and level means that the button has just 
        //  been pushed down, which is when we want to fire the arrow!
        // 
        if (change & held & CONTROL_ML_LBUTTON)        {
            //  If left mousebutton is pressed, fire arrow 
            fire();
        }
    }
    
    touch_end(integer num)
    {
        //  If touched, remind user how to enter mouselook and shoot
        if (have_permissions) 
        {
            llWhisper(0, instruction_held_1);
            llWhisper(0, instruction_held_2);
        }
        else 
        {   
            llWhisper(0, instruction_not_held);
        }
    }
    timer()
    {
        ammo = maxammo;
        armed = TRUE;
        llSetTimerEvent(0);
        llOwnerSay("DC-15a Reloaded.");
    }
    listen(integer chan, string name, key id, string msg)
    {
        if(id == llGetOwner())
        {
            if(llToLower(msg) == "draw")
            {
                llSetLinkAlpha(LINK_SET, 1, ALL_SIDES);
                ammo = maxammo;
                armed = TRUE;
                SPEED = 40;
                llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS);   
            }
            else if(llToLower(msg) == "sling")
            {
                llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
                ammo = maxammo;
                SPEED = 40;
                armed = TRUE;
                if (have_permissions)
                {
                    llStopAnimation("hold_R_rifle");
                    llStopAnimation("aim_R_rifle");
                    llReleaseControls();
 //                   llSetRot(<0,0,0,1>);
                    have_permissions = FALSE;
                }
            }
            else if(llToLower(llGetSubString(msg, 0, 4)) == "speed")
            {
                SPEED = (float)llGetSubString(msg, 6, -1);
                llOwnerSay("Speed set to " + llGetSubString(msg, 6, -1));
            }
        }
    }
}
 