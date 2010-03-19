integer invis = TRUE; //Set to true to make this part turn visisble/invisible when the user tells it to holster or unholster. Set to false to only have it show the menu when clicked.

default
{
    state_entry()
    {
        if (invis)
        {
            llListen(-873145, "", NULL_KEY, "");
            //Communication channel. The number must be the same as in the main gun script.
        }
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            llSay(-873145, "Menu" + (string)llGetOwner());
            //Opens the menu
        }
    }
    
    listen(integer channel, string name, key id, string message) 
    {
        if (invis)
        {
            if (message == "holster" + (string)llGetOwner())
            {
                llSetLinkAlpha(LINK_SET, 1.0, ALL_SIDES);
            }
            else if (message == "unholster" + (string)llGetOwner())
            {
                llSetLinkAlpha(LINK_SET, 0.0, ALL_SIDES);
            }
        }
    }

}
