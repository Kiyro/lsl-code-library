rotation sit_rot;
key pilot;
integer power;
integer listenindex;

default
{
    state_entry()
    {
        llSetStatus(STATUS_PHYSICS, FALSE);
        llListenRemove(listenindex);
        llSetTimerEvent(0.0);
        llStopSound();
        llPreloadSound("welcome_pilot.wav");
        llPreloadSound("jet_start");
        llPreloadSound("jet_loop");
        llPreloadSound("powering_down.wav");
        llPreloadSound("jet_loop_fade");
        llSetSitText("Board");
        llSetCameraEyeOffset(<-12.0, 0.0, 2.5>);
        llSetCameraAtOffset(<0.0, 0.0, 1.75>);
        pilot = NULL_KEY;
        power = FALSE;
        sit_rot = llRotBetween(<1.0, 0.0, 0.0>, llVecNorm(<1.3, 0.0, 1.0>));
        llSitTarget(<-0.1, 0.0, -0.6>, sit_rot);
        llMessageLinked(LINK_SET, 0, "pilot", NULL_KEY);
        llMessageLinked(LINK_SET, 0, "display off", NULL_KEY);
    }
    
    on_rez(integer sparam)
    {
        llResetScript();
    }
    
    changed(integer change)
    {
        key sitting = llAvatarOnSitTarget();
        if (change == CHANGED_LINK) {
            if (sitting != NULL_KEY) {
                if (sitting != llGetOwner()) {
                    llMessageLinked(LINK_SET, 0, "eject", sitting);
                    llWhisper(0, "Unauthorized Access");
                } else {
                    if (pilot == NULL_KEY) {
                        pilot = sitting;
                        llWhisper(0, "Pilot " + llKey2Name(sitting));
                        llTriggerSound("welcome_pilot.wav", 1.0);
                        llMessageLinked(LINK_SET, 0, "display on", NULL_KEY);
                        llListenRemove(listenindex);
                        listenindex = llListen(0, "", sitting, "");
                        
                    }
                }
            } else if (pilot != NULL_KEY) {
                llSetStatus(STATUS_PHYSICS, FALSE);
                pilot = NULL_KEY;
                llListenRemove(listenindex);
                llMessageLinked(LINK_SET, 0, "unsit", NULL_KEY);
                llMessageLinked(LINK_SET, 0, "display off", NULL_KEY);
                if (power) {
                    power = FALSE;
                    llWhisper(0, "Powering Down");
                    llTriggerSound("powering_down.wav", 1.0);
                    llSetTimerEvent(0.0);
                    llTriggerSound("jet_loop_fade", 0.75);
                    llStopSound();
                    llMessageLinked(LINK_SET, 0, "unseated", "");
                    llMessageLinked(LINK_SET, 0, "pilot", NULL_KEY);
                    
                }
            }
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        message = llToLower(message);
        if ((message == "start" || message == "power up") && !power) {
            power = TRUE;
            llTriggerSound("jet_start", 1.0);
            llSetTimerEvent(4.0);
            llMessageLinked(LINK_SET, 0, "pilot", pilot);
            llMessageLinked(LINK_SET, 0, "seated", "");
        } else if ((message == "stop" || message == "power down") && power) {
            power = FALSE;
            llWhisper(0, "Powering Down");
            llTriggerSound("powering_down.wav", 1.0);
            llSetTimerEvent(0.0);
            llTriggerSound("jet_loop_fade", 0.75);
            llStopSound();
            llMessageLinked(LINK_SET, 0, "pilot", NULL_KEY);
             llMessageLinked(LINK_SET, 0, "unseated", "");
             llSetPrimitiveParams([PRIM_PHANTOM, TRUE]);
             llSleep(1);
             llSetPrimitiveParams([PRIM_PHANTOM, FALSE]);
        }
    }
    
    timer()
    {
        llLoopSound("jet_loop", 0.75);
        llSetTimerEvent(0.0);
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "cloak") {
            llSetTimerEvent(0.0);
            llLoopSound("jet_loop", 0.1);
            llAdjustSoundVolume(0.1);
        } else if (str == "decloak") {
            llAdjustSoundVolume(0.75);
        }
    }
}
