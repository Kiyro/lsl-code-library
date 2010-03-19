default
{
    
    state_entry()
    {
        llSetTimerEvent(3.0);
    }
    
    timer()
    {
        float x = llFrand(1);
        float y = llFrand(1);
        float z = llFrand(1);
        llSetColor(<x,y,z>,ALL_SIDES);
    }
}
