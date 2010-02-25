// Goodman Studios - Arrow Script
//
// This is the script you should put into your arrow that will be fired from the bow itself.
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

//string  ATTACK  = "arrow";          // What type of damage attack to use. Usual options for projectils are: thrown, dagger, arrow, or sword
//                                    // (for Non-BattleZone, most just use Sword)
string  snd_hit = "d4eb4f5d-e93c-3800-579f-2beef5a6b476";       // The Sound to play when the arrow hits.
float   TIMEOUT = 3.0;                                          // The timeout for which to wait before auto-deleting itself when hit.

// =================================================================================================================================

string  OWNER;


default
{
    state_entry()
    {
        // This buyoancy value sets the arrow's general weight to allow for physical weight. The lower this number is from 1.0, the faster it will sink.
        // Please make sure you test your projectiles carefully when changing this value.
        llSetBuoyancy(0.70);
        llCollisionSound(snd_hit, 1);
        llCollisionSprite("");
        llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
    }
    
    on_rez(integer rezzed)
    {
        if (rezzed) {
            OWNER = llKey2Name(llGetOwner());
            llSetTimerEvent(20);
        } else {
            llSetPrimitiveParams([PRIM_PHYSICS, FALSE, PRIM_PHANTOM, TRUE]);
        }
    }
    
    collision_start(integer detected)
    {
        llSetPrimitiveParams([PRIM_PHYSICS, FALSE, PRIM_PHANTOM, TRUE]);
        
        if (llDetectedType(0) & AGENT) {
            vector  opos    = llDetectedPos(0);
            vector  apos    = llGetPos();
            
            llWhisper(20, "arrow," + OWNER + "," + llDetectedName(0));
            
            vector  diff    = opos - apos;
            diff            = diff / 2;
            vector  newpos  = <apos.x + diff.x, apos.y + diff.y, apos.z>;
            llSetPos(newpos);
        } else              llWhisper(20, "arrow," + OWNER + "," + llDetectedName(0));
        
        llSleep(TIMEOUT);
        llDie();
    }
    
    land_collision_start(vector pos)
    {
        llSetPrimitiveParams([PRIM_PHYSICS, FALSE, PRIM_PHANTOM, TRUE]);
        llSleep(TIMEOUT);
        llDie();
    }
    
    timer()
    {
        llDie();
    }
}
