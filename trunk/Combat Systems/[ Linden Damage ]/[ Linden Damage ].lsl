default
{
    on_rez(integer Start)
    {
        if(Start)
        {
            llSetDamage(Start);
            llSetTimerEvent(1.0);
        }
        else
        {
            llSetPrimitiveParams([PRIM_TEMP_ON_REZ, 0, PRIM_PHYSICS, 0, PRIM_PHANTOM, 1]);
        }
    }
    collision_start(integer Num)
    {
        llDie();
    }
    timer()
    {
        llDie();
    }
}