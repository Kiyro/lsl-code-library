// CATEGORY:Vehicle
// CREATOR:Ferd Frederiex
// DESCRIPTION:Sometimes when crossing sim borders, physics will spontaneously be removed from a vehicle. This script re-enables physics if that happens
// ARCHIVED BY:Ferd Frederix

1 // Remove That 1 to make the Script Running
// Sometimes when crossing sim borders, physics will spontaneously be removed from a vehicle.
// This script re-enables physics if that happens.

integer active = TRUE;

default {
    state_entry() {
        //llListen(0, "", NULL_KEY, "brake");
        //llListen(0, "", NULL_KEY, "b");
        llSetTimerEvent(1.0);
    }

    timer() {
        if (active) {
            if (llAvatarOnSitTarget() == llGetOwner()) {
                if (!llGetStatus(STATUS_PHYSICS)) {
                    llSleep(1.0);
                    llSetStatus(STATUS_PHYSICS, TRUE);
                }
            } else {
                active = FALSE;
                llSetTimerEvent(0.0);
            }
        } else {
            llSetTimerEvent(0.0);
            llSetStatus(STATUS_PHYSICS, FALSE);
        }
    }
    
    listen(integer channel, string name, key id, string message) {
        string myMessage = llToLower(message);
        if (id == llGetOwner()) {
            if (myMessage == "b" || myMessage == "brake") {
                if (active) {
                    active = FALSE;
                    llWhisper(0, "Emergency brake engaged! Say 'b' in chat to resume flight.");
                } else {
                    active = TRUE;
                    llSetTimerEvent(1.0);
                    llWhisper(0, "Emergency brake disengaged.");
                }
            }
        }
    }
    
    link_message(integer sender, integer num, string message, key id) {
        if (message == "throttle" || message == "engines on") {
            if (message == "throttle" && active == FALSE) {
                llWhisper(0, "Emergency brake disengaged.");
            }
            active = TRUE;
            llSetTimerEvent(1.0);
        }
    }
}
// END //
