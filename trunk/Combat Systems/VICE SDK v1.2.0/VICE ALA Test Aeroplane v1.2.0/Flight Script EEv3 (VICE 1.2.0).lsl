// This airplane is a freebie; it includes a modified freebie flight script (EEV3) designed to support VICE
// In VICE terms, this airplane is an ALA with 2 LMG guns (contained in the gun prims, naturally)
// This VICE mod is by Creem Pye, April 1 2008
// Special thanks to Xenox Snook for supplying the fuselage!

// All the other people credited below worked on the airplane script, as far as I know...

string HUDtext="";
vector HUDcolor;
key pilot=NULL_KEY;
key auto_fire_sound="9d5c43c4-5849-4d65-2ae7-5799ffc568c7";  // in auto-fire mode
// Combat system stats:
integer vice_on;
integer team;
integer vice_hp;
integer max_vice_hp=10;
integer vice_hits;
integer vice_kills;
integer vice_deaths;
integer tcs_on;
integer tcs_hp;
integer max_tcs_hp=10;
integer tcs_hits;
integer tcs_kills;
integer tcs_deaths;
integer dead=FALSE;

// bombs
integer bomb_loaded=FALSE;


// interface Stuff
integer set_private_channel_number;
integer set_private_channel_handle;
integer privatelisten;
integer public_channel_handle;



// Modified from Cubey Terra DIY Plane 1.0 by Eoin Widget and Kerian Bunin
// which was originaly marked as September 10, 2005

// Distribute freely. Go ahead and modify it for your own uses. Improve it and share it around.
// Some portions based on the Linden airplane script originall posted in the forums.

// ** Last Modified by Eoin Widget on March 26, 2006 **
// Start up of the plane is now controled by typing the word "start" and shutting it down is is handled by typing stop
//It also taxies around on the ground or even on a elivated prim runway.
//It uses collision detection when on a prim runway and aswell as ground detection when on the ground.
//It uses a count down value in the timer to smooth out the transition between the two modes so that it doesn't switch back and forth while on the ground ebetween the times it detects a collision.  To change to ammount of time for this timer change the value of onGroundStartTime.



// llSitTarget parameters:
vector avPosition =  <-1.99850, 0.00060, 0.19740>;//<0.0,0.0,-0.6>; // position of avatar in plane, relative to parent
rotation avRotation = <0,-0.2,0,1>;//<0,-0.2,0,1>; // rotation of avatar, relative to parent


// Thrust variables:
// thrust = fwd * thrust_multiplier
// Edit the maxThrottle and thrustMultiplier to determine max speed.
integer fwd; // this changes when pilot uses throttle controls
integer maxThrottle = 10; // Number of "clicks" in throttle control. Arbitrary, really.
integer thrustMultiplier = 3; // Amount thrust increases per click.

// Lift and speed
float cruiseSpeed = 25.0; // speed at which plane achieves full lift
float lift;
float liftMax = 0.977; // Maximum allowable lift
float speed;
integer onGround=FALSE;
float timerFreq = 0.5;

integer fwdLast; 
integer sit;

integer startUp = FALSE;
integer camon = FALSE;

// Defining the Parameters of the normal driving camera.
// This will let us follow behind with a loose camera.
list drive_cam =
[
        CAMERA_ACTIVE, TRUE,
        CAMERA_BEHINDNESS_ANGLE, 0.0,
        CAMERA_BEHINDNESS_LAG, 0.5,
        CAMERA_DISTANCE, 10.0,//3.0,
        CAMERA_PITCH, 10.0,

        // CAMERA_FOCUS,
        CAMERA_FOCUS_LAG, 0.05,
        CAMERA_FOCUS_LOCKED, FALSE,
        CAMERA_FOCUS_THRESHOLD, 0.0,

        // CAMERA_POSITION,
        CAMERA_POSITION_LAG, 0.3,
        CAMERA_POSITION_LOCKED, FALSE,
        CAMERA_POSITION_THRESHOLD, 0.0, 
        
        CAMERA_FOCUS_OFFSET,<0,0,1>//<0,0,1>
 
       
];

//key motorstart = "jet-startup";
//key sound = "Ambient Jet";

