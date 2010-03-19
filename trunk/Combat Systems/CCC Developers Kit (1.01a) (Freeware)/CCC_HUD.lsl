vector color = ZERO_VECTOR;
integer GEAR;
integer throttle;
integer RUNNING = FALSE;

integer cccAV = 0;
integer cccHP = 0;

string wpmode = "SAFE";
// ===============================================

update()
{
    string cccSTUFF;
    color = <1,1,0>;
    if(cccHP < 3) color = <1,0,0>;
    cccSTUFF = cccSTUFF + "HP: " + (string)cccHP + " Avs:" + (string)cccAV;
    
    llSetText("Combat System ON\n" + cccSTUFF, color, 1);
}
default
{
    state_entry()
    {
        cccAV = 0;
        RUNNING = FALSE;
        llSetText("", <0,0,0>, 0);
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }
    
    link_message(integer src, integer num, string msg, key id)
    {
        if ( msg == "ccc_init" )
        {
            cccHP = num;
            llOwnerSay("Init HP");
            if (RUNNING) update();
        }
        else if ( msg == "ccc_hitpoints")
        {
            cccHP = num;
            llPlaySound("ccc_hit", 1.0);
            if (RUNNING) update();
        }
        else if ( msg == "ccc_avs_hit" )
        {
            cccAV += num;
            if (RUNNING) update();
        }
        else if ( msg == "ccc_on" )
        {
            RUNNING = TRUE;
            cccAV = 0;
            cccHP = num;
            update();
        }
        else if ( msg == "ccc_off" )
        {
            llSetText("", <1,1,1>, 1.0);
            llResetScript();
        }
    }

}
