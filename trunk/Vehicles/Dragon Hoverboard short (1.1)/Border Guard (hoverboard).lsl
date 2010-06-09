integer stuck = 0;

default {

    timer() {
        if (!llGetStatus(STATUS_PHYSICS)) {
            if (stuck < 1) {
                llSetStatus(STATUS_PHYSICS, TRUE);
                stuck++;
            }
            else {
                llSetPos(llGetPos() + <0.0, 0.0, 0.5>);
                llSetStatus(STATUS_PHYSICS, TRUE);
            }
        }
        else {
            stuck = 0;
        }
    }

    link_message(integer sender, integer num, string str, key id) {
        if (str == "idle") {
            llResetScript();
        }
        else if (str == "get_on") {
            llSetTimerEvent(1.0);
        }
    }
}
