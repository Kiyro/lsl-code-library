//This is a simple muzzle flash for the LoLSBS gun script.

default
{
    state_entry()
    {
        llSetAlpha(0.0, ALL_SIDES);
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        if (str == "fire")
        {
            llSetAlpha(0.2, ALL_SIDES);
            llSleep(0.05);
            llSetAlpha(0.0, ALL_SIDES);
        }
        else if (str == "unh")
        {
            llSetAlpha(0.0, ALL_SIDES);
        }
    }
}
