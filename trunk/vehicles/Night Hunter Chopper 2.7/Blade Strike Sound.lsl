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
                    llTriggerSound(llList2Key(["5da4aa20-7c19-7a06-0b9a-867dfa45bc72", "aeaa0bcb-8671-3515-8020-1e9ea14b57dd", "fb379090-42f3-f6b2-70a4-269d379b8e2b"], llFloor(llFrand(2.99999))), 0.2 + llVecMag(local_pos) / 4.0);
                } else if (llDetectedVel(i) != ZERO_VECTOR && mass > 1.0) {
                    local_pos = llDetectedPos(i) - llGetPos();
                    llTriggerSound(llList2Key(["5da4aa20-7c19-7a06-0b9a-867dfa45bc72", "aeaa0bcb-8671-3515-8020-1e9ea14b57dd", "fb379090-42f3-f6b2-70a4-269d379b8e2b"], llFloor(llFrand(2.99999))), 0.2 + llVecMag(local_pos) / 4.0);
                }
            }
        }
    }
}
