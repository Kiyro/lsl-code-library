onpos()
{
        vector pos = llGetPos();
        string rgn = llGetRegionName();
        float vel = llVecMag(llGetVel());
        llSetText("Speed : " + (string)((integer)vel) + "\n" + "Height : " + (string)((integer)pos.z) + "\n" + rgn + " <" + (string)((integer)pos.x) + ", " + (string)((integer)pos.y)  + "> \n \n \n", <1,1,1>, 1);
}

default
{
    state_entry()
    {
        llListen(0,"","","");
        llSetTimerEvent(.25);
    }
    listen(integer channel, string name, key id, string msg)
    {
        if(msg == "reset ins")
        {
            llResetScript();
        }
    }
    timer()
    {
        onpos();
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
}
