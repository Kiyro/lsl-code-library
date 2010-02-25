default
{
    state_entry()
    {
        llVolumeDetect(TRUE);
        llSetBuoyancy(1.0);
        llSetStatus(STATUS_DIE_AT_EDGE,TRUE);
    }

    collision_start(integer chargeval)
    {
        llSetStatus(STATUS_PHYSICS, FALSE);
//        llSetStatus(STATUS_PHANTOM , TRUE);
        llSetAlpha(0, ALL_SIDES);
        llRezObject("seeker",llDetectedPos(0),ZERO_VECTOR,ZERO_ROTATION,1);
           
    }
    land_collision_start(vector pos)
    {
     
     
     llSetStatus(STATUS_PHYSICS, FALSE);
     llSetStatus(STATUS_PHANTOM , TRUE);
     llSetAlpha(0, ALL_SIDES);    
    }
}
