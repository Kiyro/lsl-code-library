float LINEAR_TAU = 0.75;             
float TARGET_INCREMENT = 0.5;
float ANGULAR_TAU = 1.5;
float ANGULAR_DAMPING = 0.85;
float THETA_INCREMENT = 10.0;// 0.3 
integer LEVELS = 0;
vector pos;
vector face;
float brake = 0.5;
key gOwnerKey; 
string gOwnerName;
key gToucher;
key Driver;
string Name1 = ""; 
string Name2 = ""; 
string gFLYING = "FALSE";
string sound="3091f7a9-5dac-d948-d58c-5f6d02e85ffe";
key id;
integer nudge = FALSE;
vector POSITION; 
integer auto=FALSE;
integer CHANNEL = 6;

help()
{
    llWhisper(0,"Commands:");
    llWhisper(0,"Left click craft = Start ");
    llWhisper(0,"Left click craft = Stop and release contol");
    llWhisper(0,"/" + (string)CHANNEL + " 1! through" + " /" + (string)CHANNEL + " 9!," + " /" + (string)CHANNEL + " slow or" + " /" + (string)CHANNEL + " warp or" + " /" +(string)CHANNEL + " warp2"  + " or /" +(string)CHANNEL + " warp3 = Set power");
    llWhisper(0,"/" + (string)CHANNEL + " ask! = Craft asks permission for your control. (Only when outside craft)");
    llWhisper(0,"/" + (string)CHANNEL + " menu = Display this list");
    llWhisper(0,"PgUp or PgDn = Gain or lose altitude");
    llWhisper(0,"Arrow keys = Left, right, Forwards and Back");
    llWhisper(0,"Shift + Left or Right arrow = Rotate but maintain view");
    llWhisper(0,"PgUp + PgDn or combination similar = Set cruise on or off");
}

sound_off()
{
    llStopSound();
    llLoopSoundMaster(sound, 0.0);
}

sound_on()
{
    llStopSound();
    llLoopSoundMaster(sound, 1.0);
}

default
{
    state_entry()
    {

        gOwnerKey = llGetOwner();
        gOwnerName = llKey2Name(llGetOwner());
        llSoundPreload(sound);
        sound_off();
        llSetTimerEvent(0.0);
        llMessageLinked(LINK_ALL_CHILDREN, 0, "stop", id);
        llSetStatus(STATUS_PHYSICS, FALSE);
        llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y, TRUE);
        llSleep(0.1);
        llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y, FALSE); 
        llSetStatus(STATUS_PHYSICS, FALSE);
        llMoveToTarget(llGetPos(), 0);
        llRotLookAt(llGetRot(), 0, 0);
        llSetStatus(STATUS_PHYSICS, FALSE);
        LEVELS = CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT | CONTROL_UP | CONTROL_DOWN | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ML_LBUTTON;

        TARGET_INCREMENT = 0.5;
        THETA_INCREMENT = 10.0;
        llSitTarget(<0.5, 0.0, -0.4>, ZERO_ROTATION); 
        llSetCameraEyeOffset(<-8.0, 0.0, 2.25>);
        llSetSitText("Pilot");
        llSetCameraAtOffset(<0, 0.0, 0>);
        llWhisper(0,"Deactivated ... Security conditions set. Type /" + (string)CHANNEL + " menu for a list of options.");
        
        //  this sets a Listen with no callback in this state...
        llListen(CHANNEL, "", gOwnerKey, "");

        state Listening;
    }
    
}

state Listening
{
    //  Here we set up the Listen that is used in the Listening state...
    state_entry()
    {
        llListen(CHANNEL, "", gOwnerKey, "");
    }
    
    // the rest was here before...
    //  This is the click callback
    touch_start(integer total_number)
    {
        if (llDetectedKey(total_number - 1) == gOwnerKey)
        {
            if (gFLYING == "FALSE")
            {
                gFLYING = "TRUE";
                sound_on();
                llSetStatus(STATUS_PHYSICS, TRUE);
                llSetSitText("");
                Driver=llDetectedKey(total_number - 1);
                state StateDriving;
            }
        }
        else
        {
            llWhisper(0,"You must own this craft to pilot it.");
            sound_off();
            llInstantMessage(gOwnerKey,llDetectedName(total_number - 1) + " is touching your craft");
        } 
    }  
    
    //  Here is the Listen callback
    listen(integer CHANNEL, string name, key id, string msg)
    {
        if (llSameGroup(id)==1)
        {
            if (llToLower(msg) == "sound")
            {
                sound_off();
            }
            if (llToLower(msg) == "menu")
            {
                help();        
            }
        }
    }
    
    //  and this is an on-rez callback
    on_rez(integer start_param)
    {
        llResetScript();
    } 
}

