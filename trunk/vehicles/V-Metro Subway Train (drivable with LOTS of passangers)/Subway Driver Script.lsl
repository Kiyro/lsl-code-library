//Basic Motorcycle Script
//
// by Cory
// commented by Ben

//The new vehicle action allows us to make any physical object in Second Life a vehicle. This script is a good example of a 
// very basic vehicle that is done very well.  

integer loopsnd = 0;

default
{   

    //There are several things that we need to do to define vehicle, and how the user interacts with it.  It makes sense to 
    // do this right away, in state_entry.
    state_entry()
    {
        
        //We can change the text in the pie menu to more accurately reflecet the situation.  The default text is "Sit" but in 
        // some instances we want you to know you can drive or ride a vehicle by sitting on it. The llSetSitText function will
        // do this.
        llSetSitText("Ride");
        
        //Since you want this to be ridden, we need to make sure that the avatar "rides" it in a acceptable position
        // and the camera allows the driver to see what is going on. 
        //
        //llSitTarget is a new function that lets us define how an avatar will orient itself when sitting.
        // The vector is the offset that your avatar's center will be from the parent object's center.  The
        // rotation is bassed off the positive x axis of the parent. For this motorcycle, we need you to sit in a way
        // that looks right with the motorcycle sit animation, so we have your avatar sit slightly offset from the seat.
       llSitTarget(<4.25127, 1.17753, 0.86486>, <0.00000, 0.00000, -0.38269, 0.92388>);
        
        
        llSetCameraEyeOffset(<-11.0, -0.00, 5.0>);
        llSetCameraAtOffset(<3.0, 0.0, 2.0>);
        
        
        llSetVehicleFlags(-1);
        llSetVehicleType(VEHICLE_TYPE_CAR);
        
        llSetVehicleFlags(VEHICLE_FLAG_NO_FLY_UP | VEHICLE_FLAG_LIMIT_ROLL_ONLY);
        
        
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.2);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.80);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.10);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.10);
        
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 0.3);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.2);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.3);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.1);
        
        
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1000.0, 2.0, 1000.0>);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <10.0, 10.0, 1000.0>);
        
       
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.90);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 0.90);
        
        
        llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 0.05);
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
                    llSay(0, "Sorry, This Subway Car is not in service...");
                    llUnSit(agent);
                    llPushObject(agent, <0,0,10>, ZERO_VECTOR, FALSE);
                }
                
                else
                {
                    llTriggerSound("SubwayCar Starup",1);
                    llSetStatus(STATUS_PHYSICS, TRUE);
                    llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
                    llLoopSound("SubwayCar Engin",1);
                }
            }
            else
            {
                llStopSound();
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
            llStartAnimation("sitting chair f05");
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
        }
    }
    control(key id, integer level, integer edge)
    {
        
        vector angular_motor;

        if (level & edge & CONTROL_FWD)
        {
            
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <8,0,0>);
            
        }
        else if ((edge & CONTROL_FWD) && ((level & CONTROL_FWD) == FALSE))
        {
            
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0>);
            
            loopsnd = 0;
        }
        else if (level & CONTROL_FWD)
        {
            
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <8,0,0>);
            
           
        }
        
        if(level & CONTROL_BACK)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <-5,0,0>);
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




