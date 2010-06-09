//********************************************** 
//Title: Car 
//Author: Aaron Perkins 
//Date: 2/17/2004 
//********************************************** 

string last_wheel_direction; 
string cur_wheel_direction; 

default 
{ 
state_entry() 
{ 
llSetSitText("Deliver"); 

llSetCameraEyeOffset(<-10.0, 0.0, 5.0> ); 
llSetCameraAtOffset(<10.0, 0.0, 2.0> ); 

//car 
llSetVehicleType(VEHICLE_TYPE_CAR); 
llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.2); 
llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.80); 
llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.10); 
llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.10); 
llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 0.5); 
llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.2); 
llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.1); 
llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 1.0); 
llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1000.0, 2.0, 1000.0> ); 
llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <1000.0, 10.0, 1000.0> ); 
llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.50); 
llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 0.50); 
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
llSay(0, "Please step away from the vehicle."); 
llUnSit(agent); 
llPushObject(agent, <0,0,9999900>, ZERO_VECTOR, FALSE); 
} 
else 
{ 
//llTriggerSound("car_start",1); 

llMessageLinked(LINK_ALL_CHILDREN , 0, "WHEEL_DRIVING", NULL_KEY); 
llSleep(.4); 
llSetStatus(STATUS_PHYSICS, TRUE); 
llSleep(.1); 
llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS); 

llSetTimerEvent(0.1); 
llLoopSound("dieselidle",1); 
} 
} 
else 
{ 
llSetTimerEvent(0); 
llStopSound(); 

llSetStatus(STATUS_PHYSICS, FALSE); 
llSleep(.1); 
llMessageLinked(LINK_ALL_CHILDREN , 0, "WHEEL_DEFAULT", NULL_KEY); 
llSleep(.4); 
llReleaseControls(); 

llResetScript(); 
} 
} 

} 

run_time_permissions(integer perm) 
{ 
if (perm) 
{ 
llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP | CONTROL_RIGHT | 
CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE); 
} 
} 

control(key id, integer level, integer edge) 
{ 
integer reverse=1; 
vector angular_motor; 

//get current speed 
vector vel = llGetVel(); 
float speed = llVecMag(vel); 

//car controls 
if(level & CONTROL_FWD) 
{ 
cur_wheel_direction = "WHEEL_FORWARD"; 
llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <15,0,0> ); 
reverse=1; 
} 
if(level & CONTROL_BACK) 
{ 
cur_wheel_direction = "WHEEL_REVERSE"; 
llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <-15,0,0> ); 
reverse = -1; 
} 

if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT)) 
{ 
cur_wheel_direction = "WHEEL_RIGHT"; 
angular_motor.z -= speed / 6 * reverse; 
} 

if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT)) 
{ 
cur_wheel_direction = "WHEEL_LEFT"; 
angular_motor.z += speed / 6 * reverse; 
} 

llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor); 

} //end control 

timer() 
{ 
if (cur_wheel_direction != last_wheel_direction) 
{ 
llMessageLinked(LINK_ALL_CHILDREN , 0, cur_wheel_direction, NULL_KEY); 
last_wheel_direction = cur_wheel_direction; 
} 
} 

} //end default 
