vector glowColor;
vector glowColor2;
vector mixglowColor;
float range;
integer glow = FALSE;
integer saberOn = 0;
init()
{
    llListen(69, "", "", "");
    glow = FALSE;
    llSetPrimitiveParams([PRIM_POINT_LIGHT, glow, glowColor,  1.0, 6.0, 0.0]);    
}
getmix()
{
    if(saberOn == 1)
    {
        mixglowColor = glowColor;
    }
    else if(saberOn == 2)
    {
        if(glowColor.x > glowColor2.x)
        {
            mixglowColor.x = glowColor.x;
        }
        else
        {
            mixglowColor.x = glowColor2.x;
        }
        if(glowColor.y > glowColor2.y)
        {
            mixglowColor.y = glowColor.y;
        }
        else
        {
            mixglowColor.y = glowColor2.y;
        }
        if(glowColor.z > glowColor2.z)
        {
            mixglowColor.z = glowColor.z;
        }
       else
        {
            mixglowColor.z = glowColor2.z;
        }
    }
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
                if(saberOn > 0)
                {
                    llSetPrimitiveParams([PRIM_POINT_LIGHT, glow, mixglowColor,  1.0, range, 0.0]);
                }

            }
            else if(llToLower(msg) == "on" || llToLower(msg) == "both on")
            {
                if(llToLower(msg) == "on")
                {
                    saberOn = 1;
                    mixglowColor = glowColor;
                    range = 6.0;
                }
                else if(llToLower(msg) == "both on")
                {
                    saberOn = 2;
                    getmix();
                    range = 10.0;
                }
                if(glow == TRUE)
                {
                    llSetPrimitiveParams([PRIM_POINT_LIGHT, glow, mixglowColor,  1.0, range, 0.0]);
                }
            }
            else if(llToLower(msg) == "off")
            {
                saberOn = FALSE;
                llSetPrimitiveParams([PRIM_POINT_LIGHT, FALSE, mixglowColor,  1.0, range, 0.0]);
            }
            
        }
    }

    link_message(integer sender_num, integer num, string msg, key id)
    {
        if(llGetSubString(msg,0,4) == "COLOR")
        {
            glowColor = (vector)llGetSubString(msg,6,-1);
            getmix();
            if(saberOn != 0)
            {
                llSetPrimitiveParams([PRIM_POINT_LIGHT, glow, mixglowColor,  1.0, range, 0.0]);
            }
                
        }
        else if(llGetSubString(msg,0,5) == "2COLOR")
        {
            glowColor2 = (vector)llGetSubString(msg,7,-1);
            getmix();
            if(saberOn != 0)
            {
                llSetPrimitiveParams([PRIM_POINT_LIGHT, glow, mixglowColor,  1.0, range, 0.0]);
            }
                
        }    }
}
