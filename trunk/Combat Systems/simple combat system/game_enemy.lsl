// Put this object in a basic prim, say a cube,
// name that cube 'enemy' (without quotes), and
// make sure you have a cube attached to you
// with the simple combat system script on.

// Have fun! ;)

default {
    state_entry(){
        llCollisionSound("", 0.0);
        llSetStatus(STATUS_PHYSICS, TRUE);
        llSensorRepeat("", llGetOwner(), AGENT, 20.0, PI, 0.2);
    }
    
    sensor(integer x){
        vector pos = llDetectedPos(0);
        llMoveToTarget(pos, 2.5);
    }
    
    collision_start(integer x){
        llSetColor(<1,0,0>, ALL_SIDES);
    }
    
    collision_end(integer x){
        llSetColor(<0,1,0>, ALL_SIDES);
    }
}