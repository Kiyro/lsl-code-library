//•/•/•/•/•/•/•/Ð/A/M/E/N/•/H/A/X/•/•/•/•/•/•/•/•/•//

//Just a script for effects; fading particles out by timer
//(you DO NOT want small timers 'Living' on your land)

vector Scale;
float Increment = 0.01;//how fast to fade in an out 
float Timer = 0.1;//how fast to we add or remove our above increment
//Warning.. not too ^ fast as we are using extra state;

FadeOUT(){startAlpha -= Increment;
    float tc = Increment/2;//chopD increment in half because it was changing color too fast
    startColor.x += tc;startColor.y += tc;startColor.z += tc;
    endColor.x += tc;endColor.y += tc;endColor.z += tc;
    startSize -= <Scale.x-(Increment*4),Scale.y-(Increment*4), FALSE>;
    Particles();  
}
FadeIN(){startAlpha += Increment;
    float tc = Increment/2;
    startColor.x -= tc;startColor.y -= tc;startColor.z -= tc;
    endColor.x -= tc;endColor.y -= tc;endColor.z -= tc;
    startSize += <Scale.x+(Increment*4),Scale.y+(Increment*4), FALSE>;
    Particles();  
}

//Particle Params
integer effectFlags;
integer running             = TRUE;
integer colorInterpolation  = TRUE;
vector  startColor          = <0.110,0.997,0.500>; 
vector  endColor            = <0.146,0.811,0.000>;
float   startAlpha          = 1.0;
float   endAlpha            = 0.0;
integer glowEffect          = TRUE;
integer sizeInterpolation   = TRUE;
vector  startSize;
vector  endSize             = <0.04, .44, FALSE>;
integer followVelocity      = TRUE;
string  texture             = "bf8113e4-9693-408b-b40b-a339f9b369d7";
float   particleLife        = 2;
float   SystemLife          = 0.0;
float   emissionRate        = 0.04;
integer partPerEmission     = 44;
float   radius              = 0;
float   innerAngle          = 1.55;
float   outerAngle          = 1.54;
vector  omega               = <0, 0, 0>;
float   minSpeed            = 0.044;
float   maxSpeed            = 0.088;
vector  acceleration        = ZERO_VECTOR;
integer windEffect          = FALSE;
integer bounceEffect        = FALSE;
integer followSource        = FALSE;
key     target              = NULL_KEY;
integer randomAcceleration  = FALSE;
integer randomVelocity      = FALSE;
integer particleTrails      = FALSE;
//   integer pattern = PSYS_SRC_PATTERN_DROP;
//   integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE;
//   integer pattern = PSYS_SRC_PATTERN_ANGLE;
//   integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE;
integer pattern = PSYS_SRC_PATTERN_EXPLODE;
//integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY;
Particles(){
// Here is where to set the current target
// llGetKey() targets this script's container object
// llGetOwner() targets the owner of this script
// Feel free to insert any other valid key
key target = "";
    if (colorInterpolation) effectFlags = effectFlags|PSYS_PART_INTERP_COLOR_MASK;
    if (sizeInterpolation)  effectFlags = effectFlags|PSYS_PART_INTERP_SCALE_MASK;
    if (windEffect)         effectFlags = effectFlags|PSYS_PART_WIND_MASK;
    if (bounceEffect)       effectFlags = effectFlags|PSYS_PART_BOUNCE_MASK;
    if (followSource)       effectFlags = effectFlags|PSYS_PART_FOLLOW_SRC_MASK;
    if (followVelocity)     effectFlags = effectFlags|PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target!="")       effectFlags = effectFlags|PSYS_PART_TARGET_POS_MASK;
    if (glowEffect)         effectFlags = effectFlags|PSYS_PART_EMISSIVE_MASK;
//Uncomment the following selections once they've been implemented
//    if (randomAcceleration) effectFlags = effectFlags|PSYS_PART_RANDOM_ACCEL_MASK;
//    if (randomVelocity)     effectFlags = effectFlags|PSYS_PART_RANDOM_VEL_MASK;
//    if (particleTrails)     effectFlags = effectFlags|PSYS_PART_TRAIL_MASK;
    llParticleSystem([
        PSYS_PART_FLAGS,            effectFlags,
        PSYS_SRC_PATTERN,           pattern,
        PSYS_PART_START_COLOR,      startColor,
        PSYS_PART_END_COLOR,        endColor,
        PSYS_PART_START_ALPHA,      startAlpha,
        PSYS_PART_END_ALPHA,        endAlpha,
        PSYS_PART_START_SCALE,      startSize,
        PSYS_PART_END_SCALE,        endSize,    
        PSYS_PART_MAX_AGE,          particleLife,
        PSYS_SRC_ACCEL,             acceleration,
        PSYS_SRC_TEXTURE,           texture,
        PSYS_SRC_BURST_RATE,        emissionRate,
        PSYS_SRC_INNERANGLE,        innerAngle,
        PSYS_SRC_OUTERANGLE,        outerAngle,
        PSYS_SRC_BURST_PART_COUNT,  partPerEmission,      
        PSYS_SRC_BURST_RADIUS,      radius,
        PSYS_SRC_BURST_SPEED_MIN,   minSpeed,
        PSYS_SRC_BURST_SPEED_MAX,   maxSpeed, 
        PSYS_SRC_MAX_AGE,           SystemLife,
        PSYS_SRC_TARGET_KEY,        target,
        PSYS_SRC_OMEGA,             omega   ]);
}

default{
//
    state_entry(){
        Scale = llGetScale();
        llSetTimerEvent(Timer);
    }
//
    on_rez(integer x){
        llTriggerSound("ffd18eb2-1630-be04-0db9-09d609a5fcea",1.0);
        llLoopSound("58defac3-93e5-9b9b-3b1f-894443317137",1.0);
        llResetScript();
    }
//
    timer(){
        if(startAlpha < 0.0){
            state nextEffect;
        }
        else{
            FadeOUT();
        }   
    }
//
}

//// Another state for next effect~
state nextEffect{
//
    state_entry(){
        Scale = ZERO_VECTOR;
        llSetTimerEvent(Timer);
    }
//
    timer(){
        if(startAlpha > 1.0){
            llResetScript();
        }
        else{
            FadeIN();
        }   
    }
//
}