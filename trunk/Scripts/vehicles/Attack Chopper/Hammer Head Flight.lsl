// This script should be in the root prim.  It's the flight script.

key avatar;
integer started;
integer hovering;
integer leveled;
integer afterburner;
integer afterburner_count;
//integer pressed;
//integer released;
integer physics_err;
integer control_list;
integer under_water;
integer no_owner;
vector linear;
vector angular;
vector linear_friction;
vector omega;
vector vel;
float throttle = 0.2;
float speed;
float side_slip;

rotation base_reference_frame = ZERO_ROTATION;

set_vehicle()
{
    llSetVehicleType(VEHICLE_TYPE_AIRPLANE);
    
    // linear friction
    llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0, 1.0, 0.5>);
    
    // uniform angular friction
    llSetVehicleFloatParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, 10.0);
    
    // linear motor
    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0.0, 0.0, 0.0>);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.5);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.5);
    
    // angular motor
    llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0.0, 5.0, 1.5>);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.01);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 360.0);
    
    // hover
    llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, 0.0);
    llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0.0);
    llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 360.0);
    llSetVehicleFloatParam(VEHICLE_BUOYANCY, 0.98);
    
    // linear deflection
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 1.0);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 1.0);
    
    // angular deflection
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.5);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 360.0);
    
    // vertical attractor
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.5);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1.0);
    
    // banking
    llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 1.0);
    llSetVehicleFloatParam(VEHICLE_BANKING_MIX, 0.0);
    llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 360.0);
    
    // default rotation of local frame
    llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, base_reference_frame);
    
    // removed vehicle flags
    llRemoveVehicleFlags(-1);
    
    // set vehicle flags
    llSetVehicleFlags(VEHICLE_FLAG_LIMIT_ROLL_ONLY | VEHICLE_FLAG_MOUSELOOK_STEER | VEHICLE_FLAG_CAMERA_DECOUPLED);
}

zero_controls()
{
    linear = ZERO_VECTOR;
    angular = ZERO_VECTOR;
    afterburner = FALSE;
    llSetForce(<0.0, 0.0, 0.0>, TRUE);
    llMessageLinked(LINK_ALL_OTHERS, llFloor(throttle * 100.0), "throttle", NULL_KEY);
    llMessageLinked(LINK_SET, 0, "afterburner off", NULL_KEY);
}

start()
{
    zero_controls();
    started = TRUE;
    hovering = FALSE;
    leveled = FALSE;
    under_water = FALSE;
    llStopMoveToTarget();
    physics_err = 0;
    no_owner = 0;
    llSetTimerEvent(0.25);
    llSetStatus(STATUS_PHYSICS, TRUE);
}

stop()
{
    llSetForce(ZERO_VECTOR, FALSE);
    llSetStatus(STATUS_PHYSICS, FALSE);
    started = FALSE;
    hovering = FALSE;
    leveled = FALSE;
    llStopMoveToTarget();
    llSetTimerEvent(0.0);
    llMessageLinked(LINK_SET, 0, "afterburner off", NULL_KEY);
}

default
{
    state_entry()
    {
        llSetStatus(STATUS_DIE_AT_EDGE | STATUS_PHYSICS, FALSE);
        control_list = CONTROL_DOWN | CONTROL_UP | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT | CONTROL_FWD | CONTROL_BACK | CONTROL_ML_LBUTTON;
        started = FALSE;
        hovering = FALSE;
        leveled = FALSE;
        under_water = FALSE;
        avatar = NULL_KEY;
        stop();
        llReleaseControls();
    }
    
    on_rez(integer sparam)
    {
        stop();
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "pilot" && id != NULL_KEY) {
            avatar = id;
            state active;
        }
    }
}

