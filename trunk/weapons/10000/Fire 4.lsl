integer fire = FALSE;
float height_offset;
rotation rot;
vector omega;
vector rez_pos = <2.5, 0.0, -0.02>;
integer mode = 0;
integer safety = TRUE;
string bullet;

default
{
    attach(key id)
    {
        if (id != NULL_KEY) {
            if (!safety) {
                llRequestPermissions(id, PERMISSION_TAKE_CONTROLS);
            }
            vector size = llGetAgentSize(llGetOwner());
            height_offset = size.z / 2.9;
        } else {
            llReleaseControls();
        }
    }
    
    run_time_permissions(integer perms)
    {
        if ((perms & PERMISSION_TAKE_CONTROLS) == PERMISSION_TAKE_CONTROLS) {
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
        }
    }
    
    control(key id, integer level, integer edge)
    {
        if ((integer)llGetObjectName() > 0 && llGetObjectDesc() == "fire") {
            if (mode == 0) {
                if ((level & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) {
                    if (!fire) {
                        llSleep(0.075);
                    }
                    //llTriggerSound("8ca4d602-c331-88f2-9cbc-60d3c88896b5", 0.6);
                    rot = llGetRot();
                    
                    llRezObject(bullet, llGetPos() + ((rez_pos + <0.0, -0.02 + llFrand(0.04), height_offset + llFrand(0.04)>) * rot), (llRot2Fwd(rot) * 100.0) + llGetVel(), <0.00000, 0.70711, 0.00000, 0.70711> * rot, 20);
                } else if ((edge & ~level & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) {
                    fire = FALSE;
                }
            } else if (mode == 1) {
                if ((edge & level & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) {
                    llSleep(0.3);
                    //llTriggerSound("8ca4d602-c331-88f2-9cbc-60d3c88896b5", 0.6);
                    rot = llGetRot();
                    
                    llRezObject(bullet, llGetPos() + ((rez_pos + <0.0, -0.02 + llFrand(0.04), height_offset + llFrand(0.04)>) * rot), (llRot2Fwd(rot) * 100.0) + llGetVel(), <0.00000, 0.70711, 0.00000, 0.70711> * rot, 30);
                    llSleep(0.1);
                }
            }
        } else {
            fire = FALSE;
        }
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "pb")
        {
            bullet = "Push Bullet";
        }
        
        if (str == "db")
        {
            bullet = "Damage Bullet";
        }
        
        if (str == "mode") {
            mode = num;
        } else if (str == "safety on") {
            llReleaseControls();
            safety = TRUE;
        } else if (str == "safety off") {
            safety = FALSE;
            llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
        }
    }
}
