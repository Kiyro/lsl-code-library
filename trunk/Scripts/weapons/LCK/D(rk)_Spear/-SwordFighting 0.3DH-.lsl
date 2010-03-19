integer SWORD = 1;
integer PUNCH12 = 2;
integer PUNCHL = 3;
integer KICK = 4;
integer FLIP = 5;
integer BLADE_BEAM = 10;
integer BASE_POWER = 20;

integer BLADE_DAMAGE = 100;

integer strike_type;
rotation g_beam_rot;

fire_blade_beam()
{
    llTriggerSound("96aeb4f2-3d59-dd37-cfa9-763614695b61", 9.9);
    llTriggerSound("96aeb4f2-3d59-dd37-cfa9-763614695b61", 9.9);
    rotation rot = llGetRot();
    vector fwd = llRot2Fwd(rot);
    vector pos = llGetPos();
    pos = pos + fwd*2;
    pos.z += 0.75;   
//    fwd *= -1;               //  Correct to eye point
//    fwd = fwd * BASE_POWER;
    llSleep(.8);//wait a bit for the anim to catch up
    llRezObject("-------------", pos, fwd, g_beam_rot * rot, 1);
}



default
{
    
    state_entry()
    {
        llPreloadSound("3273d352-9b51-7939-5115-d9dbc338347d");
        llSetStatus(STATUS_BLOCK_GRAB, TRUE);
        g_beam_rot = llEuler2Rot(<90,0,0> * DEG_TO_RAD);
    }
    
    run_time_permissions(integer perm)
    {
        if (perm)
        {
            llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_UP | CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT | CONTROL_DOWN, TRUE, TRUE);
        }
    }
    

    attach(key on)
    {
        if (on != NULL_KEY)
        {
            integer perm = llGetPermissions();
            
            if (perm != (PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION))
            {
                llRequestPermissions(on, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
            }
            else
            {
                llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_UP | CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT | CONTROL_DOWN, TRUE, TRUE);
            }
            
        }
        else
        {
            integer perm = llGetPermissions();
            if (perm == (PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION) )
            {
                llWhisper(0, "/me returns to the shad0ws~");//~
                //llTakeControls(FALSE, TRUE, TRUE);
                //llStopAnimation(llGetAnimation(llGetOwner()));
                //llReleaseControls();
            }
        }
    }
    
    timer()
    {
        if (  (strike_type == FLIP)
            || (strike_type == SWORD))
        {
            llSensor("", "", ACTIVE | AGENT, 8.0, PI_BY_TWO /2.0);
        }
        else if ( strike_type == BLADE_BEAM )
        {
            fire_blade_beam();  // don't care about target
        }
        else      
        {
            llSensor("", "", ACTIVE | AGENT, 10.0, PI_BY_TWO/2.0);
        }
        llSetTimerEvent(0.0);
    }
        
    control(key owner, integer level, integer edge)
    {
        if (level & (CONTROL_ML_LBUTTON | CONTROL_LBUTTON))
        {
//            if (edge & CONTROL_DOWN)
            if ( edge & level & CONTROL_DOWN )
            {
                llStartAnimation("dbl edged special attack 1");
                fire_blade_beam();
                strike_type = BLADE_BEAM;
            }
            else 
            {
            if (edge & CONTROL_UP)
            {
                llApplyImpulse(<0,1,0>,FALSE);
                llStartAnimation("FwdFlip");
                llSleep(1.0);
                llStartAnimation("Combo..2");
                strike_type = FLIP;
            }
            if (edge & CONTROL_FWD)
            {
                llStartAnimation("basic_strong3");
                strike_type = SWORD;
            }
            if (edge & (CONTROL_LEFT | CONTROL_ROT_LEFT))
            {
                llStartAnimation("LeftSwing..1");
                llSleep(1.0);
                llStartAnimation("dbl edged attack 1");
                strike_type = PUNCHL;
            }
            if (edge & (CONTROL_RIGHT | CONTROL_ROT_RIGHT))
            {
                llStartAnimation("Combo..1");
                llSleep(1.5);
                llStartAnimation("dbl edged attack 2");
                llSleep(0.5);
                strike_type = KICK;
            }
            if (edge & CONTROL_BACK)
            {
                llStartAnimation("dbl edged rear");
                llSleep(1.0);
                llStartAnimation("BackSwing");
                llSleep(0.5);
                strike_type = PUNCH12;
            }
            }
            if (edge & CONTROL_DOWN)
           {
                llMoveToTarget(llGetPos(), 0.25);
                llSleep(1.0);
                llStopMoveToTarget();
            }

        }
    }
    
    sensor(integer tnum)
    {   
        vector dir = llDetectedPos(0) - llGetPos();
        dir.z = 0.0;
        dir = llVecNorm(dir);
        rotation rot = llGetRot();
        if (strike_type == SWORD)
        {
            llTriggerSound("9850f8df-c86a-80d9-eca7-d6f12aae6f9e", 0.5);
            dir += llRot2Up(rot);
            dir *= 10000.0;
            llRezObject( "-Damage", llDetectedPos(0), <0,0,0>, <0,0,0,0>, BLADE_DAMAGE );            
            //llPushObject(llDetectedKey(0), dir, ZERO_VECTOR, FALSE);
        }
        else if (strike_type == PUNCH12)
        {
            llTriggerSound("9850f8df-c86a-80d9-eca7-d6f12aae6f9e", 0.2);
            dir += dir;
            dir *= 100.0;
llRezObject( "-Damage", llDetectedPos(0), <0,0,0>, <0,0,0,0>, BLADE_DAMAGE );         
        }
        else if (strike_type == PUNCHL)
        {
            llTriggerSound("9850f8df-c86a-80d9-eca7-d6f12aae6f9e", 0.2);
            dir -= llRot2Left(rot);
            dir *= 100.0;
llRezObject( "-Damage", llDetectedPos(0), <0,0,0>, <0,0,0,0>, BLADE_DAMAGE );         
        }
        else if (strike_type == KICK)
        {
            llTriggerSound("9850f8df-c86a-80d9-eca7-d6f12aae6f9e", 0.2);
            dir += dir;
            dir *= 100.0;
llRezObject( "-Damage", llDetectedPos(0), <0,0,0>, <0,0,0,0>, BLADE_DAMAGE );         
        }
        else if (strike_type == FLIP)
        {
            llTriggerSound("9850f8df-c86a-80d9-eca7-d6f12aae6f9e", 0.2);
llRezObject( "-Damage", llDetectedPos(0), <0,0,0>, <0,0,0,0>, BLADE_DAMAGE );         
        }
        strike_type = 0;
    }
}
 