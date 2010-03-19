integer saberOn = FALSE;
vector saberColor;

string style;
float version = 1.5;

integer dmg;
integer dmgMult;
integer atk = FALSE;

float pushPower;
string mode;

integer damagestatus = FALSE;

integer BLUR = TRUE;

default
{
    on_rez(integer params)
    {
        llStopSound();
        integer atk = FALSE;
        dmg = 0;
        saberOn = FALSE;
        damagestatus = FALSE;
    }
    state_entry()
    {
        style = "basic";
        mode = "normal";
        llListen(69,"","","");
        llSetLinkAlpha(ALL_SIDES, 0, ALL_SIDES);        
    }

    attach(key attached)
    {
        if(attached == llGetOwner())
        {
            llListen(69,"","","");
            llSetStatus(STATUS_BLOCK_GRAB,TRUE);
            llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
            llSetLinkAlpha(ALL_SIDES, 0, ALL_SIDES);
        }
    }
    run_time_permissions(integer perms)
    {
        if(perms & PERMISSION_TAKE_CONTROLS)
        {
            llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_UP | CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT | CONTROL_DOWN, TRUE, TRUE);
        }
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
        if(llGetSubString(msg,0,4) == "COLOR")
        {
            saberColor = (vector)llGetSubString(msg,6,-1);
        }
    }
    listen( integer channel, string name, key id, string msg )
    {
        if(llGetOwnerKey(id) == llGetOwner())
        {
            if(llToLower(msg) == "both on")
            {
                llSetLinkAlpha(ALL_SIDES, 1, ALL_SIDES);
                llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);                
                llMessageLinked(LINK_SET,0,"HIDE CAL",NULL_KEY);
                llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);            
                llMessageLinked(LINK_SET,0,"ON",NULL_KEY);
                saberOn = TRUE;
                llTriggerSound("ignite",1);
                llLoopSound("hum",1);
                llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
                llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_UP | CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT | CONTROL_DOWN, TRUE, TRUE);
            }
            else if(llToLower(msg) == "off" || llToLower(msg) == "on")
            {
                if(saberOn == TRUE)
                {
                llSetLinkAlpha(ALL_SIDES, 0, ALL_SIDES);                
                llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);                                  saberOn = FALSE;
                llTriggerSound("powerdown",1);
                llStopSound();
                llReleaseControls();
                }
            }
            else if(llToLower(msg) == "show cal")
            {
                llMessageLinked(LINK_SET,0,"SHOW CAL",NULL_KEY);
            }            
            else if(llToLower(llGetSubString(msg,0,6)) == "color2 ")
            {
                saberColor = (vector)llGetSubString(msg,7,-1) / 255;
                llMessageLinked(LINK_SET,0,"COLOR " + (string)saberColor,NULL_KEY);
            }            
            else if(llToLower(msg) == "low")
            {
                llOwnerSay("Practice Mode.");
                dmgMult = 0;
                pushPower = 0;
            }
            else if(llToLower(msg) == "normal")
            {
                llOwnerSay("Normal Mode");
                dmgMult = 1;
                pushPower = 1000;
            }
            else if(llToLower(msg) == "high")
            {
                llOwnerSay("High Combat Mode");
                dmgMult = 2;
                pushPower = 7500000;
            }
            else if(llToLower(msg) == "1hitkill")
            {
                llOwnerSay("One Hit Kill Combat Mode");
                dmgMult = 100;
                pushPower = 15000000;
            }
            else if(llToLower(msg) == "rp")
            {
                damagestatus = 2;
                llOwnerSay("RP System Mode (RCS/DCS/SWCS)");
            }
            else if(llToLower(msg) == "dmg")
            {
                llOwnerSay("Damage Mode (SL Damage)");
                damagestatus = 1;
            }
            else if(llToLower(msg) == "push")
            {
                llOwnerSay("Push Mode");
                damagestatus = 0;
            }
            else if(llToLower(msg) == "blur")
            {
                if(BLUR == TRUE)
                {
                    BLUR = FALSE;
                    llOwnerSay("Motion blur off.");
                }
                else if(BLUR == FALSE)
                {
                    BLUR = TRUE;
                    llOwnerSay("Motion blur on.");
                }
            }
        }
    }
    control(key id,integer held,integer change)
    {
        if(held & CONTROL_LBUTTON || held & CONTROL_ML_LBUTTON)
        {
            if((change & held & CONTROL_ROT_LEFT) | (change & ~held & CONTROL_LEFT))
            {
                
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"Y_BLUR",NULL_KEY);
                }
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 8 * dmgMult;
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"ON",NULL_KEY); 
                }
            }
            if((change & held & CONTROL_ROT_RIGHT) | (change & ~held & CONTROL_RIGHT))
            {
                
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"Y_BLUR",NULL_KEY);
                }
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 8 * dmgMult;
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"ON",NULL_KEY); 
                }
            }
            if(change & held & CONTROL_FWD)
            {
                
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"X_BLUR",NULL_KEY);
                }
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 8 * dmgMult;
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"ON",NULL_KEY); 
                }
            }
            if(change & held & CONTROL_BACK)
            {
                
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"Y_BLUR",NULL_KEY);
                }
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 8 * dmgMult;
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"ON",NULL_KEY); 
                }
            }
            if((change & ~held & CONTROL_BACK) && (change & ~held & CONTROL_FWD))
            {
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 8 * dmgMult;
            }
            if((change & ~held & CONTROL_FWD) && ((change & ~held & CONTROL_LEFT) || (change & ~held & CONTROL_ROT_LEFT)))
            {
                
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"Y_BLUR",NULL_KEY);
                }
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 10 * dmgMult;
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"ON",NULL_KEY); 
                }
            }
            if((change & ~held & CONTROL_FWD) && ((change & ~held & CONTROL_RIGHT) || (change & ~held & CONTROL_ROT_RIGHT)))
            {
                
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"X_BLUR",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"Y_BLUR",NULL_KEY);
                }
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 10 * dmgMult;
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"ON",NULL_KEY); 
                }
            }
            if(((change & ~held & CONTROL_LEFT) || (change & ~held & CONTROL_ROT_LEFT)) && ((change & ~held & CONTROL_RIGHT) || (change & ~held & CONTROL_ROT_RIGHT)))
            {
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 12 * dmgMult;
            }
            llSetDamage(dmg);
        }
        else if(~held & CONTROL_LBUTTON || ~held & CONTROL_ML_LBUTTON)
        {
            llSetDamage(0);
        }

    }
    timer()
    {
        llSensor("","",AGENT | ACTIVE,4.0,PI_BY_TWO);
        atk = FALSE;
    }
    sensor(integer num)
    {
        integer i;
        if(saberOn == TRUE)
        {
            if(num != 0)
            {
                float distance = llVecDist(llGetPos(),llDetectedPos(0));
                float mass = llGetObjectMass(llDetectedKey(0)); 
                if(distance < 1.0)
                {
                    distance = 1.0;
                }
                
                float mod = llPow(distance,3.0) + mass;
                key target = llDetectedKey(0);
                llTriggerSound("hit",2);
                if (damagestatus == 2)
                {
                }
                else if(damagestatus == 1)
                {
                    llRezObject("saber damager",llDetectedPos(0),<0,0,0>,ZERO_ROTATION,dmg);
                }
                else if(damagestatus == 0)
                {
                    llPushObject(target,<-pushPower,0,pushPower> * mod ,ZERO_VECTOR,TRUE);
                }
                llSetTimerEvent(0);
            }
        }
        else
        {
        }
    }
    no_sensor()
    {
        llSetTimerEvent(0);
    }

}