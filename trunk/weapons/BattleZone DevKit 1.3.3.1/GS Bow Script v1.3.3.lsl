// Goodman Studios - Bow Script
//
// This is the script you should put into your bow that will be firing your arrows.
// You can optionally make the projectile use different damage types, and in this example, BattleZone's own 'arrow' attack type is used by default. You can find out more about
// what other damage types are available in BattleZone at the development wiki website:
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

// Drawing Animation
string  drawanim    = "";
float   drawdelay   = 1.0;
// Sheathing Animation
string  sheathanim  = "";
float   sheathdelay = 1.0;
// Ready Animation, drawn but not aiming
string  readyanim   = "";
// Aiming Animation
string  aimanim     = "";
// Firing animation
string  fireanim    = "";

// Shooting Sound
string  snd_shoot   = "";

// This sets how fast the projectiles will travel once fired. Generally this should not ever
// be above 60 for bows, or above 20 for thrown weapons.
float   velocity    = 60.0;

// =================================================================================================================================

vector      fwd;
vector      pos;
rotation    rot;

key         owner;
string      name;
integer     ready       = FALSE;
integer     aiming      = FALSE;
float       last        = 0.0;

integer     hChannel    = -458238;          // BattleZone auto-sheating communication channel.
integer     hHandle     = 0;                // Listening handle for above.
integer     pHandle     = 0;                // Listener for public commands.
integer     gHandle     = 0;                // Listening handle for commands.


fire()
{
    //  
    //  Actually fires the ball 
    //  
    last    = llGetTime() + 2.0;
    
    rot     = llGetRot();
    fwd     = llRot2Fwd(rot);
    pos     = llGetPos();
    pos     = pos + fwd;
    pos.z  += 0.75;                     //  Correct to eye point
    fwd     = fwd * velocity;
    
    if (fireanim != "")     llStartAnimation(fireanim);
    else                    llStartAnimation("shoot_L_bow");
    if (snd_shoot != "")    llPlaySound(snd_shoot, 0.8);
    else                    llPlaySound("0d583b21-b130-8514-bdbe-59c61fbb4af4", 0.8);
    llRezObject("arrow", pos, fwd, rot, 1);
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
    owner = llGetOwner();
    name  = llKey2Name(owner);
    
    if (publicchan && pHandle)  llListenRemove(pHandle);
    if (altchannel && gHandle)  llListenRemove(gHandle);
    if (hHandle) llListenRemove(hHandle);
    if (llGetAttached() > 0) {
        if (publicchan)     pHandle = llListen(0, "", owner, "");
        if (altchannel)     gHandle = llListen(altchannel, "", owner, "");
        llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
        if (llGetPermissions() & PERMISSION_TAKE_CONTROLS)     llRequestPermissions(owner, FALSE);
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
        if (agent == NULL_KEY && ready) llWhisper(hChannel, "sheathed bow");
    }
    
    listen(integer chan, string name, key id, string msg)
    {
        if (chan == altchannel || chan == 0) {
            msg = llToLower(msg);
            if (msg == "draw bow" && !ready) {
                llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
            } else
            if ((msg == "draw bow" || msg == "sheath bow") && ready) {
                if (readyanim != "")    llStopAnimation(readyanim);
                if (aimanim != "")      llStopAnimation(aimanim);
                llStopAnimation("hold_L_bow");
                if (sheathanim != "")   {
                    llStartAnimation(sheathanim);       // Start the sheathing animation.
                    llSleep(sheathdelay);               // Delay until the animation is done.
                }
                llReleaseControls();
                llRequestPermissions(llGetOwner(),  FALSE);
            }
        } else
        if (chan == hChannel && llGetOwnerKey(id) == owner) {
            // Auto-Sheathing when the BattleZone Combat System reports the wearer has fallen, and unable
            // to continue fighting.
            if ((msg == "sheathed" || msg == "fallen") && ready) {
                if (readyanim != "")    llStopAnimation(readyanim);
                if (aimanim != "")      llStopAnimation(aimanim);
                llStopAnimation("hold_L_bow");
                llReleaseControls();
                llRequestPermissions(owner,  FALSE);
            }
        }
    }
    
    run_time_permissions(integer permissions)
    {
        if (permissions > 0)
        {
            if (hHandle) llListenRemove(hHandle);
            hHandle = llListen(hChannel, "", "", "");
            StopAllAnims();
            if (drawanim != "")     {
                llStartAnimation(drawanim);         // Start the drawing animation.
                llSleep(drawdelay);                 // Delay between drawing and starting the ready animation.
            }
            if (readyanim != "")    llStartAnimation(readyanim);
            else                    llStartAnimation("hold_L_bow");
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
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
            llSay(hChannel, "drawn bow");
            llSetTimerEvent(1.0);
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
            llSay(hChannel, "sheathed bow");
            llSetTimerEvent(0.0);
        }
    }
    
    control(key id, integer held, integer change)
    {
        if (llGetTime() < last) return;
        
        integer pressed = held & change;
        
        if (pressed & CONTROL_ML_LBUTTON) fire();
    }
    
    timer()
    {
        if (!ready) {
            llSetTimerEvent(0.0);
            return;
        }
        if (aiming && !(llGetAgentInfo(llGetOwner()) & AGENT_MOUSELOOK)) {
            if (aimanim != "")      llStopAnimation(aimanim);
            if (readyanim != "")    llStartAnimation(readyanim);
            aiming = FALSE;
        } else
        if (!aiming && (llGetAgentInfo(llGetOwner()) & AGENT_MOUSELOOK)) {
            if (readyanim != "")    llStopAnimation(readyanim);
            if (aimanim != "")      llStartAnimation(aimanim);
            aiming = TRUE;
        }
    }
}
