default
{
    link_message(integer sender_num, integer num, string str, key id)
    {
        if (str == "ON")
        {
            llSetLinkAlpha (LINK_SET, 1.0, ALL_SIDES);
        }
        else if (str == "OFF")
        {
            llSetLinkAlpha (LINK_SET, 0.0, ALL_SIDES);
        }
    }
}
