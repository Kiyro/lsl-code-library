default
{
    on_rez(integer param)
    {
        llVolumeDetect(TRUE);
        llSetAlpha(0.0,ALL_SIDES);
        llSetTimerEvent(1);
        llCollisionFilter(llKey2Name(llGetOwner()),llGetOwner(),FALSE);
    }
    collision_start(integer num)
    {
        if(llDetectedType(0) & ACTIVE)
        {
            vector vel = llDetectedVel(0);
            vel = -vel;
            llPushObject(llDetectedKey(0),vel * 5, ZERO_VECTOR, FALSE);
        }
    }
    timer()
    {
        llDie();
    }
}