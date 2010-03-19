default
{
    state_entry()
    {
        key owner = llGetOwner();
        llWhisper(0,"Cloaking ready");
        llListen(0,"",owner,"");
    }
    
    listen( integer channel, string name, key id, string message )
    {
        if( message == "close sails" )
        {
            llWhisper(0,"closing sails");
            llSetAlpha(0,ALL_SIDES);
        }
        if( message == "open sails" )
        {
            llWhisper(0,"opening sails");
            llSetAlpha(1,ALL_SIDES);
        }
    }
}
