default
{
    state_entry()
    {
        key owner = llGetOwner();
        llWhisper(0,"Cloaking device installed");
        llListen(0,"",owner,"");
    }
    
    listen( integer channel, string name, key id, string message )
    {
        if( message == "cloak" )
        {
            vector tne = llGetLocalPos() + <25.0,25.0,25.0>;
            vector bsw = llGetLocalPos() - <25.0,25.0,25.0>;
        
            
            llMessageLinked(LINK_ALL_CHILDREN, 0, "cloak", id);
            llSetStatus(STATUS_PHANTOM, TRUE);
            llSetAlpha(0,ALL_SIDES);
            llTriggerSoundLimited("49920d45-3e53-c2e1-9a09-e58e8f452265", 1.0, tne, bsw);
        }
        if( message == "decloak" )
        {
            vector tne = llGetLocalPos() + <25.0,25.0,25.0>;
            vector bsw = llGetLocalPos() + <-25.0,-25.0,-25.0>;
        
            
            llMessageLinked(LINK_ALL_CHILDREN, 0, "decloak", id);
            llSetStatus(STATUS_PHANTOM, FALSE);
            llSetAlpha(1,ALL_SIDES);
            llTriggerSoundLimited("47117bd7-41e8-530d-439c-94bee925fbb7",1.0, tne, bsw);
        }
    }
}