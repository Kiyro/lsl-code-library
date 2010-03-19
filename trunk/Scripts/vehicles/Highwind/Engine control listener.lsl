default
{
    state_entry()
    {
        llListen(0, "", llGetOwner(), "");
    }
    
    on_rez(integer n)
    {
        llResetScript();
    }

    listen(integer chan, string name, key id, string msg)
    {
        if (msg == "Contact")
        {
            llMessageLinked(LINK_SET, 0, "start", NULL_KEY);
        }
        else if (msg == "Kill engines")
        {
            llMessageLinked(LINK_SET, 0, "stop", NULL_KEY);
        }
    }
}
