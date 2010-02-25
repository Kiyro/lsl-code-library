// Goodman Studios - Sword Script
//
// This is the script you should put into a sword, or melee weapon.
// You can optionally make the melee use different damage types. In this example, straight SafeZone compliant attack types are used.
// You can find out more about what other damage types are available in BattleZone at the development wiki website:
//
// http://www.mygorean.info/wiki/index.php?page=BattleZone
// 
// And also ask questions and get help direction from the forums at:
//
// http://battlezone.mygorean.info/forum/index.php
//
// This script is licensed under a Creative Commons Attribution-Share Alike 3.0 United States License, by Mykael Goodman.
// http://creativecommons.org/licenses/by-sa/3.0/us/
// It itself may not be sold to others as modifiable or non-modifyable except within the confines
// of a functioning weapon it is used within, in which case, it can be set to be non-modifyable for
// security measures to prevent alteration of the weapon's function (and should).

// ==== Settings  ==================================================================================================================

// What channel do you want the commands to listen on:
integer publicchan  = TRUE;     // Set to TRUE to have channel 0 listener, FALSE to disable it.
integer altchannel  = 1;        // Set to FALSE to disable the alternate channel.

// Weapon stance (should be looped in the animation itself)
string  stance      = "";
// Drawing Animation
string  drawanim    = "";
float   drawdelay   = 1.0;
// Sheathing Animation
string  sheathanim  = "";
float   sheathdelay = 1.0;

// =================================================================================================================================

string  strike  = "";
key     owner;
string  name;
integer ready   = FALSE;
float   last    = 0.0;

integer hChannel    = -458238;          // BattleZone auto-sheating communication channel.
integer hHandle     = 0;                // Listening handle for above.
integer pHandle     = 0;                // Listener for public commands.
integer gHandle     = 0;                // Listening handle for commands.


hit(string type, string anim, string sound)
{
    float   range;
    
    if (anim != "")     llStartAnimation(anim);
    if (sound != "")    llPlaySound(sound, 1);
    else                llPlaySound("e3a3e3ae-150f-9720-7c7b-8457ad2d743f", 1);
    strike = type;
    
    // Timing is important. Based on kick, punch, and sword attack-types, these
    // below set the time, and range, between attacks.
    if (strike == "kick" || strike == "punch")  {
        range = 2.0;
        last  = llGetTime() + 0.5;
    } else {
        range = 2.5;
        last  = llGetTime() + 0.65;
    }
    llSensor("", "", AGENT, range, PI/4);
}

StopAllAnims() {
    string  null    = (string)NULL_KEY;
    list    a       = llGetAnimationList(llGetOwner());
    integer y       = llGetListLength(a);
    integer i;
    
    for (i; i < y; i++) { 
        if (llList2String(a, i) != null) {
           if (llList2String(a, i) != "2408fe9e-df1d-1d7d-f4ff-1384fa7b350f") llStopAnimation(llList2String(a, i));
        }
    }
}

init()
{
    ready = FALSE;
    last  = 0.0;
    owner = llGetOwner();
    name  = llKey2Name(owner);
    
    if (publicchan && pHandle)  llListenRemove(pHandle);
    if (altchannel && gHandle)  llListenRemove(gHandle);
    if (hHandle) llListenRemove(hHandle);
    if (llGetAttached() > 0) {
        if (publicchan)         pHandle = llListen(0, "", owner, "");
        if (altchannel)         gHandle = llListen(altchannel, "", owner, "");
        llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
        if (llGetPermissions() & PERMISSION_TAKE_CONTROLS)     llRequestPermissions(owner, FALSE);
        
        // Used in Weapons Systems protocol to let other weapons know this
        // weapon has been drawn and ready for use. Also used by the sheath
        // itself so it can only auto-hide when successfully sheathed.
        //
        // You should change sword to another name, if you modify this to be
        // any other kind of weapon. Suggested names are listed in the
        // documentation under Weapons System Protocol.
        llWhisper(hChannel, "sheathed sword");
    } else {
        llSetLinkAlpha(LINK_SET, 1, ALL_SIDES);
    }
}

