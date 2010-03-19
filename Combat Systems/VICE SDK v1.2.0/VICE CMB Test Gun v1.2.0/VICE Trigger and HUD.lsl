//  This is a free script for the new combat system VICE, which also supports the
//  TCS/CCC module that comes supplied with VICE. Feel free to modify this to suit your personal needs.
string HUDtext="";
vector HUDcolor;

integer reloaded;
integer counter;
key fire_sound="2e1676e4-9106-9094-53bb-47b0d51ca254";
key reload_sound="6463a69c-37dc-b204-1bbc-e74a811c9df2";
list grenade_link_numbers=[3,4,2,6,5,7,10];

// Combat system stats:
integer vice_hp;
integer max_vice_hp=1;
integer vice_hits;
integer vice_kills;
integer vice_deaths;
integer dead;
integer team=0;

// interface Stuff
integer dialog_channel_handle;
integer dialog_channel;
integer set_private_channel_number;
integer set_private_channel_handle;
init()
{
    dead=FALSE;
    reloaded=FALSE;
    hideGrenade();
    llSetText("", ZERO_VECTOR, 0.0);
    llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
    if(llGetAttached()!=ATTACH_RHAND)
    {
        llOwnerSay("This gun should be worn on the right hand! Please try again.");
        llDie();
    }
    llOwnerSay("VICE SMB test gun for infantry.  See http://vicecombat.com for more information.\nCheck out the full-perm '"+llGetScriptName()+"' script to see how you can implement VICE in your own guns!");
    llSleep(0.5);
    llMessageLinked(LINK_SET,TRUE,"seated",llGetOwner());
    if(team>0) llMessageLinked(LINK_SET,team,"vice team","");
    llMessageLinked(LINK_SET,TRUE,"vice ctrl","");
    llListenRemove(dialog_channel_handle);
    dialog_channel=8;
    dialog_channel_handle=llListen(dialog_channel,"",llGetOwner(),"");
    llListenRemove(set_private_channel_handle);
    set_private_channel_handle=0;
    refreshHUD();
}

refreshHUD() 
{
    HUDtext="";
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

showGrenade()
{
    integer counter;
    for(counter=llGetListLength(grenade_link_numbers)-1; counter>=0; counter-=1)
    {
        llSetLinkAlpha(llList2Integer(grenade_link_numbers,counter), 1.0, ALL_SIDES); // hide the grenade prims
    }
}

hideGrenade()
{
    integer counter;
    for(counter=0; counter<llGetListLength(grenade_link_numbers); counter+=1)
    {
        llSetLinkAlpha(llList2Integer(grenade_link_numbers,counter), 0.0, ALL_SIDES); // hide the grenade prims
    }
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
            llStopAnimation("hold_r_rifle");
            llStopAnimation("dead");
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
        if(!dead && (level & CONTROL_ML_LBUTTON) && reloaded)
        {
            // for a semi-automatic gun, send the link message every time the mouse button is clicked
            // here we use a custom rez offset position and rotation
            llMessageLinked(LINK_SET,1,"bomb","");
            llPlaySound(fire_sound,1.0);
            hideGrenade();
            reloaded=FALSE;
        }
    }
    
    link_message(integer src, integer number, string msg, key id)
    {
        if(msg == "bomb" && number<0)
        {
            reloaded=TRUE;
            llPlaySound(reload_sound,1.0);
            showGrenade();
        }
        else if(msg=="vice stats")
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
                llStopAnimation("hold_r_rifle");
                llStartAnimation("dead");
                refreshHUD();
                llTakeControls(-1, TRUE, FALSE);
            }
            else
            {
                dead=FALSE;
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
            llDialog(llGetOwner(), "\nSet Ch: select a private combat channel\nReset Ch: return to the default combat channel\nTeam *: Select a team\n\n/"+(string)dialog_channel+" <death message>: choose a death message (limited to 20 characters)",["Team 2","Team 3","Team 4","Reset Ch","No Team","Team 1","Set Ch"],dialog_channel);
        }
    }
    
    listen(integer channel, string sender_name, key sender_id, string message)
    {
        if(sender_id==llGetOwner())
        {    
            if(channel==dialog_channel)
            {
                list teams=["No Team","Team 1","Team 2", "Team 3", "Team 4"];
                if(llListFindList(teams,[message])!=-1)
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
                else if(message=="bomb") llOwnerSay("No grenades!");
                else if(message=="stab") llOwnerSay("This weapon lacks a melee attack!");
                else if(message!="Reload" && message!="Fire Mode")
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