integer have_permissions = FALSE;

integer CHANNEL = 10;
powerup()
{      
        llStartAnimation("DBZpowerup2");
        llSleep(1);
        llMessageLinked(LINK_SET,CHANNEL,"rocks",NULL_KEY);
            llRezObject("dbz aura", llGetPos() + <0,0,0>, ZERO_VECTOR, ZERO_ROTATION,0); 
        llTriggerSound("aura ( converted )", 1.0);
                llMessageLinked(LINK_SET,CHANNEL,"smoke rings",NULL_KEY);   
        llSleep(5.5);       
        llRezObject("energyball", llGetPos() + <0,0,0>, ZERO_VECTOR, ZERO_ROTATION,0);
        llTriggerSound("Goku ha ( converted )", 1.0);
        llTriggerSound("chargepush ( converted )", 1.0);
        llTriggerSound("wallhit ( converted )", 1.0);
        llRezObject("crator", llGetPos() + <0,0,-0.65>, ZERO_VECTOR, ZERO_ROTATION,0);   
}

//Commands stored in variable

default
{
      on_rez(integer param)
    {
                llInstantMessage(llGetOwner(),"This powerup is a freebie. Feel free to edit, tamper or modify this. Please do not resell, and please do not take credit for components borrowed from this");
        llInstantMessage(llGetOwner(),"To trigger the powerup, type /10 powerup2 in public chat");
        llPreloadSound("Goku ha ( converted )");
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
        if (message == "powerup2")
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

