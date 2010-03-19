hit()
{
    vector pos = llGetPos(); 
    llMoveToTarget(pos, 0.3);          //  Move to where we hit smoothly
llTriggerSound("wallhit ( converted )",1.0);
          llRezObject("energyball", llGetPos() + <0,0,0>, ZERO_VECTOR, ZERO_ROTATION,0);
        llMakeExplosion(20, 1.0, 5, 3.0, 1.0, "smoke", ZERO_VECTOR);
            llMakeExplosion(20, 1.0, 5, 3.0, 1.0, "fire", ZERO_VECTOR);
llDie();
}
default
{
    
        state_entry()
    {
        llSetStatus( STATUS_DIE_AT_EDGE, TRUE);
    }
    
    on_rez(integer delay)
    {
        llSetBuoyancy(1.0);                 //  Make bullet float and not fall 
        llCollisionSound("", 1.0);          //  Disable collision sounds
    }

 collision_start(integer total_number)
    {
        hit();
    }
    
    land_collision_start(vector pos)
    {
        hit();
    }
}
