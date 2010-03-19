integer on = FALSE;
default
{
    state_entry()
    {
        llSetText("Click once to turn the particles on,\ntwice to turn them off.",<0.8,0.8,1>,1.0);
        llListen(0,"",llGetOwner(),"");
    }

    touch_start(integer total_number)
    {
        if(on != TRUE)
        {
            on = TRUE;
            llRezObject("Flower1",llGetPos(),<0,0,0>,<0,0,0,1>,1);
            llRezObject("Flower2",llGetPos(),<0,0,0>,<0,0,0,1>,1);
            llRezObject("Stem",llGetPos(),<0,0,0>,<0,0,0,1>,1);
        }
        else 
        {
            llSay(1,"die");
            on = FALSE;
        }
    }
    listen(integer chan, string name, key id, string msg)
    {
        if(llSubStringIndex(msg,"wave") != -1 || llSubStringIndex(msg,"color") != -1) llSay(1,msg);
    }
    on_rez(integer total_number)
    {
        llResetScript();
    }
}