default
{
    state_entry()
    {
        init();
    }
    
    on_rez(integer rez)
    {
        init();
    }
    
    attach(key agent)
    {
        // In case the weapon is ready and armed, but detached without sheathing, send this to let it be known.
        if (agent == NULL_KEY && ready) llWhisper(hChannel, "sheathed sword");
    }
    
    listen(integer chan, string name, key id, string msg)
    {
        if (chan == altchannel || chan == 0) {
            msg = llToLower(msg);
            
            if (msg == "draw sword" && !ready) {
                llRequestPermissions(owner,  PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS); 
            } else
            if ((msg == "draw sword" || msg == "sheath sword") && ready) {
                if (stance != "") llStopAnimation(stance);
                if (sheathanim != "") {
                    llStartAnimation(sheathanim);
                    llSleep(sheathdelay);
                }
                llReleaseControls();
                llRequestPermissions(owner,  FALSE); 
            }
        } else
        if (chan == hChannel && llGetOwnerKey(id) == owner) {
            // Auto-Sheathing when the BattleZone Combat System reports the wearer has fallen, and unable
            // to continue fighting.
            if ((msg == "fallen" || msg == "sheathed") && ready) {
                if (stance != "") llStopAnimation(stance);
                llReleaseControls();
                llRequestPermissions(owner,  FALSE); 
            }
        }
    }
    
    run_time_permissions(integer permission)
    {
        if (permission > 0)
        {
            if (hHandle) llListenRemove(hHandle);
            hHandle = llListen(hChannel, "", "", "");
            StopAllAnims();
            if (drawanim != "") {
                llStartAnimation(drawanim);
                llSleep(drawdelay);
            }
            if (stance != "") llStartAnimation(stance);
            llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_FWD | 
                CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT |
                CONTROL_RIGHT | CONTROL_ROT_RIGHT, TRUE, TRUE);
            llSetLinkAlpha(LINK_SET, 1, ALL_SIDES);
            ready = TRUE;
            last  = 0.0;
            // Used in Weapons Systems protocol to let other weapons know this
            // weapon has been drawn and ready for use. Also used by the sheath
            // itself so it can only auto-hide when successfully sheathed.
            //
            // You should change sword to another name, if you modify this to be
            // any other kind of weapon. Suggested names are listed in the
            // documentation under Weapons System Protocol.
            llWhisper(hChannel, "drawn sword");
        } else {
            if (hHandle) {
                llListenRemove(hHandle);
                hHandle = 0;
            }
            llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
            ready = FALSE;
            last  = 0.0;
            // Used in Weapons Systems protocol to let other weapons know this
            // one has been sheathed. Also used by the sheath itself so it can
            // only auto-show when successfully sheathed.
            //
            // You should change sword to another name, if you modify this to be
            // any other kind of weapon. Suggested names are listed in the
            // documentation under Weapons System Protocol.
            llWhisper(hChannel, "sheathed sword");
        }
    }
        
    control(key id, integer held, integer change) {
        if (llGetTime() < last) return;
        
        integer pressed = held & change;
        integer down    = held & ~change;
        
        // Check each key, checking if a movement key is pressed and held while click is newly pressed.
        // Each of these conditions execute the function called hit(), which takes the following arguments:
        //
        // hit("attack-type", "animation played", "sound played");
        
        if ((pressed & (CONTROL_ML_LBUTTON | CONTROL_LBUTTON)) && (down & CONTROL_FWD)) 
            hit("sword", "sword_strike_R", "");
        else if ((pressed & (CONTROL_ML_LBUTTON | CONTROL_LBUTTON)) && (down & (CONTROL_RIGHT | CONTROL_ROT_RIGHT)))
            hit("kick", "kick_roundhouse_R", "");
        else if ((pressed & (CONTROL_ML_LBUTTON | CONTROL_LBUTTON)) && (down & (CONTROL_LEFT | CONTROL_ROT_LEFT)))
            hit("punch", "punch_L", "");
        else if ((pressed & (CONTROL_ML_LBUTTON | CONTROL_LBUTTON)) && (down & CONTROL_BACK)) 
            hit("punch", "punch_onetwo", "");
        else if (pressed & (CONTROL_ML_LBUTTON | CONTROL_LBUTTON))
            hit("sword", "sword_strike_R", "");
    }
    
    sensor(integer tnum)
    {
        llWhisper(20, strike + "," + name + "," + llDetectedName(0));
        llSleep(0.2);
        
        // Below are the sounds for when you successfully hit:
        if (strike == "sword")      llPlaySound("9850f8df-c86a-80d9-eca7-d6f12aae6f9e", 1);
        else if (strike == "punch") llPlaySound("a2dc2992-52a4-74d2-c190-e10f9c179761", 1);
        else if (strike == "kick")  llPlaySound("475a3e83-6801-49c6-e7ad-d6386b2ecc29",  1);
    }
}
