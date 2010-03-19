vector saberColor;
integer saberOn = FALSE;
init()
{
    llListen(69, "", "", "");
}
disappear()
{
    llSetTimerEvent(4.0);
    llSetLinkAlpha(ALL_SIDES, 0, ALL_SIDES);
}
appear()
{
    llSetLinkAlpha(ALL_SIDES, 1, ALL_SIDES);
    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);                
    llMessageLinked(LINK_SET,0,"HIDE CAL",NULL_KEY);
    llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);            
    llMessageLinked(LINK_SET,0,"ON",NULL_KEY);
    llSetTimerEvent(0);
}
default
{
    state_entry()
    {
        init();
    }
    on_rez(integer start_param)
    {
        init();
    }
    attach(key attached)
    {
        init();
    }
    timer()
    {
        appear();
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
        rotation rot;
        vector pos;
        if(num == 69069)
        {
            rot = llGetRot();
            pos = llGetPos() - llRot2Left(rot);
            llRezObject("throw bullet", pos, ZERO_VECTOR, ZERO_ROTATION, -169);
            llSleep(0.15);
            llShout(-170, (string)saberColor);
            llSleep(0.05);
            llShout(-169, msg);
            disappear();
        }
        else if(llGetSubString(msg,0,4) == "COLOR")
        {
            saberColor = (vector)llGetSubString(msg,6,-1);
        }
    }
    listen(integer chan, string name, key id, string msg)
    {
        if(llGetOwnerKey(id) == llGetOwner())
        {
            if(llToLower(msg) == "on" || llToLower(msg) == "both on")
            {
                saberOn = TRUE;
            }
            else if(llToLower(msg) == "off")
            {
                saberOn = FALSE;
            }
        }
    }
}
