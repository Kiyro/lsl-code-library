default
{
    state_entry()
    {
        llSetTimerEvent(0.0);
    }
    
    on_rez(integer n)
    {
        llResetScript();
    }

    timer()
    {
        llSetColor(<1,1,0.98>, ALL_SIDES);
        llSleep(0.1);
        llSetColor(<1,1,1>, ALL_SIDES);
    }
    
    link_message(integer src, integer num, string msg, key id)
    {
        if ( msg == "runloop" )
        {
            llSetTimerEvent(0.25);
        }
        else if ( msg == "rundown" )
        {
            llSetTimerEvent(0.0);
            integer i;
            for(i=0; i > 30; i++)
            {
                llSetColor(<1,1,0.99>, ALL_SIDES);
                llSetColor(<1,1,1>, ALL_SIDES);
                llSleep(0.25);
            }
        }
    }
}
