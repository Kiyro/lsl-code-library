key pilot = NULL_KEY;
key passenger = NULL_KEY;
integer menulisten;
integer display = TRUE;
integer cruise = FALSE;
integer locked = FALSE;
integer locator = TRUE;
integer power = FALSE;
integer opaque_glass = TRUE;

main_menu(key id)
{
    list buttons = [];
    string text = "--------------------------------\n| RA-2 Hammerhead Options Renee rules |\n--------------------------------\n";
    buttons += "Open/Close";
    text += "The jet is: ";
    if (locked) {
        text += "       LOCKED\n";
        buttons += "Unlock";
    } else {
        text += "       UNLOCKED\n";
        buttons += "Lock";
    }
    text += "Locator: ";
    if (opaque_glass) {
        buttons += "2 Way Glass";
    } else {
        buttons += "1 Way Glass";
    }
    if (locator) {
        text += "         ON\n";
        buttons += "Locator Off";
    } else {
        text += "         OFF\n";
        buttons += "Locator On";
    }
    text += "Display: ";
    if (display) {
        text += "          ON\n";
        buttons += "Display Off";
    } else {
        text += "          OFF\n";
        buttons += "Display On";
    }
    text += "Cruise Mode: ";
    if (cruise) {
        text += " ON\n";
        buttons += "Cruise Off";
    } else {
        text += " OFF\n";
        buttons += "Cruise On";
    }
    if (power) {
        buttons += "Power Down";
    } else {
        buttons += "Power Up";
    }
    buttons += ["Eject Pass.", "HELP"];
    llDialog(id, text, buttons, -20000);
}

default
{
    touch_start(integer n)
    {
        if (llDetectedKey(0) == passenger || llDetectedKey(0) == pilot) {
            main_menu(llDetectedKey(0));
        }
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "pilot") {
            if (id != NULL_KEY) {
                pilot = id;
                llListenRemove(menulisten);
                menulisten = llListen(-20000, "", NULL_KEY, "");
            } else {
                pilot = NULL_KEY;
                if (passenger == NULL_KEY) {
                    llListenRemove(menulisten);
                }
            }
        } else if (str == "passenger1" || str == "passenger2") {
            if (id != NULL_KEY) {
                if (id == llGetOwner()) {
                    passenger = id;
                    llListenRemove(menulisten);
                    menulisten = llListen(-20000, "", NULL_KEY, "");
                }
            } else {
                passenger = NULL_KEY;
                if (pilot == NULL_KEY) {
                    llListenRemove(menulisten);
                }
            }
        } else if (str == "display off") {
            display = FALSE;
        } else if (str == "display on") {
            display = TRUE;
        } else if (str == "cruise") {
            cruise = num;
        } else if (str == "lock") {
            locked = num;
        } else if (str == "start") {
            power = TRUE;
        } else if (str == "stop") {
            power = FALSE;
        } else if (str == "locator") {
            locator = num;
        } else if (str == "opaque glass") {
            opaque_glass = num;
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id == passenger || id == pilot) {
            if (message == "Unlock") {
                llMessageLinked(LINK_SET, FALSE, "lock", NULL_KEY);
            } else if (message == "Lock") {
                llMessageLinked(LINK_SET, TRUE, "lock", NULL_KEY);
            } else if (message == "Display Off") {
                llMessageLinked(LINK_SET, 0, "display off", NULL_KEY);
            } else if (message == "Display On") {
                llMessageLinked(LINK_SET, 0, "display on", NULL_KEY);
            } else if (message == "Cruise Off") {
                llMessageLinked(LINK_SET, FALSE, "cruise", NULL_KEY);
            } else if (message == "Cruise On") {
                llMessageLinked(LINK_SET, TRUE, "cruise", NULL_KEY);
            } else if (message == "Power Up") {
                 llMessageLinked(LINK_SET, 0, "start", NULL_KEY);
            } else if (message == "Power Down") {
                 llMessageLinked(LINK_SET, 0, "stop", NULL_KEY);
            } else if (message == "Open/Close") {
                 llMessageLinked(LINK_ALL_CHILDREN, 0, "touch", id);
            } else if (message == "HELP") {
                llGiveInventory(id, "Hammerhead Help");
            } else if (message == "Eject Left") {
                llMessageLinked(LINK_ALL_OTHERS, 0, "eject left", NULL_KEY);
            } else if (message == "Eject Both" || message == "Eject Pass.") {
                llMessageLinked(LINK_SET, 0, "eject both", NULL_KEY);
            } else if (message == "Eject Right") {
                llMessageLinked(LINK_ALL_OTHERS, 0, "eject right", NULL_KEY);
            } else if (message == "Locator Off") {
                llMessageLinked(LINK_SET, FALSE, "locator", NULL_KEY);
            } else if (message == "Locator On") {
                llMessageLinked(LINK_SET, TRUE, "locator", NULL_KEY);
            } else if (message == "2 Way Glass") {
                llMessageLinked(LINK_SET, FALSE, "opaque glass", NULL_KEY);
            } else if (message == "1 Way Glass") {
                llMessageLinked(LINK_SET, TRUE, "opaque glass", NULL_KEY);
            }
        }
    }
}
