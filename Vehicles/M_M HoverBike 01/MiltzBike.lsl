
integer loopsnd = 0;

default
{   


    state_entry()
    {
        

        llSetSitText("Pilot");
        

        llSitTarget(<0.3, 0.0, 0.40>, ZERO_ROTATION);
        
        
        llSetCameraEyeOffset(<-6.0, -0.00, 3.0>);
        llSetCameraAtOffset(<3.0, 0.0, 2.0>);
        
        
        llSetVehicleFlags(-1);
        llSetVehicleType(VEHICLE_TYPE_CAR);
        
        llSetVehicleFlags(VEHICLE_FLAG_NO_FLY_UP | VEHICLE_FLAG_LIMIT_ROLL_ONLY);
        
        
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.1);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.80);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.10);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.10);
        
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 0.3);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.1);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.2);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.1);
        
        
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1000.0, 2.0, 1000.0>);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <10.0, 10.0, 1000.0>);
        
       
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.90);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 0.90);
        
        
        llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 1.0);
        llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 0.1);
        
        llCollisionSound("", 0.0);
    }
    
    changed(integer change)
    {
        
        if (change & CHANGED_LINK)
        {
           key agent = llAvatarOnSitTarget();
            
            if (agent)
            {
                if (agent != llGetOwner())
                {
                    llSay(0, "You do not have the Force with you");
                    llUnSit(agent);
                    llPushObject(agent, <0,0,100>, ZERO_VECTOR, FALSE);
                }
                
                else
                {
                    llSetStatus(STATUS_PHYSICS, TRUE);
                    llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
                }
            }
            else
            {
                llSetStatus(STATUS_PHYSICS, FALSE);
                llReleaseControls();
                llStopAnimation("sit");
            }
        }
        
    }
    
    run_time_permissions(integer perm)
    {
        if (perm)
        {
            llStopAnimation("sit");
            llStartAnimation("motorcycle_sit");
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
        }
    }
    control(key id, integer level, integer edge)
    {
        
        vector angular_motor;

        if (level & edge & CONTROL_FWD)
        {
            
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <50,0,0>);
            
        }
        else if ((edge & CONTROL_FWD) && ((level & CONTROL_FWD) == FALSE))
        {
            
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0>);
            
            loopsnd = 0;
        }
        else if (level & CONTROL_FWD)
        {
            
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <50,0,0>);
            
           
        }
        
        if(level & CONTROL_BACK)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <-10,0,0>);
        }
        if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            angular_motor.x += 100;
            angular_motor.z -= 100;
        }
        if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
            angular_motor.x -= 100;
            angular_motor.z += 100;
        }
        if(level & (CONTROL_UP))
        {
            angular_motor.y -= 50;
        }
    
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
    }
    
}
