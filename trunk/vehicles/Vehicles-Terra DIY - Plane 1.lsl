// CATEGORY:Vehicle
// CREATOR:Cubey Terra
// DESCRIPTION:Terra DIY - Plane 1.lsl
// ARCHIVED BY:Ferd Frederix

// Cubey Terra DIY Plane 1.0
// September 10, 2005

// Distribute freely. Go ahead and modify it for your own uses. Improve it and share it around.
// Some portions based on the Linden airplane script originall posted in the forums.


// llSitTarget parameters:
vector avPosition = <0.3,0.0,0.26>; // position of avatar in plane, relative to parent
rotation avRotation = <0,0,0,1>; // rotation of avatar, relative to parent

// Thrust variables:
// thrust = fwd * thrust_multiplier
// Edit the maxThrottle and thrustMultiplier to determine max speed.
integer fwd; // this changes when pilot uses throttle controls
integer maxThrottle = 10; // Number of "clicks" in throttle control. Arbitrary, really.
integer thrustMultiplier = 3; // Amount thrust increases per click.

// Lift and speed
float cruiseSpeed = 5.0; // speed at which plane achieves full lift
float lift;
float liftMax = 0.977; // Maximum allowable lift
float speed;

float timerFreq = 0.5;

integer fwdLast; 
integer sit;
key owner;

default 
{
    
    state_entry() 
    { 
        llSitTarget(avPosition, avRotation); // Position and rotation of pilot's avatar.
        
        llSetCameraEyeOffset(<-7, 0, 1.5>); // Position of camera, relative to parent. 
        llSetCameraAtOffset(<0, 0, 1.9>);   // Point to look at, relative to parent.
        

        llSetSitText("Fly"); // Text that appears in pie menu when you sit

        llCollisionSound("", 0.0); // Remove the annoying thump sound from collisions  
 
        //SET VEHICLE PARAMETERS -- See www.secondlife.com/badgeo for an explanation
        llSetVehicleType(VEHICLE_TYPE_AIRPLANE);
             
        // uniform angular friction 
        llSetVehicleFloatParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, 2 );
        
        // linear motor
        llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, <200, 20, 20> );
        llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0> );
        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_TIMESCALE, 2 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 120 );
        
        // agular motor
        llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, <0, 0, 0> );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0 ); 
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.4);
        
        // hover 
        llSetVehicleFloatParam( VEHICLE_HOVER_HEIGHT, 0 );
        llSetVehicleFloatParam( VEHICLE_HOVER_EFFICIENCY, 0 ); 
        llSetVehicleFloatParam( VEHICLE_HOVER_TIMESCALE, 10 );
        llSetVehicleFloatParam( VEHICLE_BUOYANCY, .977 );
        
        // no linear deflection 
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.2 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.5 ); 
        
        // no angular deflection 
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 1);
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.6);
            
        // no vertical attractor 
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.8 );
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 2 );
        
        /// banking
        llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 1);
        llSetVehicleFloatParam( VEHICLE_BANKING_MIX, .85);
        llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, 0.01);
        
        
        // default rotation of local frame
        llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, <0,0,0,1>);
        
        // remove these flags 
        llRemoveVehicleFlags( VEHICLE_FLAG_NO_DEFLECTION_UP 
                              | VEHICLE_FLAG_HOVER_WATER_ONLY 
                              | VEHICLE_FLAG_HOVER_TERRAIN_ONLY 
                              | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT 
                              | VEHICLE_FLAG_HOVER_UP_ONLY 
                              | VEHICLE_FLAG_LIMIT_MOTOR_UP );

        // set these flags 
        llSetVehicleFlags( VEHICLE_FLAG_LIMIT_ROLL_ONLY ); 

    }
    
    on_rez(integer num) 
    {
        llResetScript();
    } 
    

    // DETECT AV SITTING/UNSITTING AND TAKE CONTROLS
    changed(integer change)
    {
       if(change & CHANGED_LINK)
       {
            key agent = llAvatarOnSitTarget();
           
            // Pilot gets off vehicle
            if((agent == NULL_KEY) && (sit))
            {
                llSetStatus(STATUS_PHYSICS, FALSE);
                llSetTimerEvent(0.0);
                llMessageLinked(LINK_SET, 0, "unseated", "");
                llStopSound();
                llReleaseControls();
                sit = FALSE;
            }
            
            // Pilot sits on vehicle
            else if((agent == llGetOwner()) && (!sit))
            {
                llRequestPermissions(agent, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
                llSetTimerEvent(timerFreq);
                llMessageLinked(LINK_SET, 0, "seated", "");
                sit = TRUE;
                llSetStatus(STATUS_PHYSICS, TRUE);
            }
        }
    }


    //CHECK PERMISSIONS AND TAKE CONTROLS
    run_time_permissions(integer perm) 
    {
        if (perm & (PERMISSION_TAKE_CONTROLS)) 
        {            
            llTakeControls(CONTROL_UP | CONTROL_DOWN | CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
        }
    }
            
            
    //FLIGHT CONTROLS     
    control(key id, integer level, integer edge) 
    {

            integer throttle_up = CONTROL_UP;
            integer throttle_down = CONTROL_DOWN;
            integer yoke_fwd = CONTROL_FWD;
            integer yoke_back = CONTROL_BACK;

            vector angular_motor; 
            
            
            // THROTTLE CONTROL--------------
            if (level & throttle_up) 
            {
                if (fwd < maxThrottle)
                {
                    fwd += 1;
                }
            }
            else if (level & throttle_down) 
            {
                if (fwd > 0)
                {
                    fwd -= 1;
                }
            }
            
            if (fwd != fwdLast)
            {
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <(fwd * thrustMultiplier),0,0>);
                
                // calculate percent of max throttle and send to child prims as link message
                float thrustPercent = (((float)fwd/(float)maxThrottle) * 100);
                llMessageLinked(LINK_SET, (integer)thrustPercent, "throttle", "");
                llOwnerSay("Throttle at "+(string)((integer)thrustPercent)+"%");
                
                fwdLast = fwd;
                llSleep(0.15); // crappy kludge :P
            }

            
            // PITCH CONTROL ----------------
            if (level & yoke_fwd) 
            {
                angular_motor.y = 3.0;
            }
            else if (level & yoke_back) 
            {
                angular_motor.y = -3.0;
            }
            else
            {
                angular_motor.y = 0;
            }
            

            // BANKING CONTROL----------------

            if ((level & CONTROL_RIGHT) || (level & CONTROL_ROT_RIGHT)) 
            {
                angular_motor.x = TWO_PI;
            }   
            else if ((level & CONTROL_LEFT) || (level & CONTROL_ROT_LEFT)) 
            {
                angular_motor.x = -TWO_PI;
            }
            else
            {
                angular_motor.x = 0;
            }

            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
            
    } 
    
    timer()
    {
        // Calculate speed in knots
        speed = (integer)(llVecMag(llGetVel()) * 1.94384449 + 0.5);
        
        // Provide lift proportionally to speed
        cruiseSpeed = 25.0; // speed at which you achieve full lift
        lift = (speed/cruiseSpeed); //Lift is varied proportionally to the speed
        if (lift > liftMax) lift = liftMax;
        llSetVehicleFloatParam( VEHICLE_BUOYANCY, lift );
    }

}


// END //
