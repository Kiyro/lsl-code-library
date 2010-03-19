integer effects = TRUE;

dropclip()
{
    llRezObject("clip",llGetPos() + <0,.5,-0.45>,ZERO_VECTOR,ZERO_ROTATION,0);
}

default
{
    link_message(integer sender_num,integer num,string str,key id)
    {
        if (str == "reload" && effects)
        {
           // llSetAlpha(0.0,ALL_SIDES);
            dropclip();
            llSleep(3);
           // llSetAlpha(1.0,ALL_SIDES);
        }
        if(str == "effectson")
        {
            effects = TRUE;
        }
        if(str == "effectsoff")
        {
            effects = FALSE;
        }
    }
    
}
