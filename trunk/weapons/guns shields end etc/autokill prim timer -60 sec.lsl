default 
{ 
    state_entry() 
    { 
        llSetTimerEvent(60); 
    } 

    timer() 
    { 
        llMessageLinked(LINK_SET,0,"DIE",NULL_KEY);
    } 
} 