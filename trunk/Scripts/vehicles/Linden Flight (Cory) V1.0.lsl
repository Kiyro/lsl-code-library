vector angular_motor = <0,0,0>;
vector linear_motor = <0,0,0>;



default
{
    state_entry()
    {
        llSetSitText("fly");
        llSitTarget(<0.25,0,0.25>, ZERO_ROTATION);
        llSetCameraEyeOffset(<-3.0, 0.0, 3.0>);
        llSetCameraAtOffset(<4.0, 0.0, 2.0>);
        llSetVehicleType(VEHICLE_TYPE_AIRPLANE);
        
        llRemoveVehicleFlags(-1);
        
        
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.90);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.90);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.10);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.10);
        
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 0.10);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 1000.0);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.01);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.2);
        
        
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <100.0, 10.0, 300.0>);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <10.0, 10.0, 10.0>);
        
        
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.40);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1.0);
        
        llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 1.0);
        llSetVehicleFloatParam(VEHICLE_BANKING_MIX, 0.0);
        llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 0.05);
    }

    changed(integer change)
    {
       if(change & CHANGED_LINK)
       {
            key sit = llAvatarOnSitTarget();
            if(sit)
            {
                llSetStatus(STATUS_PHYSICS, TRUE);
                llRequestPermissions(sit, PERMISSION_TAKE_CONTROLS);
            }
            else
            {
                llSetStatus(STATUS_PHYSICS, FALSE);
                llReleaseControls();
            }
        }
    }
    
    run_time_permissions(integer perms)
    {
        if(perms & (PERMISSION_TAKE_CONTROLS))
        {
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_UP | CONTROL_DOWN , TRUE, FALSE);
        }
    }    

    control(key id, integer level, integer edge)
    {
        angular_motor = <0,0,0>;
        if((level) & CONTROL_UP)
        {
            angular_motor.y = 20;
        }
        if((level) & CONTROL_DOWN)
        {
            angular_motor.y = -20;
        }
        if((level) & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            angular_motor.x = 20;
        }
        if((level) & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
            angular_motor.x = -20;
        }
        if((level) & (CONTROL_FWD))
        {
            linear_motor.x += 2.0;
            if (linear_motor.x > 40.0)
                linear_motor.x = 40.0;
        }
        if((level) & (CONTROL_BACK))
        {
            linear_motor.x -= 2.0;
            if (linear_motor.x < 0.0)
                linear_motor.x = 0.0;
        }
    
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linear_motor);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
    }

}


