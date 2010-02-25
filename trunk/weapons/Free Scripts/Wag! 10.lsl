integer rot=30; //rotation you want, in degrees, measured in total swish arc.

tailwag(){
    llSetRot(<0,0,llSin(rot/2*DEG_TO_RAD),llCos(rot/2*DEG_TO_RAD)>); 
    llSleep(1.0); //sleep delay. longer delay for more swish
    llSetRot(<0,0,llSin(-rot/2*DEG_TO_RAD),llCos(-rot/2*DEG_TO_RAD)>);
    llSleep(1.0); //same as above
    llSetRot(<0,0,0,1>);       
    
}

default
{
    state_entry()
    {
        
        llSetTimerEvent(3 + llFrand(3));
    }
    
    touch_start(integer num){
        tailwag();   
    }
    timer()
    {
        tailwag();
        llSetTimerEvent(3 + llFrand(3));
    }
}