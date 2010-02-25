default
{
    state_entry()
    {
       
    }

    collision_start(integer chargeval)
    {
        llSetStatus(STATUS_PHYSICS, FALSE);
        llSetStatus(STATUS_PHANTOM , TRUE);
       llSetAlpha(0, ALL_SIDES);    
    }
    land_collision_start(vector pos)
    {
     
     
     llSetStatus(STATUS_PHYSICS, FALSE);
     llSetStatus(STATUS_PHANTOM , TRUE);
     llSetAlpha(0, ALL_SIDES);    
    }
}   