//  This is a free script for the new combat system VICE, which also supports the
//  TCS/CCC module that comes supplied with VICE. Feel free to modify this to suit your personal needs.


// This script is for a special MLE-only weapon.  Since the melee attack is controled by a bullet rezzer script, I'm using the SSG bullet rezzer script for the knife attack.  The "SSG Bullet" object is only so that the bullet rzzer script doesn't complain.

string HUDtext="";
vector HUDcolor;

float STAB_RECOVERY_TIME=1.5;  // recovery time in seconds after we stab, before we cna stab again or shoot a bullet
key knife_sound="8c642cd3-b74e-0611-099e-40f4bfd681d6"; // when using the knife

// Combat system stats:
integer vice_hp;
integer max_vice_hp;
integer vice_hits;
integer vice_kills;
integer vice_deaths;
integer dead;
integer team=0;
integer grenade_ready;
// interface Stuff
integer dialog_channel_handle;
integer dialog_channel;
integer set_private_channel_number;
integer set_private_channel_handle;
list teams=["No Team","Team 1","Team 2", "Team 3", "Team 4"];

init()
{
    dead=FALSE;
    max_vice_hp=1;
    llSetText("", ZERO_VECTOR, 0.0);
    llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
    if(llGetAttached()!=ATTACH_RHAND)
    {
        llOwnerSay("This knife should be worn on the right hand! Please try again.");
        llDie();
    }
    llOwnerSay("VICE MLE test gun for infantry.  See http://vicecombat.com for more information.");
    llSleep(0.5);
    llMessageLinked(LINK_SET,TRUE,"seated",llGetOwner());
    llSleep(0.5);
    if(team>0) llMessageLinked(LINK_SET,team,"vice team","");
    llMessageLinked(LINK_SET,TRUE,"vice ctrl","");
    //llMessageLinked(LINK_SET,0,"vice team","");  // reset to no team
    llListenRemove(dialog_channel_handle);
    dialog_channel=8;
    dialog_channel_handle=llListen(dialog_channel,"",llGetOwner(),"");
    llListenRemove(set_private_channel_handle);
    set_private_channel_handle=0;
    llSetTimerEvent(0.5);
    refreshHUD();
    llMinEventDelay(0.2); 
}

refreshHUD() 
{
    HUDcolor=<0.0,1.0,0.0>;  // green if healthy
    if(!dead)
    {
        HUDtext="VICE";
        if(team>0) HUDtext+=" - Team "+(string)team;
        HUDtext+="\nHP: "+(string)vice_hp+" Damage Dealt: "+(string)vice_hits
            +"\nKills: "+(string)vice_kills+" Deaths: "+(string)vice_deaths;
        if(vice_hp<=max_vice_hp/2) HUDcolor=<1.0,0.0,0.0>;  // red if damaged
    }
    else
    {
        HUDcolor=<1.0,0.0,0.0>;  // red if dead
        HUDtext="Dead!";
    }
    llSetText(HUDtext+"\n \n \n \n \n ", HUDcolor, 1.0);
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
            llMessageLinked(LINK_SET,FALSE,"vice ctrl","");
            llStopAnimation("dead");            
        }
        else init();
    }
    
    changed(integer change)
    {
        if(change&CHANGED_OWNER)
        {
            team=0;
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
            refreshHUD();
        }
    }
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION) llStopAnimation("dead");
        if(perm & PERMISSION_TAKE_CONTROLS) llTakeControls(CONTROL_ML_LBUTTON|CONTROL_LBUTTON, TRUE, FALSE);
    }
    
    control(key id, integer level, integer edge)
    {
        if(!dead && llGetTime()>STAB_RECOVERY_TIME && level)
        {
            llMessageLinked(LINK_SET,0,"stab","");
            llResetTime();  // reset the time that we last fired a bullet or stabbed
            llStartAnimation("cheeseslash");
            llPlaySound(knife_sound,1.0);
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
        else if(msg=="crash")  
        {
            if(number) // crashing ( number==0 for uncrashing)
            {
                dead=TRUE;
                llStopSound();
                llStartAnimation("dead");
                refreshHUD();
                llTakeControls(-1, TRUE, FALSE);
            }
            else
            {
                dead=FALSE;
                llStopAnimation("dead");
                refreshHUD();
                llTakeControls(CONTROL_ML_LBUTTON|CONTROL_LBUTTON, TRUE, FALSE);
            }
        }
    }
    
    touch_start(integer detected)
    {
        if(llDetectedKey(0)==llGetOwner())
        {
            llDialog(llGetOwner(), "\nSet Ch: select a private combat channel\nReset Ch: return to the default combat channel\nTeam *: Select a team\n/"+(string)dialog_channel+" <death message>: choose a death message (limited to 20 characters)",["Team 2","Team 3","Team 4","Reset Ch","No Team","Team 1","Set Ch"],dialog_channel);
        }
    }
    
    listen(integer channel, string sender_name, key sender_id, string message)
    {
        if(sender_id==llGetOwner())
        {    
            if(channel==dialog_channel)
            {
                if(message=="Reset Ch") llMessageLinked(LINK_SET,0,"channel","");
                else if(message=="Set Ch")
                {
                    llListenRemove(set_private_channel_handle);
                    set_private_channel_number=100+(integer)llFrand(900.0);
                    llOwnerSay("Choose a combat channel by chat: /"+(string)set_private_channel_number+" <password>");
                    set_private_channel_handle=llListen(set_private_channel_number,"",llGetOwner(),"");
                    llSensorRepeat("",llGetKey(),AGENT,1.0,PI,30.0);  // for listen timeout
                }
                else if(llListFindList(teams,[message])!=-1)
                {
                    team=llListFindList(teams,[message]);
                    llMessageLinked(LINK_SET,team,"vice team","");
                    refreshHUD();
                }
                // filter out these two messages as they are used by other test guns, but treat everything else as a death message
                else if(message!="Reload" && message!="Fire Mode" && message!="stab")  
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