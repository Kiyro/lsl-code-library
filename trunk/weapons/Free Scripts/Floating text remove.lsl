default
{
    state_entry()
    {
        llSay(0, "Remove floating text");
        llSetText("",<0,0,0>,0.0);
    }

    on_rez(integer start_param)
    {
        llResetScript();
    } 
}