state active
{
    state_entry()
    {
        stop();
        set_vehicle();
        zero_controls();
        llRequestPermissions(avatar, PERMISSION_TAKE_CONTROLS);
    }
    
    on_rez(integer sparam)
    {
        state default;
    }
    
    run_time_permissions(integer perms)
    {
        if ((perms & PERMISSION_TAKE_CONTROLS)) {
            llTakeControls(control_list, TRUE, FALSE);
        }
    }
    
    control(key id, integer held, integer edge)
    {
        linear = ZERO_VECTOR;
        linear_friction = <1.5, 1.25, 0.5>;
        
        if (started) {
            //pressed = edge & held;
            //released = edge & ~held;
            speed = llVecMag(llGetVel());
            
            if ((held & CONTROL_FWD) == CONTROL_FWD) {
                linear.x += 40.0 * throttle;
                linear_friction = <60.0, 10.0, 1.0>;
            }
            
            if ((held & CONTROL_BACK) == CONTROL_BACK) {
                linear.x -= 8.0;
                linear_friction.x = 5.0;
            }
            
            if ((held & CONTROL_UP) == CONTROL_UP) {
                linear.z += 20.0 * throttle;
                linear_friction.z = 5.0;
            }
            
            if ((held & CONTROL_DOWN) == CONTROL_DOWN) {
                linear.z -= 20.0 * throttle;
                linear_friction.z = 5.0;
            }
            
            if ((held & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON || (held & CONTROL_LBUTTON) == CONTROL_LBUTTON) {
               llMessageLinked(LINK_SET, 0, "fire_laser", NULL_KEY); 
            }
            
            if ((held & CONTROL_RIGHT) == CONTROL_RIGHT || (held & CONTROL_ROT_RIGHT) == CONTROL_ROT_RIGHT) {
                linear.y -= 5.0 + (0.875 * speed);
                if (linear.y < (-40.0 * throttle)) {
                    linear.y = -40.0 * throttle;
                }
                linear_friction.y = 30.0;
            }
            
            if ((held & CONTROL_LEFT) == CONTROL_LEFT || (held &  CONTROL_ROT_LEFT) == CONTROL_ROT_LEFT) {
                linear.y += 5.0 + (0.875 * speed);
                if (linear.y > (40.0 * throttle)) {
                    linear.y = 40.0 * throttle;
                }
                linear_friction.y = 30.0;
            }
            
             if ((held & CONTROL_LEFT) == CONTROL_LEFT && (held & CONTROL_RIGHT) == CONTROL_RIGHT) {
                
              llMessageLinked(LINK_SET, 0, "Fire1", NULL_KEY);
              llSleep(0.30);  
                
                
            }
            if ((held & CONTROL_FWD) == CONTROL_FWD && (held & CONTROL_BACK) == CONTROL_BACK && !under_water) {
                if (afterburner_count < 2) {
                    afterburner_count += 1;
                } else {
                    linear_friction = <60.0, 0.75, 1.0>;
                    linear.x = 80.0;
                    omega = llGetOmega() / llGetRot();
                    llSetForce((<30.0, 0.0, llFabs(omega.z) * 0.5 * speed> * llGetMass()) * base_reference_frame, TRUE);
                    if (!afterburner) {
                        llPlaySound("bd987a8d-b32d-6b50-db92-5e883c53ea92", 0.5);
                    }
                    afterburner = TRUE;
                }
            } else if (afterburner) {
                llSetForce(<0.0, 0.0, 0.0>, TRUE);
                afterburner_count = 0;
                afterburner = FALSE;
            }
            
            if (under_water) {
                linear /= 2.0;
                linear_friction.x *= 2.0;
            }
            llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, linear_friction);
            if (linear != ZERO_VECTOR) {
                if (linear.x <= 0.0) {
                    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 360.0);
                } else if (linear.y != 0.0) {
                    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 5.0);
                } else {
                    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 1.5);
                }
                if (hovering) {
                    llStopMoveToTarget();
                    hovering = FALSE;
                }
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linear);
                if ((linear.x != 0.0 || linear.y != 0.0) && leveled) {
                    //llSetVehicleFlags(VEHICLE_FLAG_LIMIT_ROLL_ONLY);
                    llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <2.0, 2.0, 2.5>);
                    leveled = FALSE;
                }
            } else {
                llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 360.0);
            }
            
            llMessageLinked(21, 0, "engine", (string)linear);
        }
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "afterburner off") {
            afterburner = FALSE;
        } else if (str == "pilot" && id == NULL_KEY) {
            stop();
            avatar = NULL_KEY;
            state default;
        } else if (str == "start") {
            start();
        } else if (str == "stop") {
            stop();
        } else if (str == "set throttle") {
            if (num > 1) {
                throttle = (float)num / 10.0;
            } else if (num == 0) {
                throttle = 1.0;
            } else if (num == 1) {
                throttle = 0.2;
            }
            llMessageLinked(LINK_ALL_OTHERS, llFloor(throttle * 100.0), "throttle", NULL_KEY);
        } else if (str == "under water") {
            under_water = TRUE;
        } else if (str == "above water") {
            under_water = FALSE;
        }
    }
    
    timer()
    {
        if (started) {
            if (!llGetStatus(STATUS_PHYSICS)) {
                if (physics_err < 1) {
                    llSetStatus(STATUS_PHYSICS, TRUE);
                    physics_err += 1;
                } else {
                    llSetPos(llGetPos() + <0.0, 0.0, 1.0>);
                    llSetStatus(STATUS_PHYSICS, TRUE);
                }
            } else {
                physics_err = 0;
            }
            
            vel = (llGetVel() / llGetRot()) / base_reference_frame;
            
            if (linear.x == 0.0 && linear.y == 0.0) {
                if (llVecMag(<vel.x, vel.y, 0.0>) < 0.5 && !leveled && !under_water) {
                    leveled = TRUE;
                    //llRemoveVehicleFlags(VEHICLE_FLAG_LIMIT_ROLL_ONLY);
                    llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <2.0, 2.0, 2.5>);
                }
                if (linear.z == 0.0 && llVecMag(llGetVel()) < 0.5 && !hovering) {
                    hovering = TRUE;
                    llMoveToTarget(llGetPos(), 0.1);
                }
            }
            
            if (!under_water) {
                omega = (llGetOmega() / llGetRot()) / base_reference_frame;
                speed = llVecMag(vel);
                
                if (linear.y > 0.0) {
                    side_slip = (linear.y * 0.005) + 0.025;
                    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0);
                } else if (linear.y < 0.0) {
                    side_slip = (linear.y * 0.005) - 0.025;
                    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0);
                } else {
                    side_slip = 0.0;
                    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.5 - (speed * 0.0125));
                }
                
                llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, llEuler2Rot(<(omega.z / 3.0) * (0.5 + (speed / 80.0)) + side_slip, 0.0, 0.0>) * base_reference_frame);
                
                if (linear.x <= 40.0) {
                    if (omega.z > 1.8) {
                        omega.z = 1.8;
                    }
                    if (linear.x == 0.0) {
                        llSetForce(<0.0, 0.0, llFabs(omega.z) * llGetMass() * 16.5> * (speed / 40.0), FALSE);
                    } else {
                        llSetForce(<0.0, 0.0, llFabs(omega.z) * llGetMass() * 20.0> * (speed / 40.0), FALSE);
                    }
                }
            } else {
                llSetForce(ZERO_VECTOR, FALSE);
                llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, base_reference_frame);
                side_slip = 0.0;
                llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.5 - (speed * 0.0125));
                if (leveled) {
                    llSetVehicleFlags(VEHICLE_FLAG_LIMIT_ROLL_ONLY);
                    llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0.0, 5.0, 1.5>);
                    leveled = FALSE;
                }
            }
            
            if (llGetPermissionsKey() != avatar) {
                llWhisper(0, "/me Lost Permissions!");
                stop();
            }
            
            if (llKey2Name(llGetOwner()) == "") {
                no_owner += 1;
                if (no_owner > 3) {
                    llSay(0, "/me Owner out of range.");
                   // llDie();
                }
            } else {
                no_owner = 0;
            }
        } else {
            llSetStatus(STATUS_PHYSICS, FALSE);
        }
    }
}