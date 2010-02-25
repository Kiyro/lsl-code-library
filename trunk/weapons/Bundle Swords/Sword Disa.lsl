default
{
    state_entry()
    {
        key owner = llGetOwner();
        llListen(12,"","","");
    }
    
    listen( integer channel, string name, key id, string message )
    {
        if( message == (string)llKey2Name(llGetOwner())+" invis" )
        {
            llSetAlpha(0,ALL_SIDES);
        }
        if( message == (string)llKey2Name(llGetOwner())+" vis" )
        {
            llSetAlpha(1,ALL_SIDES);
        }
    }
}
