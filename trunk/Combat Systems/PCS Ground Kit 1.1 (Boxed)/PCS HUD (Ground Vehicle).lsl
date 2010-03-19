vector color = ZERO_VECTOR;
integer GEAR;
integer throttle;
integer RUNNING = FALSE;
string hitsnd = "691043d2-9807-76a6-13d7-9aef3dc7c074";
integer cccON = FALSE;
integer cccAV = 0;
integer cccHP = 0;
// ===============================================

update()
{
        vector cpos = llGetPos();
        float ground = llGround(<0,0,0>);
        float agl = cpos.z - ground;
        string stat;
        
        string A = (string)agl;
        integer p2 = llSubStringIndex(A,".");
        A = llGetSubString(A, 0, p2 + 3);
        
        color = <0,1,1>;
        
        string cccSTUFF = "\n";
        
        if ( cccON )
        {
            color = <1,1,0>;
            if(cccHP < 50) color = <1,0,0>;
            cccSTUFF = cccSTUFF + "Hull: " + (string)cccHP + "%";
        }
        
        string speed = (string)llVecMag(llGetVel());
        
        speed = llGetSubString(speed, 0, llSubStringIndex(speed, ".") + 2);
        llSetText("Speed: " + speed + "m/s\nAGL:" + A + cccSTUFF, color, 1);
    
}
default
{
    state_entry()
    {
        cccON = FALSE;
        cccAV = 0;
        RUNNING = FALSE;
        llSetTimerEvent(0);
        llSetText("", <0,0,0>, 0);
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }
    
    timer()
    {
        update();
    }
    
    link_message(integer src, integer num, string msg, key id)
    {
        if (msg == "runloop")
        {
            RUNNING = TRUE;
            update();
            llSetTimerEvent(0.5);
        }
        else if (msg == "rundown")
        {
            RUNNING = FALSE;
            llSetTimerEvent(0);
            llSleep(0.25);
            llSetText("", <0,0,0>, 0);
            llResetScript();
        }
        else if ( msg == "ccc_init" )
        {
            cccHP = num;
            llOwnerSay("Init HP");
            if (RUNNING) update();
        }
        else if ( msg == "ccc_hitpoints")
        {
            cccHP = num;
            if(cccHP < 100)
            {
                llPlaySound(hitsnd, 1.0);
            }
            if (RUNNING) update();
        }
        else if ( msg == "ccc_avs_hit" )
        {
            cccAV = num;
            if (RUNNING) update();
        }
        else if ( msg == "ccc_on" )
        {
            cccON = TRUE;
            cccAV = 0;
            cccHP = num;
            if (RUNNING) update();
        }
        else if ( msg == "ccc_off" )
        {
            cccON = FALSE;
            if (RUNNING) update();
        }
        else if ( msg == "THROTTLE" )
        {
            throttle=num;
            if (RUNNING) update();
        }
    }

}
