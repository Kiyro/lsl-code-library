init()
{
    // Set up a listen callback for whoever owns this object.
    key owner = llGetOwner();
    llWhisper(0, "Cloaking device installed");
    llListen(0, "", owner, "");
}

integer WingsOpen;
integer CanopyOpen;

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
        if( message == "ccc on" )
        {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "combat on", id);
            llMessageLinked(LINK_ALL_CHILDREN, 0, "wing_open", id);
        }
        if( message == "ccc off" )
        {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "combat off", id);
            llMessageLinked(LINK_ALL_CHILDREN, 0, "wing_close", id);
        }
        if( message == "w")
        {
            if(WingsOpen == 0)
            {
                llMessageLinked(LINK_ALL_CHILDREN, 0, "wing_open", id);
                WingsOpen = 1;
            }
            else
            {
                llMessageLinked(LINK_ALL_CHILDREN, 0, "wing_close", id);
                WingsOpen = 0;
            }
        }
        if( message == "c")
        {
            if(CanopyOpen == 0)
            {
                llMessageLinked(LINK_ALL_CHILDREN, 0, "canopy_open", id);
                CanopyOpen = 1;
            }
            else
            {
                llMessageLinked(LINK_ALL_CHILDREN, 0, "canopy_close", id);
                CanopyOpen = 0;
            }
        }
            
    }
}