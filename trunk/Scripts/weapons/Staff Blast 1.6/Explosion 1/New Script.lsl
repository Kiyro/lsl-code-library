default
{
    on_rez(integer t)
    {
        if(t != 0) 
        { 
            llSetTimerEvent(1);
           llTriggerSound("645f0d59-fdfc-41d1-7598-50b61bb17730", 1);
          llRezObject("smoke",llGetPos(),<0,0,0>,ZERO_ROTATION,1);
          // llRezObject("frag",llGetPos() + <0,0,4>,<0,0,0>,ZERO_ROTATION,1);
        }
    }
    timer()
    {
        llDie();
    }
}