refreshHUD()
{
    if(dead) HUDtext="";
    else
    {
        HUDtext="Airpeed: "+(string)llFloor(speed)+"kts\nThrottle: "+(string)llFloor(fwd*100.0/maxThrottle)+"%";
        if(vice_on||tcs_on) HUDcolor=<0.0,1.0,0.0>;  // green if healthy with combat enabled
        else HUDcolor=<1.0,1.0,1.0>;  // white when combat is disabled
        if(vice_on)
        {
            
            HUDtext+="\nVICE";
            if(team>0) HUDtext+=" - Team "+(string)team;
            HUDtext+="\nHP: "+(string)vice_hp+" Damage Dealt: "+(string)vice_hits
            +"\nKills: "+(string)vice_kills+" Deaths: "+(string)vice_deaths;
            if(vice_hp<=max_vice_hp/2) HUDcolor=<1.0,0.0,0.0>;  // red if damaged
        }
        if(tcs_on)
        {
            
            HUDtext+="\nTCS";
            HUDtext+="\nHP: "+(string)tcs_hp+" Hits: "+(string)tcs_hits
            +"\nKills: "+(string)tcs_kills+" Deaths: "+(string)tcs_deaths;
            if(tcs_hp<=max_tcs_hp/2) HUDcolor=<1.0,0.0,0.0>;  // red if damaged
        }
        if(bomb_loaded && vice_on)
        {
            HUDtext+="\nBomb Loaded";
        }
    }
    llSetText(HUDtext+"\n \n \n \n ", HUDcolor, 1.0);
}

