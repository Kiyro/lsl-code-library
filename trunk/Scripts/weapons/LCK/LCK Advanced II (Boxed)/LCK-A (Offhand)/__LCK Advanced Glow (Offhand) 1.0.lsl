vector glowColor;
integer glow = FALSE;
integer saberOn = FALSE;
init()
{
    llListen(69, "", "", "");
    glow = FALSE;
    llSetPrimitiveParams([PRIM_POINT_LIGHT, glow, glowColor,  1.0, 6.0, 0.0]);
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
    listen(integer chan, string name, key id, string msg)
    {
        if(llGetOwnerKey(id) == llGetOwner())
        {
            if(llToLower(msg) == "glow")
            {
                if(glow == FALSE)
                {
                    glow = TRUE;
                    llOwnerSay("Saber Glow Turned On");
                }
                else if(glow == TRUE)
                {
                    glow = FALSE;
                    llOwnerSay("Saber Glow Turned Off");                    
                }
                if(saberOn == TRUE)
                {
                    llSetPrimitiveParams([PRIM_POINT_LIGHT, glow, glowColor,  1.0, 6.0, 0.0]);
                }

            }
            else if(llToLower(msg) == "both on")
            {
                saberOn = TRUE;
                if(glow == TRUE)
                {
                    llSetPrimitiveParams([PRIM_POINT_LIGHT, glow, glowColor,  1.0, 6.0, 0.0]);
                }
            }
            else if(llToLower(msg) == "off" || llToLower(msg) == "on")
            {
                saberOn = FALSE;
                llSetPrimitiveParams([PRIM_POINT_LIGHT, FALSE, glowColor,  1.0, 6.0, 0.0]);
            }

        }
    }

    link_message(integer sender_num, integer num, string msg, key id)
    {
        if(llGetSubString(msg,0,4) == "COLOR")
        {
            glowColor = (vector)llGetSubString(msg,6,-1);
            if(saberOn == TRUE)
            {
                llSetPrimitiveParams([PRIM_POINT_LIGHT, glow, glowColor,  1.0, 6.0, 0.0]);
            }
                
        }
    }
}
