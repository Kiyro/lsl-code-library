integer seated = FALSE;
integer particles_on = FALSE;
vector pos;

default
    {
    on_rez(integer num)
    {
    llSetTimerEvent(0);
    }
    timer()
    {
    integer speed = (integer)(llVecMag(llGetVel()) * 1.94384449 + 0.5);         
             
    if(speed > .00001)
    {
    if(!particles_on)
    {
    llMessageLinked(LINK_SET, 0, "particles on", "");
    particles_on = TRUE;
    }
    }
    else
    {
    if(particles_on)
    {
    llMessageLinked(LINK_SET, 0, "particles off", "");
    particles_on = FALSE;
    } 
    }      
    }
    link_message(integer sender_number, integer number, string message, key id)
    {
    if (message == "start")
    {
    seated = TRUE;
    llSetTimerEvent(0.5);
    }
    else if (message == "stop")
    {
    seated = FALSE;
    llSetTimerEvent(0.0);
    llMessageLinked(LINK_SET, 0, "particles off", "");
    particles_on = FALSE;
    }    
    }          
} 
 
