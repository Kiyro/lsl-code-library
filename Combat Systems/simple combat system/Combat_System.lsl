// Simple Combat System
// Project started by: Haiku Mocha
// --------------------------------------------
// This is my attempt at making a 'simple'
// combat system - allows for close-range
// and ranged combat; uses collision detection
// with griefing protection for damage counting

// This is only a (very basic) prototype of
// the finished product.  Don't expect much
// to be working :P

integer energy;
integer stamina; // not implemented

default {
    state_entry(){
        energy = 100;
        llSetText((string)energy, <0,1,0>, 1);
    }
    
    collision_start(integer num){
        if(energy > 0){
            vector detVel = llDetectedVel(0);
            integer detected = llDetectedType(0);
            if((llDetectedName(0) == "enemy" || detVel == <0,0,0>) && (detected & (AGENT || SCRIPTED))){
                energy = energy - 2;
                llSetText((string)energy, <0,1,0>, 1);
            } else {
                energy = energy - 4;
                llSetText((string)energy, <0,1,0>, 1);
            }
            // Prevents collision events from
            // piling up in case of griefing
            llCollisionFilter("", NULL_KEY, FALSE);
            llSleep(1.0);
            llCollisionFilter("", NULL_KEY, TRUE);
        } else {
            llSetText((string)energy, <1,0,0>, 1);
            llCollisionFilter("", NULL_KEY, FALSE);
            llSleep(4.0);
            llResetScript();
        }
    }
}