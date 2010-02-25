// light script
// this script turns a light on and off by changing the color between black
//  and white when the object is clicked on by the owner or by the owner
//  saying "on" or "off" nearby

// on will be white
vector COLOR_ON = <1.0, 1.0, 1.0>;

// off will be black
vector COLOR_OFF = <0.0, 0.0, 0.0>;

// the light starts off
integer IS_ON = FALSE;

// this global function actually sets the color based on the IS_ON variable
set_color()
{
    if (IS_ON)
    {
        llTriggerSound("Button_click_down", 1.0);
        llSetColor(COLOR_ON, ALL_SIDES);
    }
    else
    {
        llTriggerSound("Button_click_up", 1.0);
        llSetColor(COLOR_OFF, ALL_SIDES);
    }
}

// scripts need to have a default state
default
{
    // the state_entry event is called when the script is first saved, so it is
    // useful for setting up defaults
    state_entry()
    {
        // setup listens to check for "on" and "off"
        // channel 0 means to listen for audible chats from avatars
        // we don't specific 
        llListen(0, "", llGetOwner(), "on");
        llListen(0, "", llGetOwner(), "off");
        
        set_color();
    }

    // the touch_start event is used to detect avatars clicking on the object
    touch_start(integer total_number)
    {
        // only allow the owner to turn the light on and off
        if (llDetectedKey(0) == llGetOwner())
        {
            // switch the state of the light
            IS_ON = !IS_ON;
            
            // reset the color
            set_color();
        }
    }

    // the listen event will be called by the owner chatting "on" or "off" near the object
    listen(integer channel, string name, key id, string text)
    {
        // check to see if it is "on" or "off"
        if (text == "on")
        {
            if (!IS_ON)
            {
                IS_ON = TRUE;
                set_color();
            }
        }
        else
        {
            if (IS_ON)
            {
                IS_ON = FALSE;
                set_color();
            }
        }
    }
}
