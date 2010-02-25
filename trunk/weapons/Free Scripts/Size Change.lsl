default


{

    state_entry()
    {
        
        
        llSetTimerEvent(2.0);
    }

    timer() 
    {
        
        llSetScale(<llFrand(1.0), llFrand(1.0), llFrand(1.0)>);
        
    }
    state_exit()
    {
        llSetTimerEvent(0);
    }    
}