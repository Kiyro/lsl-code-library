default
{
    
    state_entry()
    {
        llSetAlpha(0,ALL_SIDES);
    }
    
    on_rez(integer t)
    {
        if(t>0)
        {
            llSetDamage(t);
            llSetTimerEvent(.5);
        }
    }
    
    timer()
    {
        llDie();
    }
}
