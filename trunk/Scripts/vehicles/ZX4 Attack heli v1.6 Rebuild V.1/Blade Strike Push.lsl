vector local_pos;
float mass;
integer i;

integer on = FALSE;

default
{
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "start") {
            on = TRUE;
        } else if (str == "stop") {
            on = FALSE;
        }
    }
    
    collision_start(integer n)
    {
        if (!on) return;
        for (i = 0; i < n && i < 3; i += 1) {
            if (llDetectedLinkNumber(i) == llGetLinkNumber()) {
                mass = llGetObjectMass(llDetectedKey(i));
                if ((llDetectedType(i) & AGENT) == AGENT) {
                    local_pos = llDetectedPos(i) - llGetPos();
                    if ((llGetAgentInfo(llDetectedKey(i)) & AGENT_FLYING) == AGENT_FLYING) {
                        llPushObject(llDetectedKey(i), llVecNorm(local_pos) * ((llVecMag(local_pos) * 0.4) + 1.0) * mass * llPow(llVecMag(local_pos) + 0.1, 3.0), ZERO_VECTOR, FALSE);
                    } else {
                        llPushObject(llDetectedKey(i), llVecNorm(local_pos) * ((llVecMag(local_pos) * 0.2) + 1.0) * mass * llPow(llVecMag(local_pos) + 0.1, 3.0), ZERO_VECTOR, FALSE);
                    }
                } else if (llDetectedVel(i) != ZERO_VECTOR && mass > 1.0) {
                    local_pos = llDetectedPos(i) - llGetPos();
                    llPushObject(llDetectedKey(i), llVecNorm(local_pos) * ((llVecMag(local_pos) * 0.15) + 1.5) * mass * llPow(llVecMag(local_pos) + 0.1, 3.0), ZERO_VECTOR, FALSE);
                }
            }
        }
    }
}
