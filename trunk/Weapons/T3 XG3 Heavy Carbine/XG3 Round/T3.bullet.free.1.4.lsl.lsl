default
{
    state_entry()
    {
        llSetBuoyancy((float)llGetObjectDesc());
        llSetStatus(STATUS_DIE_AT_EDGE,TRUE);
        llSetStatus(STATUS_ROTATE_X,FALSE);
        llSetStatus(STATUS_ROTATE_Y,FALSE);
        llSetStatus(STATUS_ROTATE_Z,FALSE);
        llCollisionFilter(llGetObjectName(),NULL_KEY,FALSE);
        llSetDamage(100);
        if(llGetInventoryNumber(INVENTORY_SOUND)>0)
            llCollisionSound(llGetInventoryName(INVENTORY_SOUND,0),1);
    }

    on_rez(integer t)
    {
        llSetDamage(t);
    }
    
    collision_start(integer t)
    {
        llDie();
    }
    
    land_collision_start(vector v)
    {
        llDie();
    }
}
