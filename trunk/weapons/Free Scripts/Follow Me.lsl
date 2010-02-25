default
{
    state_entry()
    {
        vector pos = llGetPos();
        llSetStatus(STATUS_ROTATE_Z, FALSE);
        llSetStatus(STATUS_PHYSICS, TRUE);
        llSleep(0.1);
        llMoveToTarget(pos,0.1);
        key id = llGetOwner();
        llSensorRepeat("","",AGENT,200000,7000*PI,.4);
    }

    sensor(integer total_number)
    {
        vector pos = llDetectedPos(0);
        vector offset =<-1,0,1>;
        pos+=offset;
        llMoveToTarget(pos,.3);     
    }
}
