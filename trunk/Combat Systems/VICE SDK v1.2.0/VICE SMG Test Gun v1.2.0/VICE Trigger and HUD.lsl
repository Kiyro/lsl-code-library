//  This is a free script for the new combat system VICE, which also supports the
//  TCS/CCC module that comes supplied with VICE. Feel free to modify this to suit your personal needs.
string HUDtext="";
vector HUDcolor;

key auto_fire_sound="9d5c43c4-5849-4d65-2ae7-5799ffc568c7";  // in auto-fire mode
key single_fire_sound="987a0331-fb2d-7087-bfed-74df8862aab7"; // in single-shot mode
key not_loaded_sound="4724cd06-8705-58a3-ec96-a93503bf3a2e";  // for when you're not firing
key reload_sound="6ebdf6d1-71c2-021b-ba41-8fd4aadb4533"; // for reloading...
key knife_sound="8c642cd3-b74e-0611-099e-40f4bfd681d6"; // when using the knife
// Combat system stats:
float STAB_RECOVERY_TIME=1.5;  // recovery time in seconds after we stab, before we cna stab again or shoot a bullet
float SHOOT_RECOVERY_TIME=0.11; // recovery time in seconds after we fire a bullet (in semi- or full-auto modes), before we can stab or start shooting again.  The system limits 0.1s, so let's go with 0.11 as a safety measure (to prevent lost link messages...)
float recovery_time=SHOOT_RECOVERY_TIME;  //time after we stab/shoot before we can stab/shoot again
integer team;
integer vice_hp;
integer max_vice_hp=1;
integer vice_hits;
integer vice_kills;
integer vice_deaths;
integer dead=FALSE;
integer firing_mode;
integer reload_state; // 0=ammo depleted; 1=nonzero ammo, ready to fire; 2=in the process of reloading
integer auto_firing=FALSE;  // if we are currently firing in full-auto mode
integer last_attack_was_auto=FALSE;  // whether our most recent bullet fire or melee attack was in full auto mode (for trigger timing limits)
// interface Stuff
integer dialog_channel_handle;
integer dialog_channel;
integer set_private_channel_number;
integer set_private_channel_handle;
list teams=["No Team","Team 1","Team 2", "Team 3", "Team 4"];

init()
{
    firing_mode=0; //semi-automatic by default
    reload_state=2;  // weapon reloading
    dead=FALSE;
    llSetText("", ZERO_VECTOR, 0.0);
    llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
    if(llGetAttached()!=ATTACH_RHAND)
    {
        llOwnerSay("This gun should be worn on the right hand! Please try again.");
        llDie();
    }
    llOwnerSay("VICE SMG test gun for infantry.  See http://vicecombat.com for more information.\nCheck out the full-perm '"+llGetScriptName()+"' script to see how you can implement VICE in your own guns!");
    llSleep(0.5);
    llMessageLinked(LINK_SET,TRUE,"seated",llGetOwner());
    llSleep(0.5); 
    if(team>0) llMessageLinked(LINK_SET,team,"vice team","");
    llMessageLinked(LINK_SET,TRUE,"vice ctrl",""); // enable combat
    //llMessageLinked(LINK_SET,0,"vice team","");  // reset to no team
    llListenRemove(dialog_channel_handle);
    dialog_channel=8;
    dialog_channel_handle=llListen(dialog_channel,"",llGetOwner(),"");
    llListenRemove(set_private_channel_handle);
    set_private_channel_handle=0;
    llMessageLinked(LINK_SET,reload_state,"reload","");  // reloading should be automatic, but just in case...
    llPlaySound(reload_sound,1.0); // reloading...
    refreshHUD();
}

