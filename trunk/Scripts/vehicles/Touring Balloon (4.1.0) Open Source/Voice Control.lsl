integer LISTEN_API   = 95562;
integer CHAT_CHANNEL = 482;

integer chatChannel = 0;
integer indexChat;

default
{
    state_entry()
    {
        indexChat = llListen(chatChannel, "", NULL_KEY, "");
    }
    on_rez(integer startup_param)
    {
        llResetScript();
    }
    listen(integer channel, string name, key id, string message)
    {
        if (name != "Display Panel")
        {
            if ((llSameGroup(id)) || (id == llGetOwner()))
            {
                llMessageLinked(LINK_SET, LISTEN_API, message, id); 
            }
         }
    }
    link_message(integer sender_num, integer num, string str, key id)
    {
        if (num == CHAT_CHANNEL)
        {
            chatChannel = (integer)str;
            llListenRemove(indexChat);
            indexChat = llListen(chatChannel, "", NULL_KEY, "");
        }
    }

}