state StateDriving
{
    state_entry()
    {
        llWhisper(0, "All systems go !!");
        llRequestPermissions(Driver, PERMISSION_TAKE_CONTROLS);
        llMoveToTarget(llGetPos(), LINEAR_TAU);
        llRotLookAt(llGetRot(), ANGULAR_TAU, 1.0);
        
        //  Added listen here as well....  for same reason...
        llListen(CHANNEL, "", "", "");
    }
    
    touch_start(integer total_number)
    {
        if (llDetectedKey(total_number - 1)==Driver)
        {
            llWhisper(0,"You now have control.");
            gFLYING = "FALSE";
            auto=FALSE;
            llSleep(1.5);
            sound_off();
            llSetSitText("Pilot");
            llSetStatus(STATUS_PHYSICS, FALSE);
            llMessageLinked(LINK_ALL_CHILDREN, 0, "stop", id);
            llSetTimerEvent(0.0);
            llReleaseControls();
            llResetScript();
        }
    }
        
    listen(integer CHANNEL, string name, key id, string msg)
    {
        if (id==Driver)
        {
             if (llToLower(msg) == "sound")
            {
                sound_off();
            }
             if (llToLower(msg) == "sound on")
            {
                sound_on();
            }
            if (llToLower(msg) == "ask!")
            {
                llReleaseControls();
                llRequestPermissions(Driver, PERMISSION_TAKE_CONTROLS);
            }
            if (llToLower(msg) == "menu")
            {
                help();
            }
            if (llToLower(msg) == "warp")
            {
                TARGET_INCREMENT = 10.0; 
                THETA_INCREMENT = 30.0;
                string TIspew = (string)TARGET_INCREMENT;
                TIspew = llGetSubString(TIspew,0,3);
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "warp2")
            {
                TARGET_INCREMENT = 15.0; 
                THETA_INCREMENT = 38.0;
                string TIspew = (string)TARGET_INCREMENT;
                TIspew = llGetSubString(TIspew,0,3);
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "warp3")
            {
                TARGET_INCREMENT = 20.0; 
                THETA_INCREMENT = 46.0;
                string TIspew = (string)TARGET_INCREMENT;
                TIspew = llGetSubString(TIspew,0,3);
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "slow")
            {
                TARGET_INCREMENT = 0.5;
                THETA_INCREMENT = 10.0;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "1!")
            {
                TARGET_INCREMENT = 0.75;
                THETA_INCREMENT = 10.4;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "2!")
            {
                TARGET_INCREMENT = 1.0;
                THETA_INCREMENT = 10.8;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "3!")
            {
                TARGET_INCREMENT = 1.5;
                THETA_INCREMENT = 11.6;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "4!")
            {
                TARGET_INCREMENT = 2.0;
                THETA_INCREMENT = 12.4;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "5!")
            {
                TARGET_INCREMENT = 3.0;
                THETA_INCREMENT = 14.0;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "6!")
            {
                TARGET_INCREMENT = 4.0;
                THETA_INCREMENT = 15.6;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "7!")
            {
                TARGET_INCREMENT = 5.0;
                THETA_INCREMENT = 17.2;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");  
            }
            if (llToLower(msg) == "8!")
            {
                TARGET_INCREMENT = 6.0;
                THETA_INCREMENT = 18.8;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "9!")
            {
                TARGET_INCREMENT = 7.0;
                THETA_INCREMENT = 21.4;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");                                                                         
            }
        }
    }

    run_time_permissions(integer perm)
    {
        if (perm == PERMISSION_TAKE_CONTROLS)
        {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "slow", id);
            llTakeControls(LEVELS, TRUE, FALSE);

        }
        else
        {
            llWhisper(0,"Stopped");
            llSetTimerEvent(0.0);
            gFLYING = "FALSE";
            llSleep(1.5);
            llResetScript();
        }
    }
    control(key driver, integer levels, integer edges)
    {
        pos *= brake;
        face.x *= brake;
        face.z *= brake;
        nudge = FALSE;
        llMessageLinked(LINK_ALL_CHILDREN, 0, "slow", id);
        if (levels & CONTROL_FWD)
        {
            if (pos.x < 0)
            {
                pos.x = 0;
            }
            else
            {
                pos.x += TARGET_INCREMENT;
            }
            nudge = TRUE;
        }
        if (levels & CONTROL_BACK)
        {
            if (pos.x > 0)
            {
                pos.x = 0;
            }
            else
            {
                pos.x -= TARGET_INCREMENT;
            }
            nudge = TRUE;
        }
        if (levels & CONTROL_UP)
        {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "fast", id);
            if(pos.z<0)
            {
                pos.z = 0;
            }
            else
            {
                pos.z += TARGET_INCREMENT;
            }
            face.x = 0;
            nudge = TRUE;
        }
        if (levels & CONTROL_DOWN)
        {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "fast", id);
            if(pos.z > 0)
            {
                pos.z = 0;
            }
            else
            {
                pos.z -= TARGET_INCREMENT;
            }
            face.x = 0;
            nudge = TRUE;
        }
        if ((levels) & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
            if (face.z < 0)
            {
                face.z = 0;
            }
            else
            {
                face.z += THETA_INCREMENT;
            }
            nudge = TRUE;
        }
        if ((levels) & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            if (face.z > 0)
            {
                face.z = 0;
            }
            else
            {
                face.z -= THETA_INCREMENT;
            }
            nudge = TRUE;
        }
        if ((levels & CONTROL_UP) && (levels & CONTROL_DOWN))
        {
            if (auto) 
            { 
                auto=FALSE;
                llWhisper(0,"Cruise off"); 
                llSetTimerEvent(0.0);
            }
            else 
            { 
                auto=TRUE; 
                llWhisper(0,"Cruise on");
                llSetTimerEvent(0.5);
            }
            llSleep(0.5); 
        }
        
        if (nudge)
        {
            vector world_target = pos * llGetRot(); 
            llMoveToTarget(llGetPos() + world_target, LINEAR_TAU);
    
            vector eul = face; 
            eul *= DEG_TO_RAD; 
            rotation quat = llEuler2Rot( eul ); 
            rotation rot = quat * llGetRot();
            llRotLookAt(rot, ANGULAR_TAU, ANGULAR_DAMPING);
        }
    }
    
    timer()
    {
        pos *= brake;
        if (pos.x < 0)
        {
            pos.x=0;
        }
        else
        {
            pos.x += TARGET_INCREMENT;
        }
        vector world_target = pos * llGetRot(); 
        llMoveToTarget(llGetPos() + world_target, LINEAR_TAU);
    }
    
}
