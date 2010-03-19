integer effects = TRUE;
default
{
    link_message(integer sender_num,integer num,string str,key id)
    {
        
        if(str == "fire" && id == (string)"2" || str == "fire" && id == (string)"3")
        {
            integer ammo = (integer)llGetObjectDesc();
            if(ammo > 0)
            {
                llRezObject("shell",llGetPos() + <llFrand(1.0),llFrand(1.0),0>,ZERO_VECTOR,llGetRot(),0);
            }
        }
        
    }
}
