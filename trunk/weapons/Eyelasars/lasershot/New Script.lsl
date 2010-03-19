
default
{
    state_entry()
    {
        llSetBuoyancy(1.0);
    }
    on_rez(integer param)
    {
        if (!param)return;
        llSetTimerEvent(20.0);
    }
    timer()
    {
        llDie();
    }
    collision(integer numdet)
    {
        llRezObject("RedBlast",llGetPos() + <2.5,0,0>*llGetRot(),<0,0,0>,<0,0,0,0>,1);
        llDie();
    }
    land_collision(vector pos)
    {
        llRezObject("RedBlast",llGetPos() + <2.5,0,0>*llGetRot(),<0,0,0>,<0,0,0,0>,1);
        llDie();
    }
}