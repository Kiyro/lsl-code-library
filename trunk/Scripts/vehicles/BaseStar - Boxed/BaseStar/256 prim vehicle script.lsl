float LINEAR_TAU = 0.75;             
float TARGET_INCREMENT = 90;
float ANGULAR_TAU = 10;
float ANGULAR_DAMPING = 0;
float THETA_INCREMENT = 10;// 0.3 
integer LEVELS = 0;
vector pos;
vector face;
float brake = 0.5;
key gOwnerKey; 
string gOwnerName;
key gToucher;
key Driver;

string gFLYING = "FALSE";
key id;
integer nudge = FALSE;
vector POSITION; 
integer auto=FALSE;



default
{  on_rez(integer start_param)
    {
        llResetScript();
    } 
    state_entry()
    {

        llSetTimerEvent(0.0);
        llMessageLinked(LINK_ALL_CHILDREN, 0, "stop", id);
        llSetPos(llGetPos());
        llRotLookAt(llGetRot(), 0, 0);
        LEVELS = CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT | CONTROL_UP | CONTROL_DOWN | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ML_LBUTTON;

        TARGET_INCREMENT = 0.5;
        llSitTarget(<0.3, 0.0, 0.50>, ZERO_ROTATION);  // good for default cube.
        llSetCameraEyeOffset(<-10.0, 1.0, 3.0>);
        llSetSitText("Drive");
        llSetTouchText("Remote");
        llSetCameraAtOffset(<0, 1.0, 0>);
        }
         touch_start(integer total_number)
    {
           if (gFLYING == "FALSE")
            {
                gFLYING = "TRUE";
               // llSetStatus(STATUS_PHYSICS, TRUE);
                Driver=llDetectedKey(total_number - 1);
                state StateDriving;
            }
    
}


}state StateDriving
{
    state_entry()
    {
        llRequestPermissions(Driver, PERMISSION_TAKE_CONTROLS);
        llSetPos(llGetPos());
        llSetRot(llGetRot());
        
     
    }
    
    touch_start(integer total_number)
    {
        if (llDetectedKey(total_number - 1)==Driver)
        {
            gFLYING = "FALSE";
            auto=FALSE;
            llSleep(1.5);
            llMessageLinked(LINK_ALL_CHILDREN, 0, "stop", id);
            llSetTimerEvent(0.0);
            llReleaseControls();
            llResetScript();
        }
    }
        
   

    run_time_permissions(integer perm)
    {
        if (perm == PERMISSION_TAKE_CONTROLS)
        {
            llTakeControls(LEVELS, TRUE, FALSE);

        }
        else
        {
           
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
        
        if (levels & CONTROL_FWD)
        {
            if (pos.x < 0) { pos.x=0; }
            else { pos.x += TARGET_INCREMENT; }
            nudge = TRUE;
        }
        if (levels & CONTROL_BACK)
        {
            if (pos.x > 0) { pos.x=0; }
            else { pos.x -= TARGET_INCREMENT; }
            nudge = TRUE;
        }
        if (levels & CONTROL_UP)
        {
            
            if(pos.z<0) { pos.z=0; }
            else { pos.z += TARGET_INCREMENT; }
            face.x=0;
            nudge = TRUE;
        }
        if (levels & CONTROL_DOWN)
        {
            
            if(pos.z>0) { pos.z=0; }
            else { pos.z -= TARGET_INCREMENT; }
            face.x=0;
            nudge = TRUE;
        }
        if ((levels) & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
            if (face.z < 0) { face.z=0; }
            else { face.z += THETA_INCREMENT; }
            nudge = TRUE;
        }
        if ((levels) & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            if (face.z > 0) { face.z=0; }
            else { face.z -= THETA_INCREMENT; }
            nudge = TRUE;
        }
               
        if (nudge)
        {
            vector world_target = pos * llGetRot(); 
            llSetPos(llGetPos() + world_target);
    
            vector eul = face; 
            eul *= DEG_TO_RAD; 
            rotation quat = llEuler2Rot( eul ); 
            rotation rot = quat * llGetRot();
            llSetRot(rot);
        }
    }
    
    timer()
    {
        pos *= brake;
        if (pos.x < 0) { pos.x=0; }
        else { pos.x += TARGET_INCREMENT; }
        vector world_target = pos * llGetRot(); 
        llSetPos(llGetPos() + world_target);
    }
    
}

