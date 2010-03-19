float alpha=1;

default
{
    on_rez(integer n)
    {
        llSetTimerEvent(0.05);
        alpha=1;
    }
    timer()
    {
        alpha-=0.125/4;
        llSetAlpha(alpha,ALL_SIDES);
        if(alpha<0)llDie();
    }
}
