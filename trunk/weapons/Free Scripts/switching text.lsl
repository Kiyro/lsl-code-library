string text="Put your text here";
integer switch=TRUE;
default
{
    state_entry()
    {
        llSay(0, "floating text");
        llSetTimerEvent(2);
    }

    on_rez(integer start_param)
    {
        llResetScript();
    } 
    
    timer()
    {
        if(switch) 
        {
            switch=FALSE;
            llSetText(text,<1,1,1>,1.0);
        }
        else
        {
            switch=TRUE;
            llSetText(text,<1,0,0>,1.0);
        }
    }
}
