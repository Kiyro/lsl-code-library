integer push;

default
{
    
    state_entry()
    {
        llVolumeDetect(TRUE);
        push=TRUE;
    }
    
    on_rez(integer t)
    {
        if(t != 0) 
        { 
            
            if(t<0)
                push=FALSE;
            llSetTimerEvent(1);
           llTriggerSound("645f0d59-fdfc-41d1-7598-50b61bb17730", 1);
          llRezObject("smoke",llGetPos(),<0,0,0>,ZERO_ROTATION,1);
          // llRezObject("frag",llGetPos() + <0,0,4>,<0,0,0>,ZERO_ROTATION,1);
        }
    }
    
    collision_start(integer t)
    {
        integer s=0;
        if(!push)
            return;
        string thisid;
        for(s=0;s<t;s++)
        {
            thisid=llKey2Name(llDetectedKey(s));
            if(thisid!="Aether Blast")
            {
                llPushObject(llDetectedKey(s), 9999999999999999999999999.0*<1,0,0>*llRotBetween(ZERO_VECTOR,llDetectedPos(s)-llGetPos()), ZERO_VECTOR, FALSE);
            }
        }
    }
    
    timer()
    {
        llDie();
    }
}
