//red, green, yellow, blue, pink, turqoise
MakeParticles(vector size)                //This is the function that actually starts the particle system.
{                
    llParticleSystem([                   //KPSv1.0  
        PSYS_PART_FLAGS , 0 //Comment out any of the following masks to deactivate them
    //| PSYS_PART_BOUNCE_MASK           //Bounce on object's z-axis
    //| PSYS_PART_WIND_MASK             //Particles are moved by wind
    | PSYS_PART_INTERP_COLOR_MASK       //Colors fade from start to end
    | PSYS_PART_INTERP_SCALE_MASK       //Scale fades from beginning to end
    //| PSYS_PART_FOLLOW_SRC_MASK         //Particles follow the emitter
    | PSYS_PART_FOLLOW_VELOCITY_MASK    //Particles are created at the velocity of the emitter
    //| PSYS_PART_TARGET_POS_MASK       //Particles follow the target
    | PSYS_PART_EMISSIVE_MASK           //Particles are self-lit (glow)
    //| PSYS_PART_TARGET_LINEAR_MASK    //Undocumented--Sends particles in straight line?
    ,
    
    //PSYS_SRC_TARGET_KEY , NULL_KEY,   //Key of the target for the particles to head towards
                                                //This one is particularly finicky, so be careful.
    //Choose one of these as a pattern:
    //PSYS_SRC_PATTERN_DROP                 Particles start at emitter with no velocity
    //PSYS_SRC_PATTERN_EXPLODE              Particles explode from the emitter
    //PSYS_SRC_PATTERN_ANGLE                Particles are emitted in a 2-D angle
    //PSYS_SRC_PATTERN_ANGLE_CONE           Particles are emitted in a 3-D cone
    //PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY     Particles are emitted everywhere except for a 3-D cone
    
    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_EXPLODE
    
    ,PSYS_SRC_TEXTURE,           ""                 //UUID of the desired particle texture, or inventory name
    ,PSYS_SRC_MAX_AGE,           0.0                //Time, in seconds, for particles to be emitted. 0 = forever
    ,PSYS_PART_MAX_AGE,          1.0                //Lifetime, in seconds, that a particle lasts
    ,PSYS_SRC_BURST_RATE,        0.0               //How long, in seconds, between each emission
    ,PSYS_SRC_BURST_PART_COUNT,  100                  //Number of particles per emission
    ,PSYS_SRC_BURST_RADIUS,      1.0                //Radius of emission
    ,PSYS_SRC_BURST_SPEED_MIN,   .3                //Minimum speed of an emitted particle
    ,PSYS_SRC_BURST_SPEED_MAX,   .5                //Maximum speed of an emitted particle
    ,PSYS_SRC_ACCEL,             <0.0,0.0,0.0>     //Acceleration of particles each second
    ,PSYS_PART_START_COLOR,     <0.18431, 0.43529, 0.50588>      //Starting RGB color
    ,PSYS_PART_END_COLOR,        <0.18431, 0.43529, 0.50588>      //Ending RGB color, if INTERP_COLOR_MASK is on 
    ,PSYS_PART_START_ALPHA,      0.9                //Starting transparency, 1 is opaque, 0 is transparent.
    ,PSYS_PART_END_ALPHA,        0.0                //Ending transparency
    ,PSYS_PART_START_SCALE,      size      //Starting particle size
    ,PSYS_PART_END_SCALE,        size * 2      //Ending particle size, if INTERP_SCALE_MASK is on
    ,PSYS_SRC_ANGLE_BEGIN,       PI/2.0                 //Inner angle for ANGLE patterns
    ,PSYS_SRC_ANGLE_END,         PI/2.0                 //Outer angle for ANGLE patterns
    ,PSYS_SRC_OMEGA,             <0.0,0.0,0.0>       //Rotation of ANGLE patterns, similar to llTargetOmega()
            ]);
}
default
{
    state_entry()
    {
        MakeParticles(llGetScale());
    }
    on_rez(integer param)
    {
        MakeParticles(llGetScale());
    }
}