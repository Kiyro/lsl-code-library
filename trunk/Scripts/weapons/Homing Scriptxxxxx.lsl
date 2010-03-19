//Homing Script
//Set how fast you want the object to move
float movespeed = 0.1;
//Set how often to track avatars
float tick = 0.1;
default
{
    state_entry()
    {
        vector pos = llGetPos();
        llSetStatus(STATUS_PHYSICS, TRUE);
        llSleep(0.1);
        llMoveToTarget(pos,0.1);
        llSensorRepeat("","",AGENT,200000,7000*PI,tick);
    }

    sensor(integer total_number)
    {
        vector pos = llDetectedPos(0);
        vector offset =<-0,0,0>;
        pos+=offset;
        if (llDetectedOwner(0) == llGetOwner())
        {
        }
        else
        {
        llMoveToTarget(pos,movespeed);
        llLookAt(pos,2,1);
        }
        
    }
}
