default
{
    state_entry()
    {
        llListen(0, "", llGetOwner(), "kill");
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }

    listen(integer channel, string name, key id, string message)
    {
        llDie();
    }
}
