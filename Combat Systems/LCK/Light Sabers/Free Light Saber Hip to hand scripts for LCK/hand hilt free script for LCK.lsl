//Extracted from LCK 2.0's core script and modified for hilts by Hanumi
//Takakura. Use under GNU license. Please put your name on any changes.
//vector saberColor;

default
{
    link_message(integer sender_num, integer num, string msg, key id)
    {
        if(msg == "OFF")
        {
            llSetAlpha(0,ALL_SIDES);
        }
        else if(msg == "ON")
        {
            llSetAlpha(1,ALL_SIDES);
        }
    }
}