
///////////////////////////////////////////////////////
// Effect Flag Collection variable
///////////////////////////////////////////////////////
integer effectFlags;
integer running=TRUE;

///////////////////////////////////////////////////////
// Color Secelection Variables
///////////////////////////////////////////////////////
integer colorInterpolation;
vector  startColor;
vector  endColor;
float   startAlpha;
float   endAlpha;
integer glowEffect;

///////////////////////////////////////////////////////
// Size & Shape Selection Variables
///////////////////////////////////////////////////////
integer sizeInterpolation;
vector  startSize;
vector  endSize;
integer followVelocity;
string  texture;

///////////////////////////////////////////////////////
// Timing & Creation Variables Variables
///////////////////////////////////////////////////////
float   particleLife;
float   SystemLife;
float   emissionRate;
integer partPerEmission;

///////////////////////////////////////////////////////
// Angular Variables
///////////////////////////////////////////////////////
float   radius;
float   innerAngle;
float   outerAngle;
vector  omega;

///////////////////////////////////////////////////////
// Movement & Speed Variables
///////////////////////////////////////////////////////
float   minSpeed;
float   maxSpeed;
vector  acceleration;
integer windEffect;
integer bounceEffect;
integer followSource;
// If true, particles will move to expire at the target
//integer followTarget        = TRUE;
key     target;

///////////////////////////////////////////////////////
//As yet unimplemented particle system flags
///////////////////////////////////////////////////////
integer randomAcceleration  = FALSE;
integer randomVelocity      = FALSE;
integer particleTrails      = FALSE;

///////////////////////////////////////////////////////
// Pattern Selection
///////////////////////////////////////////////////////
integer pattern;



///////////////////////////////////////////////////////
// Particle System Call Function
///////////////////////////////////////////////////////
setParticles()
{
// Here is where to set the current target

// Feel free to insert any other valid key //////////////////////!!!!!!!!!!!!!!!
    target="";
// The following block of if statements is used to construct the mask 
    if (colorInterpolation) effectFlags = effectFlags|PSYS_PART_INTERP_COLOR_MASK;
    if (sizeInterpolation)  effectFlags = effectFlags|PSYS_PART_INTERP_SCALE_MASK;
    if (windEffect)         effectFlags = effectFlags|PSYS_PART_WIND_MASK;
    if (bounceEffect)       effectFlags = effectFlags|PSYS_PART_BOUNCE_MASK;
    if (followSource)       effectFlags = effectFlags|PSYS_PART_FOLLOW_SRC_MASK;
    if (followVelocity)     effectFlags = effectFlags|PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target!="")       effectFlags = effectFlags|PSYS_PART_TARGET_POS_MASK;
    if (glowEffect)         effectFlags = effectFlags|PSYS_PART_EMISSIVE_MASK;
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


///////////////////////////////////////////////////////
// Particle Effect Function
// - Edit the values here to change the effect
///////////////////////////////////////////////////////
ParticleFallsEffect()
{
//Color
    colorInterpolation  = TRUE;
    startColor          = <0.9, 0.9, 1.0>;
    endColor            = <0.5, 0.5, 0.8>;
    startAlpha          = 1.0; //1 est solid
    endAlpha            = 0.0;
    glowEffect          = TRUE;// Enables Absolute color (false = ambient lighting
//Size & Shape
    sizeInterpolation   = TRUE;
    startSize           = <0.5, 0.5, 0.0>;
    endSize             = <0.5, 0.5, 0.0>;
    followVelocity      = FALSE;// Turns particles to face their movement direction
    texture             = "";
//Timing
    particleLife        = 3;// in second
    SystemLife          = 0.0;// Lifetime of the system 0.0 for no time out (s)
    emissionRate        = 0.02;//seconds between particle emissions
    partPerEmission     = 1;
//Emission Pattern
    radius              = 3.0;//for angulare pattern
    innerAngle          = 1.0;
    outerAngle          = 0.0;
    omega               = <0.0, 0.0, 0.2>;//rotation
    pattern             = PSYS_SRC_PATTERN_ANGLE;
        // Drop parcles at the container objects' center
        //      PSYS_SRC_PATTERN_DROP;
        // Burst pattern originating at objects' center
        //      PSYS_SRC_PATTERN_EXPLODE;
        // Use 2D angle between innerAngle and outerAngle
        //      PSYS_SRC_PATTERN_ANGLE;
        // Use 3D cone spread between innerAngle and outerAngle
        //      PSYS_SRC_PATTERN_ANGLE_CONE;
//Movement
    minSpeed            = 0.0;
    maxSpeed            = 0.1;
    acceleration        = <0.0, 0.0, -0.5>;//acceleration applyed to all
    windEffect          = FALSE;
    bounceEffect        = FALSE;
    followSource        = FALSE;//true, particles spawn at the container object center
    target              = "";
        // llGetKey() targets this script's container object
        // llGetOwner() targets the owner of this script
        
//Particle Call
    setParticles();
}

default
{
    state_entry()
    {
        running=TRUE;
        llSetText("Running", <0.0, 1.0, 0.0>, 0.5);
        ParticleFallsEffect();
    }
    
    touch_start(integer num_detected)
    {
        if (running==TRUE)
        {
            running=FALSE;
            llSetText("Stopped", <1.0, 0.0, 0.0>, 0.5);
            llParticleSystem([]);
        }
        else
        {
            running=TRUE;
            llSetText("Running", <0.0, 1.0, 0.0>, 0.5);
            ParticleFallsEffect();
        }
    }
}
