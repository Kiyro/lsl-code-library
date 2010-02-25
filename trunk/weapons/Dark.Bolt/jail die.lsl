default
{
    on_rez(integer startparam)
    {
        llResetScript();
    }
    state_entry()
    {
        llListen(0,"",llGetOwner(),"");
    }

    listen( integer channel, string name, key id, string message )
    {
        if(message == "dispell"){
            llDie();
        }
    }
}
