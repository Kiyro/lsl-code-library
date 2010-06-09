string owner;
checkown()
{
    owner =llGetOwner();
}
default
{
    state_entry()
    {
        checkown();
        owner = llGetOwner();
        llListen(0,"",owner,"");
    }

    listen(integer c, string n, key id, string m)
    {
        if(m=="laser")
        {
            llMessageLinked(LINK_SET,0,"las",NULL_KEY);
        }
        if(m=="scope")
        {
            llMessageLinked(LINK_SET,0,"scope",NULL_KEY);
        }
        if(m=="silencer")
        {
            llMessageLinked(LINK_SET,0,"sil",NULL_KEY);
        }
         if(m=="laser_off")
        {
            llMessageLinked(LINK_SET,0,"laser_off",NULL_KEY);
        }
         if(m=="scope_off")
        {
            llMessageLinked(LINK_SET,0,"scope_off",NULL_KEY);
        }
        if(m=="silencer_off")
        {
            llMessageLinked(LINK_SET,0,"sil_off",NULL_KEY);
        }
    }
}
