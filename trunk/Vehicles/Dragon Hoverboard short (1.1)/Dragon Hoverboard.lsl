//
// VARIABLES
//
key      avatar;
key      owner;

float    mass;
float    SIT_DROP              =  0.15;  //  Looks cool when you jump on
float    ROTATION_RATE         =  5.00;  //  Rate of turning  
float    TIMER_DELAY           =  0.10;
float    JUMP_FORCE            = 75.00;
float    JUMP_ROTATE           = 50.00;  //  Force to rotate on jump
float    JUMP_PITCH            =  7.00;  //  Force to pitch nose upward during a jump 
float    THRUST_PITCH          =  3.00;  //  Force to pitch nose upward on thrusting fwd/back
float    LAND_ROTATE           = 15.00;  //  Nose tips on landing
float    HOVER_HEIGHT          =  2.00;  //  How high to hover while flying
float    PRE_JUMP              =  0.50;  //  How far to come down when readying for jump 
float    MAX_JUMP_TIME         =  2.00;  //  Max secs to accumulate energy for jump 
float    FWD_THRUST            = 60.00;  //  Forward thrust motor force 
float    BACK_THRUST           = 10.00;  //  Backup thrust
float    FOLLOW_SCALE          = 10.00;  //  Extra boost to push upward for upcoming hills
float    FOLLOW_THRESHOLD      =  0.35;  //  Threshold for when to apply extra force 
float    AUTO_JUMP_THRESHOLD   =  5.00; 
float    STUMBLE               = -1.00;  //  Z-vel on landing that triggers stumble
float    TRICK_RATE            = 15.00;
float    MAX_JUMP_DURATION     = 15.00;  //  Jumps longer than this will be ended (like if you land on a house!)

float    TURN_FORCE            =  0.75;  // This steering multiplyer affects control across all speed ranges
float    MAX_TURN_BOOST        =  2.00;  // maximum amount to boost turning
float    TURN_BOOST_INC        =  0.025; // amount to increment the turn boost each cycle turn is held
float    turn_boost            =  1.00;  // amount to boost turn if steering is held down (1 = no boost))
float    speed;                          // What is our current speed?

vector   raw_velocity;                   // used in calculating 'speed' each control loop
vector   angular_motor;                  // calculted each control loop
vector   linier_motor;                   // calculted each control loop

vector   PUSH_OFF              = <0, 25, 75>; 
vector   LINEAR_FRICTION_RIDE  = <10.0, 5.0, 1000.0>; //  Friction while riding
vector   LINEAR_FRICTION_BRAKE = < 0.5, 0.5, 1000.0>; //  Friction while braking
vector   pos;
vector   vel;
vector   color;
 
float    jump_timer            = 0.0;
float    height_agl            = 0.0;
float    ground_height         = 0.0;
float    water_height          = 0.0;
float    vel_mag;
float    follow_diff;
float    cur_time; 

integer  timer_count           = 0;

rotation rot;

integer  is_jumping            = FALSE;
integer  over_water            = FALSE;
integer  listenindex;                    // used to clean up the listener neatly
integer  channel               = 1;      // listen channel that all commands need to be given on

//
// FUNCTIONS
//
string trim(string input) {
    return llDumpList2String(llParseString2List(input, [" "], []), " ");
}

preload_sounds() {
    llPreloadSound("start_up2.wav");
    llPreloadSound("shut_down2.wav");
    llPreloadSound("jump");
    llPreloadSound("pre_jump"); 
    llPreloadSound("brake");
    llPreloadSound("land");
}

