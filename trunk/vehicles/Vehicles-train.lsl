

////////////////////////////////////////////
// Train Script
//
////////////////////////////////////////////
float forward_power = 1; //Power used to go forward (1 to 30)
float reverse_power = -1; //Power used to go reverse (-1 to -30)
float turning_ratio = .1; //How sharply the vehicle turns. Less is more sharply. (.1 to 10)
/////////////// CONSTANTS ///////////////////
string  FWD_DIRECTION   = "-y";
vector  POSITION_OFFSET  = <0.0, 0.0, 0.0>; // Local coords
float   SCAN_REFRESH    =.2;


float   MOVETO_INCREMENT    = 0.005;
///////////// END CONSTANTS /////////////////

///////////// GLOBAL VARIABLES ///////////////
key gOwner;
rotation gFwdRot;
float   gTau;
float   gMass;
integer count;
integer repeat;
/////////// END GLOBAL VARIABLES /////////////

turn(string direction)
{

    //llSetText("Turning " + direction, <2,2,2>, 5);
    //llSleep(1);
    vector angular_motor;
    integer reverse=1;
    //get current speed
    vector vel = llGetVel();
    float speed = llVecMag(vel);

    //car controls
    if(direction == "Forward")
    {
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <forward_power,0,0>);
        reverse=1;
    }
    if(direction == "Back")
    {
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <reverse_power,0,0>);
        reverse = -1;
    }

    if(direction == "Right")
    {
        angular_motor.z -= speed / turning_ratio * reverse;
    }
    
    if(direction == "Left")
    {
        angular_motor.z += speed / turning_ratio * reverse;
    }

    llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);

} //end control   
    
help()
{
    llWhisper(0,"You can say the following commands:");
    llWhisper(0,"/start <-- I will follow you around");
    llWhisper(0,"/stop <-- I will stay where I am.");
    llWhisper(0,"/help <-- I will repeat this message.");
}

StartScanning() 
{

    llSetStatus(STATUS_PHYSICS, TRUE);
    llSensorRepeat("RRail-A Straight Gravel 2m", "",PASSIVE, 10, PI, SCAN_REFRESH);
//    llSensorRepeat("RRail-B Left Gravel", "",PASSIVE, 10, PI/2, SCAN_REFRESH);
//    llSensorRepeat("RRail-B Right Gravel", "",PASSIVE, 10, PI/2, SCAN_REFRESH);
    llSetText("Starting", <2,2,2>, 5);
}
 
StopScanning() 
{
    llSetStatus(STATUS_PHYSICS, FALSE);
    llSensorRemove();
    llSetText("Train is stopped", <2,2,2>, 5);

}


rotation GetFwdRot() 
{
    // Special case... 180 degrees gives a math error
    if (FWD_DIRECTION == "-x") 
    {
        return llAxisAngle2Rot(<0, 0, 1>, PI);
    }
    
    string Direction = llGetSubString(FWD_DIRECTION, 0, 0);
    string Axis = llToLower(llGetSubString(FWD_DIRECTION, 1, 1));
    
    vector Fwd;
    if (Axis == "x")
        Fwd = <1, 0, 0>;
    else if (Axis == "y")
        Fwd = <0, 1, 0>;
    else
        Fwd = <0, 0, 1>;
        
    if (Direction == "-")
        Fwd *= -1;
       
    return llRotBetween(Fwd, <1, 0, 0>); 
}

rotation GetRotation(rotation rot) 
{
    vector Fwd;
    Fwd = llRot2Fwd(rot);
    
    float Angle = llAtan2( Fwd.y, Fwd.x );
    return gFwdRot * llAxisAngle2Rot(<0, 0, 1>, Angle);
}


default
{
    
    state_entry() 
    {
        llSetStatus(STATUS_PHANTOM, TRUE);
        gOwner = llGetOwner();
//        gFwdRot = GetFwdRot();
       
       llSetVehicleType(VEHICLE_TYPE_CAR);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.2);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.80);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.10);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.10);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.2);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.1);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.5);
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1000.0, 2.0, 1000.0>);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <10.0, 10.0, 1000.0>);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.50);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 0.50);
        llSetStatus(STATUS_PHYSICS, TRUE);
       
        llSetText("Ready", <2,2,2>, 5);
       
        llListen(0, "", "", "");
    }
    



    touch_start(integer total_number)
    {
        llSetText("Touched", <2,2,2>, 5);
        StartScanning();
    }
    
    listen(integer channel, string name, key id, string mesg) 
    {
        mesg = llToLower(mesg);
        if ((id == gOwner) && ( mesg == "/start" )) 
        {
            StartScanning();
        }
        else if ((id == gOwner) && (mesg == "/stop" )) 
        {
            StopScanning();
        }
        
        else if ((id == gOwner) && (mesg == "/help")) 
        {
            help();
        }
    }
    
        

    on_rez(integer start_param)
    {
        llResetScript();
    } 

       
    
    sensor(integer num_detected)
    {
        rotation TargetRot;
       
        vector Pos = llDetectedPos(0);
        rotation Rot = llDetectedRot(0);
        
        //llSetText("rot = " + (string) Rot, <2,2,2>, 5);
       // llSleep(1);
  
        TargetRot = GetRotation(Rot); 
        //llSetText("Trot = " + (string) TargetRot, <2,2,2>, 5);
        //llSleep(1);
         
       // POSITION_OFFSET  = <0.0, 0.75,  0.1>;        
        
        //vector Offset = POSITION_OFFSET * Rot;
        //Pos += Offset;
        
        rotation vRot = llGetLocalRot()  ;
        
        
        //llSetText("vRrot = " + (string) vRot, <2,2,2>, 5);
        //llSleep(1);
        
        vector veca    = llRot2Euler(Rot);    
        vector vecb    = llRot2Euler(vRot );    
        
        float veca_Z  = veca.z;                    
        float vecb_Z  = vecb.z;                                
         
        float diff = veca_Z - vecb_Z;
        llSetText((string) diff , <2,2,2>, 5);                                      
                                                                                
        //rotation delta = vRot * Rot;
        
        //float Z = delta.z;
        if (diff < 0)
        {   
            turn("Right");
        }
        if (diff > 0)
        {
            
            turning_ratio = .1;
            
            turn("Left");
        }
        
  

        //llMoveToTarget(Pos, gTau);
        
        turn("Forward");
        //turn ("Forward");
        
        //turn("Right");
        
        count=0;
        repeat=0;
    }
    
    // if nobody is within 10 meters, say so.
    no_sensor() {
        llSay(0, "Nobody is around.");
        StopScanning();
    }


}