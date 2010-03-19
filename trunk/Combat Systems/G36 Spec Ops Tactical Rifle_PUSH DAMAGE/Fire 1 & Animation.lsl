integer fire = FALSE;
float height_offset;
rotation rot;
vector omega;
vector rez_pos = <2.5, 0.0, 0.02>;
integer mode = 0;
integer animate;
integer safety = TRUE;
string sound1;
string sound2;
string sound3;
string sound4;
string bullet;

key aim_r_rifle = "ea633413-8006-180a-c3ba-96dd1d756720";

default
{
    attach(key id)
    {
        if (id != NULL_KEY) {
            llSetObjectName("100");
            llMessageLinked(LINK_SET, 0, "attach", NULL_KEY);
            animate = FALSE;
            if (!safety) {
                llSleep(0.1);
                llRequestPermissions(id, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
            } else {
                llSleep(0.1);
                llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
            }
            vector size = llGetAgentSize(llGetOwner());
            height_offset = size.z / 2.9;
        } else {
            llSetObjectName("XX G36 spec ops");
            if ((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) == PERMISSION_TRIGGER_ANIMATION) {
                llStopAnimation("hold_r_rifle");
                llStopAnimation("aim_r_rifle");
                llStopAnimation("gun safe");
                llStopAnimation("gun stand");
            }
            llReleaseControls();
        }
    }
    
    run_time_permissions(integer perms)
    {
        if ((perms & PERMISSION_TAKE_CONTROLS) == PERMISSION_TAKE_CONTROLS) {
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
        }
        
        if ((perms & PERMISSION_TRIGGER_ANIMATION) == PERMISSION_TRIGGER_ANIMATION && !animate) {
            llStartAnimation("gun stand");
            llSleep(0.1);
            llStartAnimation("hold_r_rifle");
            if (safety) {
                llStartAnimation("gun safe");
            }
            animate = TRUE;
        }
    }
    
    control(key id, integer level, integer edge)
    {
        if (mode == 0) {
            if ((level & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) {
                if ((integer)llGetObjectName() > 0) {
                    if (!fire) {
                        llMessageLinked(LINK_ALL_OTHERS, 0, "fire", NULL_KEY);
                        llLoopSound(sound1, 0.7);
                        llMessageLinked(LINK_ALL_OTHERS, 0, "d", NULL_KEY);
                        fire = TRUE;
                    }
                    rot = llGetRot();
                    
                    llRezObject(bullet, llGetPos() + ((rez_pos + <0.0, -0.02 + llFrand(0.04), height_offset + llFrand(0.04)>) * rot), (llRot2Fwd(rot) * 100.0) + llGetVel(), <0.00000, 0.70711, 0.00000, 0.70711> * rot, 20);
    
                    llSetObjectName((string)((integer)llGetObjectName() - 4));
                } else {
                    if (fire) {
                        llTriggerSound(sound2, 0.75);
                        
                        llStopSound();
                        llMessageLinked(LINK_ALL_OTHERS, 0, "cease", NULL_KEY);
                        llMessageLinked(LINK_ALL_OTHERS, 0, "s", NULL_KEY);
                        fire = FALSE;
                    }
                    llTriggerSound("e567199b-b8ef-be3a-ab74-c5fd8b2a5584", 0.3); //click
                    
                }
            } else if ((edge & ~level & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) {
                if (fire) {
                    llTriggerSound(sound2, 0.75); // lead out 1d4904bd-a86a-31b8-bfee-70fb04056e8b
                    
                    llStopSound();
                    llMessageLinked(LINK_ALL_OTHERS, 0, "cease", NULL_KEY);
                    
                    fire = FALSE;
                }
                if ((integer)llGetObjectName() <= 0) {
                    llMessageLinked(LINK_SET, 0, "reload", NULL_KEY);
                    llStartAnimation("gun reload");
                    
                    llMessageLinked(LINK_SET, 0, "Eclip", NULL_KEY);
                    
                    
                }
            }
        } else if (mode == 1) {
            if ((edge & level & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) {
                if ((integer)llGetObjectName() > 0) {
                    llMessageLinked(LINK_ALL_OTHERS, 0, "fire", NULL_KEY);
                    //llMessageLinked(LINK_ALL_OTHERS, 0, "eject", NULL_KEY);
                    llTriggerSound(sound3, 0.8);
                    
                    rot = llGetRot();
                    
                    llRezObject(bullet, llGetPos() + ((rez_pos + <0.0, -0.02 + llFrand(0.04), height_offset + llFrand(0.04)>) * rot), (llRot2Fwd(rot) * 100.0) + llGetVel(), <0.00000, 0.70711, 0.00000, 0.70711> * rot, 30);
 
                    llSleep(0.3);
                    llMessageLinked(LINK_ALL_OTHERS, 0, "cease", NULL_KEY);
                    llSetObjectName((string)((integer)llGetObjectName() - 4));
                } else {
                    llTriggerSound("e567199b-b8ef-be3a-ab74-c5fd8b2a5584", 0.3);
                    
                    llSleep(0.3);
                }
            } else if ((edge & ~level & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON && (integer)llGetObjectName() <= 0) {
                llMessageLinked(LINK_SET, 0, "reload", NULL_KEY);
                llMessageLinked(LINK_SET, 0, "Eclip", NULL_KEY);
            }
        } else {
            if ((edge & level & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) {
                if ((integer)llGetObjectName() > 0) {
                    llTriggerSound(sound4, 0.75);
                    llMessageLinked(LINK_ALL_OTHERS, 0, "fire1", NULL_KEY);
                    llMessageLinked(LINK_ALL_OTHERS, 0, "eject", NULL_KEY);
                    rot = llGetRot();
                    
                    llRezObject(bullet, llGetPos() + ((rez_pos + <0.0, -0.02 + llFrand(0.04), height_offset + llFrand(0.04)>) * rot), (llRot2Fwd(rot) * 200.0) + llGetVel(), <0.00000, 0.70711, 0.00000, 0.70711> * rot, 30 * mode);
                        
                    llSetObjectName((string)((integer)llGetObjectName() - 1));
                } else {
                    llTriggerSound("872db423-3353-12ab-c370-f9e18b69e1ec", 0.3);
                }
            } else if ((edge & ~level & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) {
                if ((integer)llGetObjectName() <= 0) {
                    llMessageLinked(LINK_SET, 0, "reload", NULL_KEY);
                    llStartAnimation("gun reload");
                    
                    llMessageLinked(LINK_SET, 0, "Eclip", NULL_KEY);
                    
                    
                }
            }
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
        
        if (str == "son")
        {
            sound1 = "66ba220b-b1be-588f-7cf5-a6174e14af04";
            sound2 = "e1f56239-c6cc-8e0a-fa85-741c014e443f";
            sound3 = "c0d4f30a-ae0d-599f-4cca-b6b6a5a67352";
            sound4 = "811515af-6931-5d71-4602-1ff9881cb9d2";
        }
        
        if (str == "soff")
        {
            sound1 = "2d04c8bc-8631-1c40-7325-80591635b0e0";
            sound2 = "1d4904bd-a86a-31b8-bfee-70fb04056e8b";
            sound3 = "08e4f17f-b5e1-a76f-2416-3c48e05bf22b";
            sound4 = "8ca4d602-c331-88f2-9cbc-60d3c88896b5";
        }
        
        if (str == "mode") {
            mode = num;
        } else if (str == "safety on") {
            if (llListFindList(llGetAnimationList(llGetOwner()), [aim_r_rifle]) < 0) {
                llStartAnimation("gun safe");
            }
            llReleaseControls();
            safety = TRUE;
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        } else if (str == "safety off") {
            llStopAnimation("gun safe");
            safety = FALSE;
            llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
        } else if (str == "reload") {
            llSleep(2.4);
            llSetObjectName("10000");
            llMessageLinked(LINK_SET, 0, "reloadd", "");
        } else if (safety) {
            if (str == "aiming") {
                llStopAnimation("gun safe");
            } else if (str == "not aiming") {
                llStartAnimation("gun safe");
            }
        }
    }
    
    
        }
    

