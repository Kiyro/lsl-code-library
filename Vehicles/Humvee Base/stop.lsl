default
{
    state_entry()
    {
        
        key owner = llGetOwner();
     
        llListen(0,"",owner,"");
    }
    on_rez(integer sparam)
    {
        llResetScript();
    }
    listen( integer channel, string name, key id, string message )
    {
        integer gCmdChannel = 0; //you can set the channel to whatever you want here by replacing the '0' with any other number same with the '0' on line "llListen(0,"","","");
        if( message == "s" )
        {
            
            llStopSound();
        }
    }
}
