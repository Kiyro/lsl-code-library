integer holstered = FALSE;
integer listen1;
integer listen2;

init()
{
    llListenRemove(listen1);
    llListenRemove(listen2);
    listen1 = llListen(0, "", llGetOwner(), "");
    listen2 = llListen(2657, "", llGetOwner(), "");
    //Dialog channel. The number must be the same as in the main gun script.
}

default
{
    state_entry()
    {
        init();
    }
    
    attach(key id)
    {
        init();
    }
    
    listen(integer channel, string name, key id, string message) 
    {
        if(llToLower(message) == "raise")
        {
            llMessageLinked(LINK_SET, 0, "", NULL_KEY);
            holstered = TRUE;
        }
        else if(llToLower(message) == "lower")
        {
            llMessageLinked(LINK_SET, 1, "", NULL_KEY);
            holstered = FALSE;
        }
    }
}
