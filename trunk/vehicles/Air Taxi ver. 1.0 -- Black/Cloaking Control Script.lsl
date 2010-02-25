init()
{
    // Set up a listen callback for whoever owns this object.
    key owner = llGetOwner();
    llWhisper(0, "Cloaking device installed");
    llListen(0, "", owner, "");
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
    
    listen( integer channel, string name, key id, string message )
    {
        if( message == "phantom" )
        {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "phantom", id);
            llSetStatus(STATUS_PHANTOM, TRUE);
        }
        if( message == "solid" )
        {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "solid", id);
            llSetStatus(STATUS_PHANTOM, FALSE);
        }
    }
}