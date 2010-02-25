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
integer publicchan  = TRUE;
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

key     owner;
string  name;
integer ready   = FALSE;
float   lasthit = 0.0;
vector  lastpos;

integer hChannel    = -458238;          // BattleZone auto-sheating communication channel.
integer hHandle     = 0;                // Listening handle for above.
integer pHandle     = 0;                // Listener for public commands.
integer gHandle     = 0;                // Listening handle for commands.


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
    ready   = FALSE;
    lasthit =  0.0;
    owner   = llGetOwner();
    name    = llKey2Name(owner);
    
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
        llWhisper(hChannel, "sheathed spear");
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
        if (agent == NULL_KEY && ready) llWhisper(hChannel, "sheathed spear");
    }
    
    listen(integer chan, string name, key id, string msg)
    {
        if (chan == altchannel || chan == 0) {
            msg = llToLower(msg);
            
            if (msg == "draw spear" && !ready) {
                llRequestPermissions(owner,  PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS); 
            } else
            if (msg == "sheath spear" && ready) {
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
            llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON, TRUE, TRUE);
            llSetLinkAlpha(LINK_SET, 1, ALL_SIDES);
            ready   = TRUE;
            lasthit = 0.0;
            // Used in Weapons Systems protocol to let other weapons know this
            // weapon has been drawn and ready for use. Also used by the sheath
            // itself so it can only auto-hide when successfully sheathed.
            //
            // You should change sword to another name, if you modify this to be
            // any other kind of weapon. Suggested names are listed in the
            // documentation under Weapons System Protocol.
            llWhisper(hChannel, "drawn spear");
        } else {
            if (hHandle) {
                llListenRemove(hHandle);
                hHandle = 0;
            }
            llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
            ready   = FALSE;
            lasthit = 0.0;
            // Used in Weapons Systems protocol to let other weapons know this
            // one has been sheathed. Also used by the sheath itself so it can
            // only auto-show when successfully sheathed.
            //
            // You should change sword to another name, if you modify this to be
            // any other kind of weapon. Suggested names are listed in the
            // documentation under Weapons System Protocol.
            llWhisper(hChannel, "sheathed spear");
        }
    }
        
    control(key id, integer held, integer change) {
        if (llGetTime() < lasthit) return;
        
        integer pressed = held & change;
        
        if (pressed & (CONTROL_ML_LBUTTON | CONTROL_LBUTTON)) {
            lasthit = llGetTime() + 1.0;
            lastpos = llGetPos();
            llStartAnimation("sword_strike_R");
            llPlaySound("e3a3e3ae-150f-9720-7c7b-8457ad2d743f", 1);
            llSensor("", "", AGENT, 3.5, PI/4);
        }
    }
    
    sensor(integer tnum)
    {
        string  attack = "great";
        
        if (llVecDist(lastpos, llDetectedPos(tnum-1)) > 2.5) attack = "kick";     // Represents a shaft hit from the spear, rather than spear blade.
        llWhisper(20, attack + "," + name + "," + llDetectedName(tnum-1));
        llSleep(0.2);
        
        // Below are the sounds for when you successfully hit:
        llPlaySound("9850f8df-c86a-80d9-eca7-d6f12aae6f9e", 1);
    }
}
