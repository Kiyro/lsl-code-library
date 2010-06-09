default
{
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "IM") {
            llInstantMessage(llGetOwner(), id);
        }
    }
}