default 
{
    
    state_entry() 
    {
        llSetText("",ZERO_VECTOR,0.0);    
        llSitTarget(avPosition, avRotation); // Position and rotation of pilot's avatar.
        
        llSetCameraEyeOffset(<-12, 0, 2>);//<-7, 0, 1.5>); // Position of camera, relative to parent. 
         llSetCameraAtOffset(<0, 0, 1.9>);   // Point to look at, relative to parent.
        

        llSetSitText("Fly!"); // Text that appears in pie menu when you sit

        llCollisionSound("", 0.0); // Remove the annoying thump sound from collisions  
 
        //SET VEHICLE PARAMETERS -- See www.secondlife.com/badgeo for an explanation
        llSetVehicleType(VEHICLE_TYPE_AIRPLANE);
             
        llSetVehicleVectorParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, <1,0.5,1>);
        
        // linear motor
        llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, <400, 20, 20> );
        llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0> );
        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_TIMESCALE, 2 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 120 );
        
        // agular motor
        llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, <0, 0, 0> );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.3 ); 
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
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.3);
            
        // no vertical attractor 
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.2 );
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 5.0 );
        
        /// banking
        llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 1.0);
        llSetVehicleFloatParam( VEHICLE_BANKING_MIX, 1.0);
        llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, 0.5);
        
        
        // default rotation of local frame
        llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME,<0.00397, 0.15527, 0.03101, 0.98738>);
        
        // remove these flags 
        llRemoveVehicleFlags( VEHICLE_FLAG_NO_DEFLECTION_UP 
                              | VEHICLE_FLAG_HOVER_WATER_ONLY 
                              | VEHICLE_FLAG_HOVER_TERRAIN_ONLY 
                              | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT 
                              | VEHICLE_FLAG_HOVER_UP_ONLY 
                              | VEHICLE_FLAG_LIMIT_MOTOR_UP
                              | VEHICLE_FLAG_CAMERA_DECOUPLED 
                              | VEHICLE_FLAG_LIMIT_ROLL_ONLY);

        // set these flags 
        
        llParticleSystem([]);

    }
    
    on_rez(integer num) 
    {
        llSay(0,"VICE ALA test airplane, by Xenox Snook\nNow with VICE and TCS combat support, and bombs!\nCheck out the full-perm '"+llGetScriptName()+"' script to see how you can implement VICE in your own vehicles!\nSee http://vicecombat.com for more information.");
        llResetScript();
    } 

    // DETECT AV SITTING/UNSITTING AND TAKE CONTROLS
    changed(integer change)
    {
       if(change & CHANGED_LINK)
       {
            pilot=llAvatarOnSitTarget();
           
            // Pilot gets off vehicle
            if(pilot==NULL_KEY)
            {
                if(sit)
                {
                    if(!dead) llSetStatus(STATUS_PHYSICS, FALSE);
                    llSetTimerEvent(0.0);
                    llMessageLinked(LINK_SET, FALSE, "seated", "");
                    llReleaseControls();
                    llStopSound();
                    sit = FALSE;
                    llClearCameraParams();
                    llListenRemove(set_private_channel_handle);
                    llListenRemove(public_channel_handle);
                    privatelisten=FALSE;
                    vice_on=FALSE;
                    tcs_on=FALSE;
                    bomb_loaded=FALSE;
                    llSetText("",ZERO_VECTOR,0.0);
                    if(!dead) llWhisper(0,"Engine Off");
                }
            }
            
            // Pilot sits on vehicle
            else if(!sit)
            {
                llRequestPermissions(pilot, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION | PERMISSION_CONTROL_CAMERA);
                llTriggerSound("cbb7a77f-4302-e3b3-4c1f-6dcb30bf3382",1.0);  // engine startup
                llSetTimerEvent(timerFreq);
                llMessageLinked(LINK_SET, TRUE, "seated", pilot);
                sit = TRUE;
                onGround=TRUE;
                llSetStatus(STATUS_PHYSICS, TRUE);
                llSay(0,"Welcome aboard, "+llKey2Name(pilot)+".  Say 'vice on' to enable VICE combat, or 'help' to see other options");
                llListen(0,"",pilot,""); // listen for chat commands
            }
        }
    }

    //CHECK PERMISSIONS AND TAKE CONTROLS
    run_time_permissions(integer perm) 
    {
        if (perm & (PERMISSION_TAKE_CONTROLS)) 
        {            
            llTakeControls(CONTROL_UP | CONTROL_DOWN | CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_ML_LBUTTON | CONTROL_LBUTTON, TRUE, FALSE);
            llSleep(0.5);
            llWhisper(0,"Engine started");
            llLoopSound("c1f9b29b-c5fd-dc6a-1016-dcde4b8a3be1",1.0);  // engine loop
        }
    }
    
    listen( integer channel, string name, key id, string message )
    {
        string msg=llStringTrim(message,STRING_TRIM);
        if(channel==0)
        {   
            if(msg=="b")
            {
                if(vice_on)
                {
                    if(bomb_loaded)
                    {
                        llMessageLinked(LINK_SET,0,"bomb","");  // drop a bomb
                        bomb_loaded=FALSE;
                        refreshHUD();
                    }
                    else llWhisper(0,"Bomb not loaded... the floating text will tell you when it is loaded");
                }
                else llWhisper(0,"You must enable VICE using 'vice on' before you can drop bombs!");
            }
            else if (msg == "combat on") llWhisper(0," Try \"vice on\" or \"tcs on\"");
            else if(msg=="help")
            {
                llSay(0,"Help:\nControls:\n\t\t\tW/S - pitch down/up\n\t\t\tA/D - roll left/right\n\t\t\tE/C - Increment/Decrement Throttle by 10%\n\t\t\tLeft Mouse button: fire guns (when combat is on)\nCombat (all in chat):\n\t\t\t'vice on'/'vice off': enable/disable VICE combat\n\t\t\t'b' drop a bomb (VICE must be enabled and the bomb must be loaded)\n\t\t\t'k': enable kamikaze mode\n\t\t\t'death message my_message': set a custom death message\n\t\t\t'team 1': join Team 1 (other options are 'none','2','3','4')\n\t\t\t'channel': choose a private combat channel\n\t\t\t'channel reset': reset to default combat channel\n\t\t\t'tcs on'/'tcs off': enable/disable TCS combat\nMisc chat commands:\n\t\t\t\'c' toggle dynamic followcam");
            }
            else if(msg=="vice on")
            {
                if(!vice_on)
                {
                    vice_on=TRUE;
                    llMessageLinked(LINK_SET,TRUE,"vice ctrl","");
                    bomb_loaded=FALSE;  // wait for it to load...
                    refreshHUD();
                    llSleep(0.2);
                    llWhisper(0,"Now that VICE is enabled, you can drop bombs by typing 'b' in chat, once the bomb is loaded..");
                }
            }
            else if(msg=="vice off")
            {
                llMessageLinked(LINK_SET,FALSE,"vice ctrl","");
                vice_on=FALSE;
                refreshHUD();
            }
            else if(msg=="tcs on")
            {
                tcs_on=TRUE;
                llMessageLinked(LINK_SET,TRUE,"tcs ctrl","");
                refreshHUD();
            }
            else if(msg=="tcs off")
            {
                llMessageLinked(LINK_SET,FALSE,"tcs ctrl","");
                tcs_on=FALSE;
                refreshHUD();
            }
            else if(msg=="c")
            {
                 if(!camon)
                {
                     llSetCameraParams(drive_cam);
                    llOwnerSay("Dynamic Camera on");
                }
                else
                {
                    llClearCameraParams();
                    llOwnerSay("Dynamic Camera off");
                }
                camon=!camon;
            }
            else if(msg=="kamikaze" || msg=="k") llMessageLinked(LINK_SET,0,"kamikaze",""); 
            else if(msg=="channel reset") llMessageLinked(LINK_SET,0,"channel",""); 
            else if(msg=="channel")
            {
                set_private_channel_number=100+(integer)llFrand(900.0);
                llInstantMessage(llAvatarOnSitTarget(),"Choose a combat channel by chat: /"+(string)set_private_channel_number+" <password>");
                set_private_channel_handle=llListen(set_private_channel_number,"",pilot,"");
                llResetTime();
                privatelisten=TRUE;  // we are listening for the private channel selection
            }
            else if(llGetSubString(msg,0,3)=="team") // choose a team
            {
                team=llListFindList(["none","1","2","3","4"],[llStringTrim(llGetSubString(msg,4,-1),STRING_TRIM)]);
                if(team==-1) llWhisper(0,"Not a valid team. (Valid teams are: none, 1, 2, 3, 4)");
                else llMessageLinked(LINK_SET,team,"vice team","");
            }
            else if(llGetSubString(msg,0,12)=="death message")
            {
                // limit the death message to 20 characters (the sensor will truncate it anyway...
                string mydeathmessage=llGetSubString(msg,13,33);
                llMessageLinked(LINK_SET,0,"death message",mydeathmessage);                
            }
        }
        else if(channel==set_private_channel_number)  // a secret channel for choosing a game
        // 0 by default, so this if statement shouldn't happen unless the person is trying to pick a password
        {
            if(msg) //  don't pass a null password
            {
                llListenRemove(set_private_channel_handle);
                llMessageLinked(LINK_ROOT,1,"channel",msg);
                set_private_channel_number=0;  // reset this so that we know the timer isn't currently going
                privatelisten=FALSE;  // we stopped listening for the private channel selection
            }
        }
    }
                                    
    //FLIGHT CONTROLS     
    control(key id, integer level, integer edge) 
    { 
        if ((vice_on||tcs_on) && edge&1342177280) llMessageLinked(LINK_SET, level&1342177280, "gun ctrl", "");

        vector angular_motor=ZERO_VECTOR; 

                      
            
            // THROTTLE CONTROL--------------
            if (level & CONTROL_UP) 
            {
                if (fwd < maxThrottle)
                {
                    fwd += 1;
                }
            }
            else if (level & CONTROL_DOWN) 
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
                //llOwnerSay("Throttle at "+(string)((integer)thrustPercent)+"%");
                refreshHUD();
                fwdLast = fwd;
                llSleep(0.18); // crappy kludge :P
            }

            
            // PITCH CONTROL ----------------
            if (!onGround)
            {
                if (level & CONTROL_FWD) 
                {
                    angular_motor.y = 2.5;
                }
                else if (level & CONTROL_BACK) 
                {
                    angular_motor.y = -2.5;
                }
            }
            

            // BANKING CONTROL----------------
            // Eoin Widget modified this part to switch between turning on the z axis for ground movement and turning on the x axis for flight

            if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
            {
                if (onGround) angular_motor.z = PI / -6.0;
                else angular_motor.x = PI;
            }   
            else if (level & (CONTROL_LEFT|CONTROL_ROT_LEFT))
            {
                if (onGround) angular_motor.z = PI/6.0;
                else angular_motor.x = -PI;
            }

            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);         
    } 
    link_message(integer sender_number, integer number, string message, key id)
    {
        if(message=="taxi" && !onGround)
        {
            onGround=TRUE;  // message from the wheels saying that they hit something
            llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME,<0.00397, 0.15527, 0.03101, 0.98738>);
            llRemoveVehicleFlags( VEHICLE_FLAG_LIMIT_ROLL_ONLY ); 
        }
        else if(message=="bomb")
        {
            if(number<0)
            {
                bomb_loaded=TRUE;
                refreshHUD();
            }
        }
        else if(message=="vice stats")
        {
            vice_kills=(number>>26)&63;
            vice_deaths=(number>>20)&63;
            vice_hits=(number>>8)&4095;
            vice_hp=number&255;
            if(vice_hp>max_vice_hp) max_vice_hp=vice_hp;
            refreshHUD();        
        }
        else if(message=="tcs stats")
        {
            tcs_kills=(number>>26)&63;
            tcs_deaths=(number>>20)&63;
            tcs_hits=(number>>8)&4095;
            tcs_hp=number&255;
            if(tcs_hp>max_tcs_hp) max_tcs_hp=tcs_hp;
            refreshHUD();        
        }
        else if (message == "overheat" && number==TRUE) llWhisper(0,"Gun overheated!");
        else if(message == "crash")  // uncrash here
        {
            dead=number;
            if(dead)
            {
                llReleaseControls();
                llSetTimerEvent(0.0);
                refreshHUD();
                llSetVehicleFloatParam( VEHICLE_BUOYANCY, -2.0 );
                llPlaySound("b6d0b6ea-34b4-2920-18b1-56bbe3529d87",1.0);
                llParticleSystem([
                    PSYS_PART_FLAGS,            PSYS_PART_FOLLOW_VELOCITY_MASK|PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_WIND_MASK,
                    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
                    PSYS_SRC_ANGLE_BEGIN,       0.0,
                    PSYS_SRC_ANGLE_END,         PI/6.0,
                    PSYS_PART_START_COLOR,      <10, 10, 10>/255.0,
                    PSYS_PART_END_COLOR,        <63.75, 63.75, 63.75>/255.0,
                    PSYS_PART_START_ALPHA,      1.0,
                    PSYS_PART_END_ALPHA,        0.0,
                    PSYS_PART_START_SCALE,      <8.0,8.0,0.0>,
                    PSYS_PART_END_SCALE,        <4.0,4.0,0.0>,    
                    PSYS_PART_MAX_AGE,          8.0,
                    PSYS_SRC_ACCEL,             <0, 0, 1.0>,
                    PSYS_SRC_TEXTURE,           "05f956d5-9d9e-95a7-b39d-3dab596532a9",
                    PSYS_SRC_BURST_RATE,        0.25,
                    PSYS_SRC_BURST_PART_COUNT,  20,      
                    PSYS_SRC_BURST_SPEED_MIN,   0.075,
                    PSYS_SRC_BURST_SPEED_MAX,   0.75, 
                    PSYS_SRC_MAX_AGE,           0.0,
                    PSYS_SRC_BURST_RADIUS,      0.2
                ]);
            }
            else
            {
                llSetVehicleFloatParam( VEHICLE_BUOYANCY, 0.977 );
                llParticleSystem([]);
            }
        }
        else if(message == "crash collide")  // uncrash here
        {
            llPlaySound("b6d0b6ea-34b4-2920-18b1-56bbe3529d87",1.0);
            refreshHUD();
            llSetVehicleFloatParam( VEHICLE_BUOYANCY, 0.5 );
            if(pilot!=NULL_KEY)
            {
                llSetStatus(STATUS_PHYSICS,FALSE);  // to prevent violent ejection in H4 sims
                llSleep(0.15);
                llUnSit(pilot);                
            }
        }
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
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <(fwd * thrustMultiplier),0,0>);
        if(onGround && speed>15.0)
        {
            onGround=FALSE;
            llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, ZERO_ROTATION);
            llSetVehicleFlags( VEHICLE_FLAG_LIMIT_ROLL_ONLY ); 
        }
        refreshHUD();
        // channel listen timeout for selecting a private channel:
        if(privatelisten && llGetTime()>30.0)
        {
            privatelisten=FALSE;
            llListenRemove(set_private_channel_handle);
            llWhisper(0,"Timeout; closing private channel selection.");
        }
    }

}