set_vehicle_params() {
    llSetVehicleType(VEHICLE_TYPE_SLED);

    llSetVehicleFloatParam (VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY,  0.80);
    // slider between 0 (no deflection) and 1 (maximum strength)

    llSetVehicleFloatParam (VEHICLE_ANGULAR_DEFLECTION_TIMESCALE,   0.10);
    // exponential timescale for the vehicle to achieve full angular deflection

    llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE,     <10.0, 100.0, 100.0> );
    // vector of timescales for exponential decay of angular velocity about the three vehicle axes

    llSetVehicleFloatParam (VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE,  0.50);
    // exponential timescale for the angular motor's effectiveness to decay toward zero

    llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,        ZERO_VECTOR);
    // angular velocity that the vehicle will try to achieve

    llSetVehicleFloatParam (VEHICLE_ANGULAR_MOTOR_TIMESCALE,        0.20);
    // exponential timescale for the vehicle to achive its full angular motor velocity

    llSetVehicleFloatParam (VEHICLE_LINEAR_DEFLECTION_EFFICIENCY,   0.30);
    // slider between 0 (no deflection) and 1 (maximum strength)

    llSetVehicleFloatParam (VEHICLE_LINEAR_DEFLECTION_TIMESCALE,    0.10);
    // exponential timescale for the vehicle to redirect its velocity to be along its x-axis

    llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE,      LINEAR_FRICTION_RIDE);
    // vector of timescales for exponential decay of linear velocity along the three vehicle axes

    llSetVehicleFloatParam (VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE,   200.0);
    // exponential timescale for the linear motor's effectiveness to decay toward zero

    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,         ZERO_VECTOR);
    // linear velocity that the vehicle will try to achieve

    llSetVehicleFloatParam (VEHICLE_LINEAR_MOTOR_TIMESCALE,         1.50);
    // exponential timescale for the vehicle to achive its full linear motor velocity

    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_OFFSET,            <-0.20, 0.0, 0.0>);
    // offset from the center of mass of the vehicle where the linear motor is applied

    llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT,                    HOVER_HEIGHT);
    llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY,                0.50);
    llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE,                 0.10);

    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY,  0.10);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE,   1.00);

    llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY,              1.00);
    llSetVehicleFloatParam(VEHICLE_BANKING_MIX,                     0.75);
    llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE,               0.05);

    llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME,              ZERO_ROTATION);
    // rotation of vehicle axes relative to local frame

    llSetVehicleFloatParam(VEHICLE_BUOYANCY, 0.0);
    llRemoveVehicleFlags(-1);
    llSetVehicleFlags(VEHICLE_FLAG_HOVER_UP_ONLY | VEHICLE_FLAG_LIMIT_MOTOR_UP);
}

rotation Inverse(rotation r) {
    r.s = -r.s; return r;
}

start_jump(float mag) {
    //  This function is called to start a jump 
    vector imp = <0, 0, JUMP_FORCE> * mass * mag; 
    llApplyImpulse(imp, FALSE);
    jump_timer = llGetTime();
    llMessageLinked(LINK_SET, 0, "jump", "");
    llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, HOVER_HEIGHT);
    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0>);
    llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0,-JUMP_PITCH,0>);
    is_jumping = TRUE;
}

stop_jump() {
    is_jumping = FALSE;
    llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0,0,0>);
    llApplyRotationalImpulse(<0,-LAND_ROTATE*mass,0>, TRUE);
    llMessageLinked(LINK_SET, 0, "landing", "");
    vel = llGetVel();
    llTriggerSound("land", 0.5);
    llStopSound();
}

trick() {  
    llStartAnimation("backflip");
    llTriggerSound("trick", 0.5);
    llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0,TRICK_RATE,0>);
    llSleep(1.0);
    llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0,-JUMP_PITCH,0>);
}

