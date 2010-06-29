init()
{
    llListen(80, "", "", "");
    llSetLinkAlpha(ALL_SIDES, 1, ALL_SIDES);    
}
appear()
{
    llSetLinkAlpha(ALL_SIDES, 1, ALL_SIDES);
}
disappear()
{
    llSetLinkAlpha(ALL_SIDES, 0, ALL_SIDES);  
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
            if(llToLower(msg) == "draw")
            {
                disappear();
            }
            if(llToLower(msg) == "sling")
            {
                appear();
            }
        }
    }
}
