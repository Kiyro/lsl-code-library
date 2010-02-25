getParticles1()
{
llParticleSystem([ 

// Particle System paramaters
//*************************************************************************************
//*************************************************************************************


// Type of Particle
//*****************
PSYS_SRC_PATTERN, 
// ONLY uncomment *ONE* of the following choises!.  Comment the other four.
//*************************************************************************
// PSYS_SRC_PATTERN_EXPLODE,              // Particles just go everywhere filling the entire radius
// PSYS_SRC_PATTERN_DROP,                 // Particles flow in a stream
 PSYS_SRC_PATTERN_EXPLODE,                // Particles go in a flat circular formation
// PSYS_SRC_PATTERN_ANGLE_CONE,           // particles form a cone
// PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY,     // Don't know what this is supposed to do.  Makes parrticles invisible I guess.

// End Type of Particle
//*********************

PSYS_SRC_BURST_RATE, 0.05 ,              // How long before the next particle is emmited (in seconds)
PSYS_SRC_BURST_RADIUS, 0.15 ,            // How far from the source to start emmiting particles
PSYS_SRC_BURST_PART_COUNT, 2 ,         // How many particles to emit per BURST 
PSYS_SRC_OUTERANGLE, 100.0 ,             // The area that will be filled with particles
PSYS_SRC_INNERANGLE, 100.0 ,             // A slice of the circle (hole) where particles will not be created
//PSYS_SRC_OMEGA, <0,0,0> ,               // Makes the particles twist or spin      **See End Note 1
PSYS_SRC_MAX_AGE, 0.0 ,                 //How long in seconds the system will make particles, 0 means no time limit.
PSYS_PART_MAX_AGE, 2.0 ,                // How long each particle will last before dying
PSYS_SRC_BURST_SPEED_MAX, 0.7 ,         // Max speed each particle can travel at   **See End Note 2
PSYS_SRC_BURST_SPEED_MIN, 0.5 ,         // Min speed each particle can travel at
PSYS_SRC_TEXTURE, "072e9401-4f48-f365-ee55-614142ccffdf",                   // Texture used as a particle.  For no texture use null string ""
PSYS_PART_START_ALPHA, 1.0 ,            // Alpha (transparency) value at birth
PSYS_PART_END_ALPHA, 0.1 ,              // Alpha (transparency) value at death
PSYS_PART_START_SCALE, <1.0, 1.0, 1> ,  // Start size of particles    **See End Note 3
PSYS_PART_END_SCALE, <1.0, 1.5, 1> ,    // End size (--requires PSYS_PART_INTERP_SCALE_MASK)  **See End Note 3 & 4
PSYS_PART_START_COLOR, <0, 25, 150> ,      // Start color of particles <R,G,B>
PSYS_PART_END_COLOR, <0, 0, 25> ,        // End color <R,G,B> (--requires PSYS_PART_INTERP_COLOR_MASK)   **See End Note 4
PSYS_SRC_ACCEL, <0, 0,0> ,             // Particles flow towards this direction, all zeros to stay put.
//PSYS_SRC_TARGET_KEY, llGetOwner() ,     // Target object the particles flow towards. If there is no target exclude this!

// Flags and flag parameters
//*********************************************************

PSYS_PART_FLAGS,

// The following flags can be used in the sub-argument for the PSYS_PART_FLAGS argument.
// They must remain "OR"ed ( | ) together.  Just uncomment the ones you want, and comment the ones you don't want
//*********************************** 

PSYS_PART_EMISSIVE_MASK                 // Make the particles glow
| PSYS_PART_BOUNCE_MASK                 // Make particles bounce on Z plan of object
| PSYS_PART_INTERP_SCALE_MASK           // Change from starting size to end size
| PSYS_PART_INTERP_COLOR_MASK           // Change from starting color to end color
//| PSYS_PART_WIND_MASK                   // Particles effected by wind
//| PSYS_PART_FOLLOW_SRC_MASK             // Particles follow the source
| PSYS_PART_FOLLOW_VELOCITY_MASK        // Particles turn to velocity direction
//| PSYS_PART_TARGET_POS_MASK             // Particle heads toward the object defined in PSYS_SRC_TARGET_KEY.
//| PSYS_PART_TARGET_LINEAR_MASK          // Sends particles in a stright line (towards target)
// End Flags ************************************************

]);
}

kill()
{
    llSleep(2);
    llDie();
}


default
{
    on_rez(integer param)
    {
        //llWhisper(0,"I just rezed");
        
        if(param == 1)
        {
            getParticles1();
            kill();
        }
    }     
    
    state_entry()
    {
        //llSay(0, "script saved");
        
    }
    
    touch_start(integer num)
    {
        getParticles1();
    }
}
