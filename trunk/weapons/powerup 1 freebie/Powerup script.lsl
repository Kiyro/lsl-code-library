integer have_permissions = FALSE;

integer CHANNEL = 10;
powerup()
{      
        llStartAnimation("DBZpowerup");
        llSleep(2);
        llTriggerSound("jump ( converted )", 1.0); 
        llSleep(4.5);       
        llRezObject("energyball", llGetPos() + <0,0,1.5>, ZERO_VECTOR, ZERO_ROTATION,0);
        llTriggerSound("Goku ha ( converted )", 1.0);
        llTriggerSound("chargepush ( converted )", 1.0);
        llTriggerSound("wallhit ( converted )", 1.0);
        llRezObject("crator", llGetPos() + <0,0,-0.75>, ZERO_VECTOR, ZERO_ROTATION,0);
        llMessageLinked(LINK_SET,CHANNEL,"smoke rings",NULL_KEY);    
}

//Commands stored in variable

default
{
      on_rez(integer param)
    {
        llInstantMessage(llGetOwner(),"This powerup is a freebie. Feel free to edit, tamper or modify this. Please do not resell, and please do not take credit for components borrowed from this");
        llInstantMessage(llGetOwner(),"To trigger the powerup, type /10 powerup in public chat"); 
        llPreloadSound("Goku ha ( converted )");
        llPreloadSound("jump ( converted )");
        llPreloadSound("wallhit ( converted )");
        llPreloadSound("chargepush ( converted )");
                        llResetScript();
    }
    state_entry()
    {
        llListen(CHANNEL, "",llGetOwner(), "" );
        llRequestPermissions(llGetOwner(),  
        PERMISSION_TRIGGER_ANIMATION);   
    }

  listen(integer channel, string name, key id, string message)
    {
        if (message == "powerup")
        {
        powerup();
        }
    }
          
          run_time_permissions(integer permissions)
    {
        if (permissions == PERMISSION_TRIGGER_ANIMATION)
        {
            if (!have_permissions)
            have_permissions = TRUE;
        }
    }        
        attach(key attachedAgent)
    {
        if (attachedAgent != NULL_KEY)
        {
            llRequestPermissions(llGetOwner(),  
            PERMISSION_TRIGGER_ANIMATION);   
        }
        else
        {
            if (have_permissions)
            {
                have_permissions = FALSE;
            }
        }
    }
}

