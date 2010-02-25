// Written by Alex Harbinger

string search;
integer first;

default
{
    on_rez(integer start_param)
    {
       llResetScript();
    }
    state_entry()
    {
        llListen(0, "", "", "");
        llListen(50, "", "", "");
        llSetSitText("No escape.");
        llSitTarget(<0,0,0.01>, ZERO_ROTATION);
        first = TRUE;
    }
    listen(integer channel, string name, key id, string message)
    {
        if(id == llGetOwner())
        {
            if(message == "dispell")
            {
                llDie();
            }
        }
        if(channel == 50)
        {
            if(first == TRUE)
            {
                if(llGetSubString(message,0,4) == "dark ")
                {
                    string temp = llGetSubString(message,5,llStringLength(message));                
                    search = temp;
                    llSensorRepeat("", "", AGENT, 96, TWO_PI, 0.01);
                    llSetTimerEvent(10);
                    first = FALSE;
                }    
            }
        }
    }
    changed(integer change)
    {
        llUnSit(llAvatarOnSitTarget());
    }
    timer()
    {
        llSensorRemove();
    }
    sensor(integer num)
    {
        integer i;
        for(i=0;i<num;i++)
        {
            if(llGetSubString(llToLower(llDetectedName(i)),0,llStringLength(search) - 1) == llToLower(search))
            {
                if(llVecDist(llDetectedPos(i), llGetPos()) > 3.0)
                {
                    llSetPos(llDetectedPos(i));
                    llSetPos(llDetectedPos(i));
                    llSetPos(llDetectedPos(i));
                }
            }
        }
    }
} 