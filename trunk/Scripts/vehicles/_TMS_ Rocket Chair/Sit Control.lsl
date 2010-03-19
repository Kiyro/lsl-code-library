integer sit = FALSE;
integer brake = TRUE;
float X_THRUST = 20;
float Z_THRUST = 15;
float xMotor;
float zMotor;
key agent;
key pilot;
vector CAM_OFFSET = <-3.5, 0.0, 2.0>;
vector CAM_ANG = <0.0, 0.0, 0.5>;

 default 
    {
    state_entry() 
    {
    llListen(0, "", NULL_KEY, "" );
    llSetSoundQueueing(TRUE);       
    llSetSitText("Fly Me");
    llSetCameraEyeOffset(CAM_OFFSET);
    llSetCameraAtOffset(CAM_ANG);
    llCollisionSound("466b03fb-91f6-8889-1780-dd357cff6a9f",1.0);      
    llSetVehicleType(VEHICLE_TYPE_AIRPLANE);
        
    llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, <200, 20, 20> );
    llSetVehicleFloatParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, 2 );
    llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0> );
    llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_TIMESCALE, 2 );
    llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 120 );
    llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, <0, 0, 0> );
    llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0 ); 
    llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, .4);
    llSetVehicleFloatParam( VEHICLE_HOVER_HEIGHT, 4 );
    llSetVehicleFloatParam( VEHICLE_HOVER_EFFICIENCY, 0 ); 
    llSetVehicleFloatParam( VEHICLE_HOVER_TIMESCALE, 10000 );
    llSetVehicleFloatParam( VEHICLE_BUOYANCY, 1.0 );
    llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0 );
    llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 5 ); 
    llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0);
    llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 5);
    llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 1 );
    llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1 );
    llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 1);
    llSetVehicleFloatParam( VEHICLE_BANKING_MIX, .5);
    llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, 0.01);
    llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, <0,0,0,1>);
    llRemoveVehicleFlags( VEHICLE_FLAG_NO_DEFLECTION_UP 
    | VEHICLE_FLAG_HOVER_WATER_ONLY
    | VEHICLE_FLAG_LIMIT_ROLL_ONLY 
    | VEHICLE_FLAG_HOVER_TERRAIN_ONLY 
    | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT 
    | VEHICLE_FLAG_HOVER_UP_ONLY 
    | VEHICLE_FLAG_LIMIT_MOTOR_UP );

    }
    on_rez(integer num) 
    {
    llSetStatus(STATUS_PHYSICS, FALSE);
    pilot = llGetOwner();   
    } 
    listen(integer number,string name,key id,string message)
    {
    {    
    }
    }
    timer()
    {
    llLoopSound("79619013-3527-1cbd-e7cd-2880d80b8bfd", 1.0);
    llSetTimerEvent(0.0);
    }
    changed(integer change)
    {
    agent = llAvatarOnSitTarget();
    if(change & CHANGED_LINK)
    {
    if((agent == NULL_KEY) && (sit))
    {  
    llSetStatus(STATUS_PHYSICS, FALSE);
    llMessageLinked(LINK_SET, 0,"stop","");
    brake = TRUE;
    llTriggerSound("cddc4af3-aa82-61f5-929a-e10ec60bc186", 1.0);
    llSetTimerEvent(0.0);
    llTriggerSound("3c2d8adb-edf7-9fcf-fa81-5d3b1502d110", 0.75);
    llSetStatus(STATUS_PHYSICS, FALSE);
    llStopSound();
    llReleaseControls();
    sit = FALSE;  
    }
    else if ((agent == llGetOwner()) && (!sit))
    {  
    pilot = llAvatarOnSitTarget();
    sit = TRUE;
    llRequestPermissions(pilot, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
    brake = FALSE;
    llTriggerSound("b9d74235-df34-dec7-8d0a-afb3b5f9417b", 1.0);
    llSetTimerEvent(2.0);
    llSetStatus(STATUS_PHYSICS, TRUE);
    llMessageLinked(LINK_SET, 0, "start", "");
    }
    }
    }
    run_time_permissions(integer perm) 
    {
    if (perm & (PERMISSION_TAKE_CONTROLS)) 
    {                    
    llTakeControls(CONTROL_ML_LBUTTON | CONTROL_UP | CONTROL_DOWN | CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
    }
    if (perm & PERMISSION_TRIGGER_ANIMATION)
    {   
    }   
    }
    control(key id, integer level, integer edge) 
    {
    if ((level & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON || (level & CONTROL_LBUTTON) == CONTROL_LBUTTON) 
    {
    llMessageLinked(LINK_SET, 0, "fire", NULL_KEY); 
    }
vector angular_motor; 
integer motor_changed;

    if ((level & CONTROL_FWD) || (level & CONTROL_BACK))
    {
    if (edge & CONTROL_FWD) xMotor = X_THRUST;   
    if (edge & CONTROL_BACK) xMotor =-X_THRUST;
    } 
    else
    {                 
    xMotor = 0;
    }
    if ((level & CONTROL_UP) || (level & CONTROL_DOWN))
    {
    if (level & CONTROL_UP) 
    {                    
    zMotor = Z_THRUST;
    }   
    if (level & CONTROL_DOWN) 
    {
    zMotor = -Z_THRUST;
    }  
    }
    else
    {
    zMotor = 0;    
    }              
    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <xMotor,0,zMotor>);
      
    if (level & CONTROL_RIGHT) 
    {
    angular_motor.x = TWO_PI;
    angular_motor.y /= 8;
    }   
    if (level & CONTROL_LEFT) 
    {
    angular_motor.x = -TWO_PI;
    angular_motor.y /= 8;
    }
    if (level & CONTROL_ROT_RIGHT) 
    {            
    angular_motor.x = TWO_PI;
    angular_motor.y /= 8;
    }
    if (level & CONTROL_ROT_LEFT) 
    {
    angular_motor.x = -TWO_PI;
    angular_motor.y /= 8;
    }
    llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
    }    
    }

