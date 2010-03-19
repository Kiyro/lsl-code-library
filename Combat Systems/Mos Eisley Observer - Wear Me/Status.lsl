integer online;

default
{
    on_rez(integer sparam)
    {
        llWhisper(0, "Super Collider commands: collide on, collide off");
    }
    
    state_entry()
    {
        online = FALSE;
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "status") {
            if (online) {
                llMessageLinked(sender, 0, "online", NULL_KEY);
            } else {
                llMessageLinked(sender, 0, "offline", NULL_KEY);
            }
        } else if (str == "set status") {
            online = num;
        }
    }
}
