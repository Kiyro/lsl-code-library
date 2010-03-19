default
{
    state_entry()
    {
        vector pos = llGetPos();
        llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y, FALSE);
        llSetStatus(STATUS_PHYSICS, TRUE);
        llSleep(0.1);
        llMoveToTarget(pos,0.1);
        key id = llGetOwner();
        llSensorRepeat("",id,AGENT,20,2*PI,.4);
    }

    sensor(integer total_number)
    {
        vector pos = llDetectedPos(0);
        vector offset =<-1,0,0>;
        pos+=offset;
        llMoveToTarget(pos,.3);        
    }
}
