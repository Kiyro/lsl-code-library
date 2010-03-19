default
{
    on_rez(integer param)
    {
        if (param == 0) return;
        llSetTimerEvent(8.0);
        llMessageLinked(LINK_THIS,0,"boom","");
    }
    timer()
    {
        llMessageLinked(LINK_THIS,0,"fadeout",NULL_KEY);
    }
}