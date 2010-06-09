1//Remove This Number To Make The Script Work!

/////////////////////////
//Remote Control Script//
//Created By JoJo Hesse//
/////////////////////////

//It Should ALWAYS Be Given Away For Free!
//Please Do Not Sell! And Leave It Full Perms When Giving It Away

/////////////
//To Use It//
/////////////
//1.) Just Put It In Your Vehicle And Touch It
//2.) Click "Yes"
//3.) When You Finish Playing With It, Touch It Again And Click "No"






float speed=15;         //Driving Speed.
float TurnSpeed=140;    //Turning Speed

default
{   
    on_rez(integer start_param)
    {
        llSetPos(llGetPos() + <0,0,1>);             //Move Up 1m So The Car Doesnt Get Stuck In Objects
        llResetScript();                            //Reset The Script And Trigger state_entry()
    }
    
    state_entry()
    {
        llSetTouchText("Touch");                    //Set Text For The "Touch" Button In The Pie Menu
        
        llSetSitText("Sit");                        //Set Text For The "Sit" Button In The Pie Menu
        
        llSitTarget(<5, 5, 5>, ZERO_ROTATION);      //Offset To Sit On The Object (up to 300m on any axis)
        
        llSetVehicleFlags(2);
        
        llSetVehicleType(VEHICLE_TYPE_CAR);
        
        llSetVehicleFlags(VEHICLE_FLAG_LIMIT_ROLL_ONLY);
        
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.8);
        
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.5);
        
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.1);
        
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.8);
        
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.8);
        
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.5);
        
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.11);
        
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.8);
        
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1000.0, 2.0, 1000.0>);
        
        llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <10.0, 2.0, 1000.0>);
        
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 1);
        
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 0.1);
        
        llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, -1);
        
        llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 0.5);
        
        llCollisionSound("", 0.0);
    }    
    
    changed(integer change)
    {
        //Unsit Person
        if (change & CHANGED_LINK)
        {
            key agent = llAvatarOnSitTarget();
            if (agent)
            {
                llWhisper(0, "Please Dont Sit On Me...");
                llUnSit(agent);
            }
        }
    }
    
    touch_start(integer num)
    {
        if(llDetectedKey(0)==llGetOwner())                              //Only Activate For Owner
        llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);    //Request Owners Permissions
    }
    
    run_time_permissions(integer perm)
    {
        if (perm)
        {
            llSetStatus(STATUS_PHYSICS, TRUE);  //Set Object Physical
            
            llTakeControls(CONTROL_UP | CONTROL_DOWN | CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);                     //Take The Controls Of Owner
        }
        else
        {
            llSetStatus(STATUS_PHYSICS, FALSE); //Set Object Non-Phys
            llReleaseControls();                //Release Controls So Owner Can Move Around
        }
    }

    control(key id, integer level, integer edge)
    {
        vector angular_motor;

        if(level & CONTROL_FWD)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <speed,0,0>);           //Drive Forward
        }
        
        if(level & CONTROL_BACK)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <-(speed - 5),0,0>);    //Drive In Reverse
        }
        
        if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            angular_motor.x += TurnSpeed;
            angular_motor.z -= TurnSpeed;
        }
        
        if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
            angular_motor.x -= TurnSpeed;
            angular_motor.z += TurnSpeed;
        }    
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);    //Apply Angular Motor(turn vehicle)
    }    
}
