//Heavily modified by Rich Cordeaux. Changes made:
// 1. Applies thrust when you jump, whereas before it partially counteracted gravity all the time. You fly up fast and still fall down fast - before, you fell slow too, so you would look like you were jumping on the moon.
// 2. Attempts to synchronize particles and the thrust with the particle-making scripts.
// 3. Better jet particles, and smoke.
// 4. Keeps your falling speed from exceeding -6.0 if you are within 200 meters of the ground (since there's no fast way to determine how high objects below you are, apparently).

integer flying = 0;
float syncTime;
integer resync=0;
integer nearGround = 0;
integer have_permissions = FALSE;   //Indicates whether wearer has yet given permission to take over their controls and animation.

doJetpack() {
    integer agentFlags = llGetAgentInfo(llGetOwner());    
    integer inAirOrFlying = AGENT_FLYING|AGENT_IN_AIR;
    vector vel = llGetVel();
    if (!flying) {
        if (agentFlags&inAirOrFlying) {
            if (vel.z > 0) {
                //llOwnerSay("Vel is "+(string)vel+".");
                if (vel.z<6) {
                    vel.z=6;
                }
                llMessageLinked(LINK_SET, 1, "", NULL_KEY);
                //llOwnerSay("Sleeping for "+(string)syncTime+".");
                llSleep(syncTime);
                llApplyImpulse(vel*2.5, FALSE);
        
                llSleep(2.0);
                llMessageLinked(LINK_SET, 2, "", NULL_KEY);
                
            }
            flying=1;
        }
    } else if ((agentFlags&inAirOrFlying)==0) {
        flying=0;
    }
    if (vel.z<-6.0) {
        if (!nearGround) {
            float groundAt = llGround(<0,0,0>);
            vector pos = llGetPos();
            if (pos.z-groundAt<200.0) {
                nearGround=1;
            }
        }
        if (nearGround) {
            llMessageLinked(LINK_SET, 1, "", NULL_KEY);
            llApplyImpulse(<0,0,- (vel.z + 6.0)>, FALSE);
            llSleep(0.2);
            llMessageLinked(LINK_SET, 2, "", NULL_KEY);
        }
    } else if (vel.z>0) {
        nearGround=0;
    }

}

default
{
     attach(key avatar)
     {
        //vector force = <0,0, llGetMass() * 1.2>;
        //llSetForce(force, TRUE);
        if(avatar==NULL_KEY)
        {
            llSetForce(<0,0,0>,TRUE);
            llSetTimerEvent(0.0);
            if (have_permissions) {
                llReleaseControls();
            }
        } else {
            have_permissions=FALSE;
            integer perms = llGetPermissions()
            | PERMISSION_TAKE_CONTROLS;
            llRequestPermissions(llGetOwner(), perms);
            llSetTimerEvent(.1);
            
            resync=0;
        }
     }
     
    timer() {
        doJetpack();
        if (resync==0) {
            resync = -1;
            llGetAndResetTime();
            llMessageLinked(LINK_SET, 3, "", NULL_KEY);
        } else if (resync>0) {
            resync-=1;
        }
    }
    
    run_time_permissions(integer permissions) {
        if (permissions == PERMISSION_TAKE_CONTROLS) {
            llTakeControls(CONTROL_UP, TRUE, TRUE);
            have_permissions = TRUE;
        }
    }
    
    link_message(integer sender_num, integer num, string msg, key id) {
        if (num==4 && resync==-1) {
            syncTime = llGetAndResetTime()*0.5;
            resync=50;
        }
    }
    control(key id, integer held, integer change) {
        if ((held&CONTROL_UP) && (change&CONTROL_UP)) {
            doJetpack();
        }
    }
}
