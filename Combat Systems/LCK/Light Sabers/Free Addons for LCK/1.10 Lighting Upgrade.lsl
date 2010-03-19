// GPL legal stuff
//
// This script is free to use and distriubute, and full rights.
// However, including this script with a sold product (with value) is against the terms of use.
// This script may be distributed on its own, or with free products. It may NOT be sold.
// This GPL is to be included with this script, and any changes to it are to be commented and the script left open-source.
// The GPL covers all prior versions of the script, and must remain intact. Breaking these terms forbids the use
// of this script or any of its contents within.


vector saberColor;

default
{
    state_entry ()
    {
        llMessageLinked (LINK_SET, 0, "COLOR  <1.0,1.0,1.0>", NULL_KEY);
        llMessageLinked (LINK_SET, 0, "OFF", NULL_KEY);
        llOwnerSay ("Color settings have been reset.");
    }
    
    link_message (integer sender_num, integer num, string msg, key id)
    {
        if (msg == "OFF")
        {
            llSetPrimitiveParams ([PRIM_POINT_LIGHT, FALSE, saberColor, 1.0, 5.0, 0.75]);
        }
        
        else if (msg == "ON")
        {
            llSetPrimitiveParams ([PRIM_POINT_LIGHT, TRUE, saberColor, 1.0, 5.0, 0.75]);
        }
        
        else if (llGetSubString (msg, 0, 4) == "COLOR")
        {
            saberColor = (vector)llGetSubString (msg, 6, -1);
        }
    }
}