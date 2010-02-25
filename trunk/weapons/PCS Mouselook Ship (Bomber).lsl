// Mouselook flyer mmotor script
// By Jillian Callahan

//Please leave the credits intact!
//This script is NOT INTENDED FOR SALE! It's for learning about scripting!

float FWD_THRUST = 30.0;        //  Forward thrust motor force maximum
float LATERAL_THRUST = 8.0;       //  Lateral
float VERTICAL_THRUST = 14.0;   //  Hover thrust
float THRUST_PITCH = 0.0;
float mass;

// Other varables
key curr_pilot = NULL_KEY;  // the key of the pilot passed from the sit and control script

float motor_x = 0.0; // PERCENTAGES of MOTOR THRUST
float motor_y = 0.0;
float motor_z = 0.0;
integer armed = 0;

// STATES

default
{
    state_entry()
    {
        mass = llGetMass();
        llSetStatus(STATUS_PHANTOM, FALSE);
        llSetStatus(STATUS_BLOCK_GRAB, TRUE);
        
        llSetVehicleType(VEHICLE_TYPE_SLED);
        
        llRemoveVehicleFlags(-1);
        llSetVehicleFlags(VEHICLE_FLAG_HOVER_UP_ONLY);
        llSetVehicleFlags(VEHICLE_FLAG_MOUSELOOK_STEER);
        llSetVehicleFlags(VEHICLE_FLAG_CAMERA_DECOUPLED);
        llSetVehicleFlags(VEHICLE_FLAG_LIMIT_ROLL_ONLY);
        
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.0);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 900.0);
        
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.0);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 900.0);
        
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 0.25);  //  ------------- 1.5
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 100.0);
        
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.05);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.01);
        
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0.0, 4.0, 3.5> ); // Required for mouselook
        
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <60.0, 1.0, 30.0>);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <0.0, 0.0, 0.0>);
        
        llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, 0.0);
        llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0);
        llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 9000.0);
        
        llSetVehicleFloatParam(VEHICLE_BUOYANCY, 0.94); // We floats, we does
    
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.5); // We be upright, but not uptight
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1.0);
       
        llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 1.0); // We likes to bank, we do
        llSetVehicleFloatParam(VEHICLE_BANKING_MIX, 0.75);
        llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 0.05); // And be quick about it!
    }
    
    link_message(integer src, integer num, string msg, key id)
    {
       if ( ( msg == "pilot" ) && (id == NULL_KEY) )
       {
            llSetTimerEvent(0);
                            
            motor_x = 0.0; // PERCENTAGES of MOTOR THRUST
            motor_y = 0.0;
            motor_z = 0.0;
            llMessageLinked(LINK_SET,0,"THROTTLE",NULL_KEY);
            llMessageLinked(LINK_SET,0,"rundown",NULL_KEY);
            llReleaseControls();
            llResetScript();
       }
       else if( ( msg == "pilot" ) && (id != NULL_KEY) )
       {
            motor_x = 0.0; // PERCENTAGES of MOTOR THRUST
            motor_y = 0.0;
            motor_z = 0.0;
            llMessageLinked(LINK_SET,0,"THROTTLE",NULL_KEY);
            llMessageLinked(LINK_SET,0,"runup",NULL_KEY);
            curr_pilot = id;
            llRequestPermissions(curr_pilot, PERMISSION_TAKE_CONTROLS);
            //  ------------------------------------------------------------------------*** STARTUP
            llMessageLinked(LINK_SET,0,"runloop",NULL_KEY);
//            llSetTimerEvent(0.3);
            llSetTimerEvent(0.05);
            llSetStatus(STATUS_BLOCK_GRAB, TRUE);
            armed = 0;
       }
       else if((msg == "arm"))
       {
           armed = 1;
       }
    }
    
    run_time_permissions(integer perms)
    {
        if(perms & (PERMISSION_TAKE_CONTROLS))
        {
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_UP | CONTROL_DOWN | CONTROL_ML_LBUTTON, TRUE, FALSE);
        }
        else
        {
            llUnSit(curr_pilot);
        }
    }
    
    control(key id, integer level, integer edge)
    {
        
// Controls -------- Mousie
        if ( ( level & CONTROL_ML_LBUTTON ) && ( edge & CONTROL_ML_LBUTTON ) )
        {
            if(armed == 0)
            {
                llMessageLinked(LINK_SET, 0, "fire", "");
            }
            else
            {
                llMessageLinked(LINK_SET, 0, "fire_missile", "");
                armed = 0;
            }
        }
        else if ( !( level & CONTROL_ML_LBUTTON ) && ( edge & CONTROL_ML_LBUTTON ) )
        {
            llMessageLinked(LINK_SET, 0, "cease fire", "");
        }


// CONTROLS -------- Y-AXIS THRUST

        if((edge & CONTROL_RIGHT) && (level & CONTROL_RIGHT))
        {
            motor_y = -1.0;
        }
        
        if((edge & CONTROL_RIGHT) && !(level & CONTROL_RIGHT))
        {
            motor_y = 0;
        }
        
        if((edge & CONTROL_LEFT) && (level & CONTROL_LEFT))
        {
            motor_y = 1.0;
        }
        
        if((edge & CONTROL_LEFT) && !(level & CONTROL_LEFT))
        {
            motor_y = 0;
        }

// CONTROLS -------- X-AXIS THRUST        =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= FORWARD THROTTLE

        if ( ( motor_x > -0.05 ) && ( motor_x < 0.05 ) ) motor_x = 0.0;

        if( (level & CONTROL_FWD) && (level & CONTROL_BACK) ) //FWD and BACK at once
        {
            if (motor_x != 0.0) // Avoid cloggin' the works
            {
                llMessageLinked(LINK_SET, 0, "THROTTLE", NULL_KEY);
            }
            motor_x = 0.0;
            llResetTime();
        }
        else if((llGetTime() > 0.3) && (level & CONTROL_FWD))
        {
            llResetTime();
            if (motor_x == 0.0 ) // Fresh start!
            {
                motor_x = motor_x + 0.1;
                if (motor_x > 1.1) motor_x = 1.1;
                llMessageLinked(LINK_SET,llRound(motor_x * 100),"THROTTLE",NULL_KEY);
            }
            else // Incement throttle!
            {
                motor_x = motor_x + 0.1;
                if (motor_x > 1.1) motor_x = 1.1;// regular limiter
                if ( ( motor_x > -0.05 ) && ( motor_x < 0.05 ) ) motor_x = 0.0;
                if (motor_x == 0.0) llMessageLinked(LINK_SET,0,"THRUST_HORIZONTAL_END",NULL_KEY);
                llMessageLinked(LINK_SET,llRound(motor_x * 100),"THROTTLE",NULL_KEY);
            }
        }
        else if((llGetTime() > 0.4) && (level & CONTROL_BACK))
        {
            llResetTime();
            if (motor_x == 0.0 ) // Fresh start!
            {
                motor_x = motor_x - 0.1;
                if (motor_x < -0.6) motor_x = -0.6;
                llMessageLinked(LINK_SET,llRound(motor_x * 100),"THROTTLE",NULL_KEY);
            }
            else // Incement throttle!
            {
                motor_x = motor_x - 0.1;
                if (motor_x < -0.6) motor_x = -0.6;// regular limiter
                if ( ( motor_x > -0.05 ) && ( motor_x < 0.05 ) ) motor_x = 0.0;
                llMessageLinked(LINK_SET,llRound(motor_x * 100),"THROTTLE",NULL_KEY);
            }
        }
        
        
// CONTROLS -------- Z-AXIS THRUST

        if((edge & CONTROL_UP) && (level & CONTROL_UP))
        {
            motor_z = 1.0;
        }
        
        if((edge & CONTROL_UP) && !(level & CONTROL_UP))
        {
            motor_z = 0.0;
        }
        
        if ((edge & CONTROL_DOWN) && (level & CONTROL_DOWN))
        {
            motor_z = -0.8;
        }
        
        if ((edge & CONTROL_DOWN) && !(level & CONTROL_DOWN))
        {
            motor_z = 0.0;
        }
    }
    
    timer()
    {
        // ===== Linear Motors!
        float motorx;
        vector motor = ZERO_VECTOR;
        if(motor_x > 1.0)
        {
            motorx = 1.0;
        }
        else
        {
            motorx = motor_x;
        }
        motor.x = FWD_THRUST * motorx;
        motor.y = LATERAL_THRUST * motor_y;
        motor.z = VERTICAL_THRUST * motor_z;
        
        //ADJUST Z MOTOR FOR DISTANCE TO GROUND
        vector pos = llGetPos();
        float z_motor_t = motor.z;
        if ( ((pos.z - llGround(ZERO_VECTOR)) < 15.0) && (motor.z < 0.0)) z_motor_t /= 3;
        if ( ((pos.z - llGround(ZERO_VECTOR)) < 5.0) && (motor.z < 0.0)) z_motor_t /= 2;
        if ( ((pos.z - llGround(ZERO_VECTOR)) < 2.0) && (motor.z < 0.0)) z_motor_t /= 2;
        motor.z = z_motor_t;
        
        //Apply the liniar motors
        if(motor_x == 1.1)
        {
            llApplyImpulse(<25000,0,0>, TRUE);
            motor.x = 39 * motorx;
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, motor);            
        }
        else 
        {
            llSetForce(<0,0,0>, TRUE);
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, motor);
        }
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }
}