default
{
    link_message(integer sendernum, integer num, string str, key id)
    {
        if (str == "fadeout")
        {
            float i;
            for (i = 1.0; i > 0.0; i-=.1)
            {
                llSetScale(<i*3,i*3,i*3>);
                llSetAlpha(i,ALL_SIDES);
            }
            llDie();
        }
    }
}