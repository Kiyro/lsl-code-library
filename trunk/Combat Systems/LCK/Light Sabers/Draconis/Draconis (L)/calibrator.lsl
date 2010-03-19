default
{
    link_message(integer sender_num, integer num, string msg, key id)
    {
        if(msg == "HIDE CAL")
        {
            llSetAlpha(0.0,ALL_SIDES);
        }
        else if(msg == "SHOW CAL")
        {
            llSetAlpha(1.0,ALL_SIDES);
        }
    }
}