refreshHUD()
{
    HUDtext="";
    HUDcolor=<0.0,1.0,0.0>;  // green if healthy
    if(!dead)
    {
        HUDtext+="VICE";
        if(team>0) HUDtext+=" - Team "+(string)team;
        HUDtext+="\nHP: "+(string)vice_hp+" Damage Dealt: "+(string)vice_hits
            +"\nKills: "+(string)vice_kills+" Deaths: "+(string)vice_deaths;
        if(firing_mode==0) HUDtext+="\nSemi-Auto";
        else if(firing_mode==1) HUDtext+="\nFull-Auto";
        if(reload_state==0) HUDtext+=" / Ammo Depleted!";
        else if(reload_state==2) HUDtext+=" / Reloading";
        if(vice_hp<=max_vice_hp/2) HUDcolor=<1.0,0.0,0.0>;  // red if damaged
    }
    else
    {
        HUDcolor=<1.0,0.0,0.0>;  // red if dead
        HUDtext="Dead!";
    }
    llSetText(HUDtext+"\n \n \n \n ", HUDcolor, 1.0);
}

default
{
    state_entry()
    {
        init();
    }
    
    attach(key id)
    {
        if(id==NULL_KEY)
        {
            llStopAnimation("dead");
            llStopAnimation("hold_r_rifle"); 
        }
        else init();
    }
    
    changed(integer change)
    {
        if(change&CHANGED_OWNER)
        {
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
            team=0;
            refreshHUD();
        }
    }
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION) llStartAnimation("hold_r_rifle");
        if(perm & PERMISSION_TAKE_CONTROLS) llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
    }
    
    control(key id, integer level, integer edge)
    {
        if(!dead)
        {
            if(reload_state==1)
            {
                // full-auto mode:
                if(firing_mode==1 && (edge || level^auto_firing) )
                {
                    
                    if(level)
                    {
                        //llOwnerSay("fire "+(string)llGetTime()+" (recovery "+(string)recovery_time+")");  // for debugging the trigger timings
                        if(last_attack_was_auto || llGetTime()>recovery_time)
                        {
                            llMessageLinked(LINK_SET, level, "gun ctrl", "");
                            llLoopSound(auto_fire_sound,1.0);
                            recovery_time=SHOOT_RECOVERY_TIME;
                            last_attack_was_auto=TRUE;
                            auto_firing=level;
                        }
                    }
                    else if(auto_firing)
                    {
                        llResetTime();  // reset the time that we last fired a bullet or stabbed
                        llMessageLinked(LINK_SET, level, "gun ctrl", "");                   
                        llStopSound();
                        auto_firing=FALSE;
                    }
                }
                // single-shot mode:
                else if(firing_mode==0 && level && edge && llGetTime()>recovery_time)
                {
                    // if we wanted a custom rez offset for the bullet, we'd put something like "<-0.9,-0.0,0.3>,<0.0,0.0,0.0,1.0>" in the key field of the link message
                    llMessageLinked(LINK_SET, level, "gun ctrl", "");
                    llTriggerSound(single_fire_sound,1.0);
                    llResetTime(); // reset the time that we last fired a bullet or stabbed
                    last_attack_was_auto=FALSE;
                    recovery_time=SHOOT_RECOVERY_TIME;
                }
            }
            else if(level & edge & CONTROL_ML_LBUTTON) llTriggerSound(not_loaded_sound,1.0);  // we are either out of ammo or in the process reloading now
        }
    }
    
    link_message(integer src, integer number, string msg, key id)
    {
        if(msg=="vice stats")
        {
            vice_kills=(number>>26)&63;
            vice_deaths=(number>>20)&63;
            vice_hits=(number>>8)&4095;
            vice_hp=number&255;
            if(vice_hp>max_vice_hp) max_vice_hp=vice_hp;
            refreshHUD();        
        }
        else if( msg == "reload")
        {
            if(reload_state!=number)
            {
                reload_state=number;
                if(reload_state==0)
                {
                    llPlaySound(not_loaded_sound,1.0);
                    if(auto_firing)
                    {
                        auto_firing=FALSE;
                        llResetTime();
                    }
                }
                refreshHUD();
            }
            //llOwnerSay("reload"+(string)number);
        }
        else if(msg=="crash")  
        {
            dead=number;
            if(dead) // crashing ( number==0 for uncrashing)
            {
                llStopSound();
                llStopAnimation("hold_r_rifle");
                llStartAnimation("dead");
                refreshHUD();
                llTakeControls(-1, TRUE, FALSE);
            }
            else
            {
                llStopAnimation("dead");
                llStartAnimation("hold_r_rifle");
                refreshHUD();
                llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            }
        }
    }
    
    touch_start(integer detected)
    { 
        if(llDetectedKey(0)==llGetOwner())
        {
            llDialog(llGetOwner(), "\nSet/Reset Ch: select a combat channel\nTeam *: Select a team\nFire Mode: Select semi/auto firing mode\nReload: reload the gun\n/"+(string)dialog_channel+" <death message>: choose a death message (limited to 20 characters)",["Team 2","Team 3","Team 4","Reset Ch","No Team","Team 1","Set Ch","Fire Mode","Reload"],dialog_channel);
        }
    }
    
    listen(integer channel, string sender_name, key sender_id, string message)
    {
        if(sender_id==llGetOwner())
        {    
            if(channel==dialog_channel)
            {
                if(message=="stab")
                {
                    if(!dead && llGetTime()>recovery_time && !auto_firing)
                    {
                        //llOwnerSay("stab "+(string)llGetTime()+" (recovery "+(string)recovery_time+")");  // for debugging the trigger timings
                        llMessageLinked(LINK_ALL_CHILDREN,0,"stab","");
                        llResetTime();  // reset the time that we last fired a bullet or stabbed
                        llStartAnimation("punch_r");
                        llPlaySound(knife_sound,1.0);
                        last_attack_was_auto=FALSE;
                        recovery_time=STAB_RECOVERY_TIME+0.03;  // time to recover from a stab + a 30ms tolerance
                    }
                }
                else if(llListFindList(teams,[message])!=-1)
                {
                    team=llListFindList(teams,[message]);
                    llMessageLinked(LINK_SET,team,"vice team","");
                    refreshHUD();
                }
                else if(message=="Reset Ch") llMessageLinked(LINK_SET,0,"channel","");
                else if(message=="Set Ch")
                {
                    llListenRemove(set_private_channel_handle);
                    set_private_channel_number=100+(integer)llFrand(900.0);
                    llOwnerSay("Choose a combat channel by chat: /"+(string)set_private_channel_number+" <password>");
                    set_private_channel_handle=llListen(set_private_channel_number,"",llGetOwner(),"");
                    llSensorRepeat("",llGetKey(),AGENT,1.0,PI,30.0);  // for listen timeout
                }
                else if(message=="Fire Mode")
                {
                    firing_mode=!firing_mode;
                    llMessageLinked(LINK_SET,firing_mode,"bullet type","");
                    llStopSound();
                    auto_firing=FALSE;
                    refreshHUD();
                }
                else if(message=="Reload")
                {
                    if(reload_state!=2)
                    {
                        reload_state=2;
                        if(auto_firing)
                        {
                            llResetTime();
                            auto_firing=FALSE;
                        }
                        llPlaySound(reload_sound,1.0);
                        refreshHUD();
                    }
                    // not inside the if() statement incase the trigger script is confused about its reloading status:        
                    llMessageLinked(LINK_SET,reload_state,"reload","");
                }
                else if(message=="bomb") llOwnerSay("The SMG weapon class is incompatible with grenades!");
                else
                {
                    // limit the death message to 30 characters (the sensor will truncate it anyway...
                    llMessageLinked(LINK_SET,0,"death message",llGetSubString(llStringTrim(message,STRING_TRIM),0,29));                
                }
            }
            else if(channel==set_private_channel_number)  // a secret channel for choosing a game
            // 0 by default, so this if statement shouldn't happen unless the person is trying to pick a password
            {
                message=llStringTrim(message,STRING_TRIM);
                if(message) //  don't pass a null password
                {
                    llListenRemove(set_private_channel_handle);
                    llMessageLinked(LINK_ROOT,1,"channel",message);
                    set_private_channel_number=0;  // reset this so that we know the timer isn't currently going
                    llSensorRemove();
                }
            }
        }
    }
    
    no_sensor()
    {
        llOwnerSay("Timeout; Closing listen for combat channel selection");
        llListenRemove(set_private_channel_handle);
        llSensorRemove();
    }
}