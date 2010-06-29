string version = "v1.2";

integer silentlisten;

vector pos;
float ground;
integer up;
integer fwd;
integer back;
integer online;

phase_on()
{
    llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
    vector temp = llGetScale();
    llSleep(0.1);
    vector size = llGetAgentSize(llGetOwner());
    llMoveToTarget(llGetPos(), 0.1);
    llSetScale(<0.2, 0.2, 0.2>);
    llSetScale(<0.1, 0.1, 0.1>);
    online = TRUE;
    if (!(llGetAgentInfo(llGetOwner()) & AGENT_FLYING)) {
        llSetForce(<0.0, 0.0, 9.8> * llGetMass(), FALSE);
    }
    llStopMoveToTarget();
    llMessageLinked(LINK_SET, 0, "IM", "Online");
    llSetObjectDesc("Online");
}

phase_off()
{
    llSetScale(<0.1, 0.1, 0.1>);
    llReleaseControls();
    llSetObjectDesc("Offline");
    llResetScript();
}

default
{
    state_entry()
    {
        online = FALSE;
        up = FALSE;
        fwd = FALSE;
        back = FALSE;
        pos = ZERO_VECTOR;
        llSetHoverHeight(0.0, FALSE, 0.0);
        llSetAlpha(0.0, ALL_SIDES);
        llListenRemove(silentlisten);
        silentlisten = llListen(1, "", llGetOwner(), "");
        if (llGetObjectDesc() == "Online") {
            phase_on();
        } else {
            llMessageLinked(LINK_SET, 0, "IM", "Offline");
        }
    }
    
    attach(key id)
    {
        if (id != NULL_KEY) {
            up = FALSE;
            fwd = FALSE;
            back = FALSE;
            llMessageLinked(LINK_SET, 0, "IM", "Say help on channel 1 (/1 help), for a list of commands.");
            llResetScript();
        } else {
            llListenRemove(silentlisten);
            llSetObjectDesc(version);
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        message = llToLower(message);
        if (message == "phase on") {
            phase_on();
        } else if (message == "phase off") {
            phase_off();
        } else if (message == "phase") {
            if (online) {
                phase_off();
            } else {
                phase_on();
            }
        } else if (message == "help") {
            llMessageLinked(LINK_SET, 0, "IM", "\nphase on, turns the phase shield on.  \nphase off, turns the phase shield off.  \nphase, switches either on or off depending on whether it was already on or off (toggle).");
        }
    }
    
    run_time_permissions(integer perms)
    {
        if ((perms & PERMISSION_TAKE_CONTROLS)) {
            llSetTimerEvent(0.2);
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_UP, TRUE, TRUE);
        }
    }
    
    control(key id, integer level, integer edge)
    {
        pos = llGetPos();
        if ((edge & level & CONTROL_UP)) {
            up = TRUE;
            llSetHoverHeight(0.0, FALSE, 0.0);
        } else if ((edge & ~level & CONTROL_UP)) {
            up = FALSE;
        }
        
        if ((edge & level & CONTROL_FWD)) {
            fwd = TRUE;
        } else if ((edge & ~level & CONTROL_FWD)) {
            fwd = FALSE;
        }
        
        if ((edge & level & CONTROL_BACK)) {
            back = TRUE;
        } else if ((edge & ~level & CONTROL_BACK)) {
            back = FALSE;
        }
    }
    
    timer()
    {
        pos = llGetPos();
        ground = llGround(ZERO_VECTOR);
        if (pos.z - ground < 1.25 && !up) {
            llSetHoverHeight(1.25, FALSE, 0.1);
        }
        if (!(llGetAgentInfo(llGetOwner()) & AGENT_FLYING)) {
            llSetForce(<0.0, 0.0, 9.8> * llGetMass(), FALSE);
            if (!fwd && !back) {
                llApplyImpulse(llGetVel() * -llGetMass(), FALSE);
            } else if (llVecMag(llGetVel()) > 3.0) {
                llApplyImpulse(((llVecNorm(llGetVel()) * 3.0) + -llGetVel()) * llGetMass(), FALSE);
            }
        } else {
            llSetForce(ZERO_VECTOR, FALSE);
        }
        llSetScale(<0.2, 0.2, 0.2>);
        llSetScale(<0.1, 0.1, 0.1>);
    }
}
