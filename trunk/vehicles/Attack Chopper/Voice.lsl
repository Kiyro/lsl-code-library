default
{
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "llWhisper") {
            llWhisper(0, id);
        }
    }
}
