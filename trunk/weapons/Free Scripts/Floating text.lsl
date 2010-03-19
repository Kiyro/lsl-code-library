default
{
    state_entry()
    {
        llSay(0, "floating text");
        llSetText("Put your text here",<1,1,1>,1.0);
    }

    on_rez(integer start_param)
    {
        llResetScript();
    } 
}
