integer gDie = 120; // How long till it dies in seconds.

default
{
    on_rez(integer param)
    {
        llSetTimerEvent(gDie); 
    }

    timer()
    {
        llDie();
    }
} 