//
// MAIN CODE
//
default {
    state_entry() {
        llTriggerSound("takeout", 1.0);
        preload_sounds();
        owner = llGetOwner();
        mass  = llGetMass();
        llSitTarget(<-0.5, 0.0, 1.0>, <0,0,0,1>);  //  Set seating location. Change for different height AVs
        llSetCameraEyeOffset(<-10.0, 1.0, 3.0>); llSetCameraAtOffset(<0, 1.0, 0>);
        llSetSitText("Ride");
        set_vehicle_params();
    }

    on_rez(integer param) { llResetScript(); }    

    touch_start(integer num) {
        if(llDetectedKey(0) != llGetOwner()) {
           llWhisper(0, "Hey!  You're not my owner!");
        }
        else {
        llTriggerSound("takeout", 0.5);
        llWhisper(0, "Are you are avatar enough to ride me?  Right Click, and choose 'Ride' from the pie menu.");
        }
    }

    changed(integer change) {
        if(change == CHANGED_LINK) {
            avatar = llAvatarOnSitTarget();
            llListenRemove(listenindex);
            if(avatar == NULL_KEY) {
                //  You have gotten off your bike 
                llMessageLinked(LINK_SET, 0, "idle", "");
                llPlaySound("shut_down2.wav",0.7);
                llSetStatus(STATUS_PHYSICS, FALSE);
                llReleaseControls();
                llStopAnimation("surf");
                llSetTimerEvent(0.0);
                llPushObject(llGetOwner(), PUSH_OFF, <0,0,0>, TRUE);      //  Help you off the bike 
            }
            else if(avatar == owner) {
                // You have gotten on your bike
                llMessageLinked(LINK_SET, 0, "get_on", "");
                llPlaySound("start_up2.wav", 0.7);
                llSetStatus(STATUS_PHYSICS | STATUS_BLOCK_GRAB, TRUE);
                llRequestPermissions(avatar, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
                llSetTimerEvent(TIMER_DELAY);
                listenindex = llListen(channel, "", avatar, "");
                llOwnerSay("/me listening for commands on channel '" + (string)channel + "'");
                llOwnerSay("/me say '/" + (string)channel + " help' for a copy of the owners manual.");
            }
            else {
                llSay(0, "Please step away from the hoverboard.");
                llUnSit(avatar);
            }
        }
    }

    listen(integer channel, string name, key id, string message) {
        message = trim(message); message = llToLower(message);
        if (message == "help") {
            llGiveInventory(id, "Dragon Hoverboard Manual");
        }
        else if (llGetSubString(message, 0, 7) == "color 1 ") {
            llMessageLinked(LINK_SET, 13254, trim(llGetSubString(message, 8, llStringLength(message))), NULL_KEY);
        }
        else if (llGetSubString(message, 0, 7) == "color 2 ") {
            color = (vector)trim(llGetSubString(message, 8, llStringLength(message)));
            llMessageLinked(LINK_SET, 13244, (string)color, NULL_KEY);
        }
    }

    run_time_permissions(integer perms) {
        if(perms & (PERMISSION_TAKE_CONTROLS)) {
            llStopAnimation("sit");
            llStartAnimation("surf");
            llTakeControls(CONTROL_FWD       | CONTROL_BACK     |
                           CONTROL_RIGHT     | CONTROL_LEFT     |
                           CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT |
                           CONTROL_UP        | CONTROL_DOWN     | 
                           CONTROL_ML_LBUTTON, TRUE, FALSE);
            llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, HOVER_HEIGHT - SIT_DROP);
            llSleep(0.5);
            llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, HOVER_HEIGHT);
        }
        else {
            llUnSit(avatar);
        }
    }

    control(key id, integer level, integer edge) {
        angular_motor = ZERO_VECTOR;
        linier_motor = ZERO_VECTOR;
        raw_velocity = llGetVel() * Inverse(llGetLocalRot());
        speed = raw_velocity.x; //get current _FORWARD_ speed

        if ((level & CONTROL_LEFT) | (level & CONTROL_ROT_LEFT)) {
            angular_motor += ( <-ROTATION_RATE, 0, ROTATION_RATE/2.0>);
            angular_motor.z *= llFabs(speed);
//            angular_motor += ( <-ROTATION_RATE, 0, ROTATION_RATE/2.0> * turn_boost * llSqrt(llFabs(speed)));
//            angular_motor.z = angular_motor.z * llSqrt(llFabs(speed));
            if (turn_boost < MAX_TURN_BOOST) {
                turn_boost += TURN_BOOST_INC;
            }
        }

        if ((level & CONTROL_RIGHT) | (level & CONTROL_ROT_RIGHT)) {
            angular_motor += ( <ROTATION_RATE, 0, -ROTATION_RATE/2.0>);
            angular_motor.z *= llFabs(speed);
//            angular_motor.z = angular_motor.z * llSqrt(llFabs(speed));
            if (turn_boost < MAX_TURN_BOOST) {
                turn_boost += TURN_BOOST_INC;
            }
        }

        // if either turn button is RELEASED, reset boost value
        if ((edge & ~level & (CONTROL_RIGHT | CONTROL_ROT_RIGHT)) || (edge & ~level & (CONTROL_LEFT | CONTROL_ROT_LEFT))) {
            turn_boost = 1.0;
        }

        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, LINEAR_FRICTION_RIDE);
        if (edge & level & CONTROL_FWD) {
            if (!is_jumping) {
                linier_motor = <FWD_THRUST,0,0>;
                llApplyRotationalImpulse(<0,-THRUST_PITCH*mass,0>, TRUE);
                llMessageLinked(LINK_SET, 0, "burst", "");
            }
        }

            if (level & CONTROL_FWD) {
            linier_motor = <FWD_THRUST,0,0>;
            llMessageLinked(LINK_SET, 0, "drive", "");
        }

        if (edge & level & CONTROL_BACK) {
            if (is_jumping) {
                trick();
            }     
        }

            if (level & CONTROL_BACK) {
            linier_motor = <-BACK_THRUST,0,0>;
        }


        //  "E" key pressed so get ready to jump
        if (edge & level & CONTROL_UP) {
            jump_timer = llGetTime();
            llStartAnimation("hello");
            llApplyRotationalImpulse(<0,-THRUST_PITCH*mass,0>, TRUE); 
            llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, HOVER_HEIGHT - PRE_JUMP);
            llTriggerSound("pre_jump", 1.0); 
        }

        // "E" key released so jump!
        if (edge & ~level & CONTROL_UP) {
            float mag = (llGetTime() - jump_timer)/MAX_JUMP_TIME;
            if (mag > 1.0) mag = 1.0;
            llStartAnimation("surf");
            start_jump(mag);
        }

        // engage friction break when "C" is pressed
        if (edge & level & CONTROL_DOWN) {
            llTriggerSound("brake", 1.0);
            llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, LINEAR_FRICTION_BRAKE);
        }

        // disengage friction break when "C" is released
        if (edge & ~level & CONTROL_DOWN) {
            llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, LINEAR_FRICTION_RIDE);
        }

        // Now actualy apply the values we just calculated
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, linier_motor);
    }

    timer() {
        //  check for ground and do stuff 
        timer_count++;
        cur_time = llGetTime() - jump_timer;
        if (is_jumping && (cur_time > 0.5)) {
            pos = llGetPos();
            water_height = llWater(<0,0,0>);
            ground_height = llGround(<0,0,0>); 
            if (water_height > ground_height)  {   
                height_agl = pos.z - water_height - 0.5;
            }
            else {
                height_agl = pos.z - ground_height - 0.5;
            }
            if ((height_agl < HOVER_HEIGHT) || (cur_time > MAX_JUMP_DURATION)) {
                stop_jump();
            }
        }
        else {
            //  On ground, so follow contour
            pos = llGetPos();
            vel = llGetVel();
            vel_mag = llVecMag(vel);
            water_height = llWater(llGetVel()*TIMER_DELAY);
            ground_height = llGround(llGetVel()*TIMER_DELAY);
            if (water_height > ground_height) {   
                follow_diff = pos.z - water_height - HOVER_HEIGHT + 0.45;
                if (!over_water) {
                    over_water = TRUE;
                    llMessageLinked(LINK_SET, 0, "over_water", "");
                } 
            }
            else {
                if (over_water) {
                    over_water = FALSE;
                    llMessageLinked(LINK_SET, 0, "over_ground", "");
                }
                follow_diff = pos.z - ground_height - HOVER_HEIGHT + 0.45;
            }

            if ((follow_diff < -FOLLOW_THRESHOLD) && (vel_mag > 2.0)) {
                llApplyImpulse(<0,0,-follow_diff*FOLLOW_SCALE>, TRUE);
            }

            if (!is_jumping && (follow_diff > AUTO_JUMP_THRESHOLD)) {
                start_jump(0.1);
            }
        }
    }
}