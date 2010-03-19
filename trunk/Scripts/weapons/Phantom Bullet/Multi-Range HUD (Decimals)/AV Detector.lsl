string text;
vector pos;
integer many;
key sub;
integer info;
key owner;
list extra;

integer gHide;

float   distance    = 19.9;


default {
    state_entry() {
        llMessageLinked(LINK_SET,  0, "chat",  NULL_KEY);
        llMessageLinked(LINK_SET, 99, "state", NULL_KEY);
    }
    
    link_message(integer sender, integer num, string msg, key id) {
        if (num ==  0) {
            if (msg == "chat") {
                distance = 19.9;
            } else
            if (msg == "long") {
                distance = 96;
            }
        } else
        if (num == 99) {
            gHide = (integer)msg;
            if (gHide)  state disable;
            else        state active;
        }
    }
}


state active {
    on_rez(integer param) {
        llResetScript();
    }
    
    state_entry() {
        llMessageLinked(LINK_SET, 0, "show", NULL_KEY);
        owner = llGetOwner();
        llSetText("Searching...", <1,0,0>, 1);
        llSensorRepeat("", "", AGENT, distance, TWO_PI, 1.0);
        //llSetTimerEvent(1);
    }

    //timer() {
    //    llSensor("", "", AGENT, distance, PI);
    //}
    
    no_sensor() {
        llSetText("No Agents", <0,1,0>, 1);
    }
    
    //touch_start(integer num) {
    //    llOwnerSay("LocalPosition: " + (string)llGetLocalPos());
    //}
    touch_start(integer num) {
        state disable;
    }
    
    link_message(integer sender, integer num, string msg, key id) {
        if (num ==  0) {
            if (msg == "chat") {
                distance = 19.9;
                llSensorRemove();
                llSensorRepeat("", "", AGENT, distance, TWO_PI, 1.0);
            } else
            if (msg == "long") {
                distance = 96;
                llSensorRemove();
                llSensorRepeat("", "", AGENT, distance, TWO_PI, 1.0);
            }
        }
    }
    
    sensor(integer num) {
        text = "";
        many = 1;
        pos = llGetPos();
        integer x=0;
        for(x;x<num;x++) {
            extra = [];
            sub = llDetectedKey(x);
            if(sub != owner) {
                info = llGetAgentInfo(sub);
                if(info & AGENT_TYPING) extra += ["T"];
                if(info & AGENT_AWAY) extra += ["A"];
                if(info & AGENT_BUSY) extra += ["B"];
                if(info & AGENT_FLYING) extra += ["F"];
                if(info & AGENT_MOUSELOOK) extra += ["M"];
                if(info & AGENT_ON_OBJECT) {
                    extra += ["SO"];
                } else if(info & AGENT_SITTING) {
                    extra += ["SG"];
                }
                if(info & AGENT_SCRIPTED) {
                //    extra += ["SAT"];
                } else if(info & AGENT_ATTACHMENTS) {
                    extra += ["AT"];
                }
                if(info & AGENT_WALKING) extra += ["W"];
                if(info & AGENT_CROUCHING) extra += ["C"];
                if(info & AGENT_ALWAYS_RUN) extra += ["R"];
                
                //text += (string)many + ") " + llDetectedName(x) + " (" + llDumpList2String(extra,",") +
                //") - " + (string)(llRound(llVecDist(pos, llDetectedPos(x)))) + "m\n";
                //text += (string)many + ") " + llDetectedName(x) + " (" + llDumpList2String(extra,",") +
                //") - " + (string)(llVecDist(pos, llDetectedPos(x))) + "m\n";
                //text += llDetectedName(x) + " (" + llDumpList2String(extra,",") +
                //") - " + (string)(llRound(llVecDist(pos, llDetectedPos(x)))) + "m\n";
                text += llDetectedName(x) + " (" + llDumpList2String(extra,",") +
                ") - " + (string)(llVecDist(pos, llDetectedPos(x))) + "m\n";
                
                many++;
            }
        }
        
        if(many == 1) text = "No Agents";
        llSetText(text, <0,0,1>, 1);
    }
}

state disable {
    state_entry() {
        llSetText("", <0,0,0>, 0);
        llMessageLinked(LINK_SET, 0, "hide", NULL_KEY);
    }
    
    touch_start(integer num) {
        state active;
    }
    
    link_message(integer sender, integer num, string msg, key id) {
        if (num ==  0) {
            if (msg == "chat") {
                distance = 20.1;
            } else
            if (msg == "long") {
                distance = 96;
            }
        }
    }
}
