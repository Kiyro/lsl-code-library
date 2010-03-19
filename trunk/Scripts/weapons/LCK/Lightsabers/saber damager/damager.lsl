integer damage;

default
{
    on_rez(integer param)
    {
        damage = param;
        llSetAlpha(0.0,ALL_SIDES);
        llCollisionFilter(llKey2Name(llGetOwner()),llGetOwner(),FALSE);
        llSetDamage(damage);
        llSetTimerEvent(1);
    }
    timer()
    {
        llDie();
    }
    collision(integer num)
    {
        llDie();
    }
}
