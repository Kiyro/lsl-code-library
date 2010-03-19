// CATEGORY:Weapons
// CREATOR:Ferd Frederiex
// DESCRIPTION:Push avatar when collided
// ARCHIVED BY:Ferd Frederix

default
{
    on_rez(integer param)
    {
        
    }
    collision_start(integer num)
    {
        vector vel = llGetVel() * 99999;
        llPushObject(llDetectedKey(0), vel, ZERO_VECTOR, FALSE);
    }
    collision_end(integer num_detected)
    {
        vector vel = llGetVel() * 99999;
        llPushObject(llDetectedKey(0), vel, ZERO_VECTOR, FALSE);
    }
    land_collision_start(vector pos)
    {
        vector vel = llGetVel() * 99999;
        llPushObject(llDetectedKey(0), vel, ZERO_VECTOR, FALSE);
    }
    timer()
    {
        llDie();
    }
}
// END //
