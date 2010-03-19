integer chan = 66;  // This is your custom chan. Also accepts commands on channel 1,
                    // and main chat (owner only, others accept chat from owner owned objects.

default
{
    state_entry ()
    {
        llListen (0, "", llGetOwner(), "");
        llListen (1, "", NULL_KEY, "");
        llListen (chan, "", NULL_KEY, "");
    }
    
    listen (integer channel, string name, key id, string message)
    {
        if (llGetOwnerKey(id) == llGetOwner())
        {
            if (message == "/ls on")
            {
                llSetLinkAlpha (LINK_SET, 0.0, ALL_SIDES);
            }
            else if (message == "/ls off")
            {
                llSetLinkAlpha (LINK_SET, 1.0, ALL_SIDES);
            }
        }
    }
}
