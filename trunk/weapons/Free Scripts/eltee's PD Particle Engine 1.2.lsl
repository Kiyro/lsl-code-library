//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//// eltee Statosky's Particle Creation Engine 1.2
//// 03/19/2004
//// *PUBLIC DOMAIN*
//// Free to use
//// Free to copy
//// Free to poke at
//// Free to hide in stuff you sell
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//// Changelog:
//// 1.2: (1) Seperated out variable value assignments to 
////      dedicated function call (easier to copy/paste)
////      (2) Improved several comments
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
//////      Particle System Variables
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////



///////////////////////////////////////////////////////
// Effect Flag Collection variable
///////////////////////////////////////////////////////
integer effectFlags;
integer running=TRUE;

///////////////////////////////////////////////////////
// Color Secelection Variables
///////////////////////////////////////////////////////
// Interpolate between startColor and endColor
integer colorInterpolation;
// Starting color for each particle 
vector  startColor;
// Ending color for each particle
vector  endColor;
// Starting Transparency for each particle (1.0 is solid)
float   startAlpha;
// Ending Transparency for each particle (0.0 is invisible)
float   endAlpha;
// Enables Absolute color (true) ambient lighting (false)
integer glowEffect;

///////////////////////////////////////////////////////
// Size & Shape Selection Variables
///////////////////////////////////////////////////////
// Interpolate between startSize and endSize
integer sizeInterpolation;
// Starting size of each particle
vector  startSize;
// Ending size of each particle
vector  endSize;
// Turns particles to face their movement direction
integer followVelocity;
// Texture the particles will use ("" for default)
string  texture;

///////////////////////////////////////////////////////
// Timing & Creation Variables Variables
///////////////////////////////////////////////////////
// Lifetime of one particle (seconds)
float   particleLife;
// Lifetime of the system 0.0 for no time out (seconds)
float   SystemLife;
// Number of seconds between particle emissions
float   emissionRate;
// Number of particles to releast on each emission
integer partPerEmission;

///////////////////////////////////////////////////////
// Angular Variables
///////////////////////////////////////////////////////
// The radius used to spawn angular particle patterns
float   radius;
// Inside angle for angular particle patterns
float   innerAngle;
// Outside angle for angular particle patterns
float   outerAngle;
// Rotational potential of the inner/outer angle
vector  omega;

///////////////////////////////////////////////////////
// Movement & Speed Variables
///////////////////////////////////////////////////////
// The minimum speed a particle will be moving on creation
float   minSpeed;
// The maximum speed a particle will be moving on creation
float   maxSpeed;
// Global acceleration applied to all particles
vector  acceleration;
// If true, particles will be blown by the current wind
integer windEffect;
// if true, particles 'bounce' off of the object's Z height
integer bounceEffect;
// If true, particles spawn at the container object center
integer followSource;
// If true, particles will move to expire at the target
//integer followTarget        = TRUE;
// Desired target for the particles (any valid object/av key)
// target Needs to be set at runtime
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

// Feel free to insert any other valid key
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
    startAlpha          = 1.0;
    endAlpha            = 0.0;
    glowEffect          = TRUE;
//Size & Shape
    sizeInterpolation   = TRUE;
    startSize           = <0.5, 0.5, 0.0>;
    endSize             = <0.5, 0.5, 0.0>;
    followVelocity      = FALSE;
    texture             = "";
//Timing
    particleLife        = 3;
    SystemLife          = 0.0;
    emissionRate        = 0.02;
    partPerEmission     = 1;
//Emission Pattern
    radius              = 3.0;
    innerAngle          = 1.0;
    outerAngle          = 0.0;
    omega               = <0.0, 0.0, 0.2>;
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
    acceleration        = <0.0, 0.0, -0.5>;
    windEffect          = FALSE;
    bounceEffect        = FALSE;
    followSource        = FALSE;
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
