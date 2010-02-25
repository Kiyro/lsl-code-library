default
{
    link_message(integer sender, integer channel, string msg, key id)
    {
        if (msg == "sheath")    llSetAlpha(1, ALL_SIDES);
        else if (msg == "draw") llSetAlpha(0, ALL_SIDES);
    }
}
