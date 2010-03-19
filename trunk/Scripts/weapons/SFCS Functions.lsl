default
{
    link_message(integer sender, integer num, string msg, key id)
    {
        if(msg == "startregen")
        {
            llSetTimerEvent(0.75);
        }
        else if(msg == "stopregen")
        {
            llSetTimerEvent(0.0);
        }
    }
    timer()
    {
        llMessageLinked(LINK_THIS, 0, "regen", NULL_KEY);
    }
}
