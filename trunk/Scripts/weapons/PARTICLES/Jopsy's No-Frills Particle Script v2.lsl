// Jopsy's No-Frills Particle Script v2
// All settings below are 'defaults
integer mode;
default
{
    state_entry() {     
        llParticleSystem( [
            // Appearance Settings
        PSYS_PART_START_SCALE,(vector) <0.1,0.8,0>,// Start Size, (minimum .04, max 10.0?)
        PSYS_PART_END_SCALE,(vector) <0.2,0.3,0>, // End Size,  requires *_INTERP_SCALE_MASK
        PSYS_PART_START_COLOR,(vector) <1,1,1>,   // Start Color, (RGB, 0 to 1)
        PSYS_PART_END_COLOR,(vector) <.5,.5,1>,   // EndC olor, requires *_INTERP_COLOR_MASK
        PSYS_PART_START_ALPHA,(float) 0.9,        // startAlpha (0 to 1),
        PSYS_PART_END_ALPHA,(float) 0.5,          // endAlpha (0 to 1)
        PSYS_SRC_TEXTURE,(string) "",             // name of a 'texture' in emitters inventory
            // Flow Settings, keep (age/rate)*count well below 4096 !!!
        PSYS_SRC_BURST_PART_COUNT,(integer) 20,    // # of particles per burst
        PSYS_SRC_BURST_RATE,(float) 0.1,          // delay between bursts
        PSYS_PART_MAX_AGE,(float) 2.0,             // how long particles live
        PSYS_SRC_MAX_AGE,(float) 0,//15.0*60.0,       // turns emitter off after 15 minutes. (0.0 = never)
            // Placement Settings
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE, 
            // _PATTERN can be: *_EXPLODE, *_DROP, *_ANGLE, *ANGLE_CONE or *_ANGLE_CONE_EMPTY
        PSYS_SRC_BURST_RADIUS,(float) 0.1,        // How far from emitter new particles start,
        PSYS_SRC_INNERANGLE,(float) PI/20,          // aka 'spread' (0 to 2*PI), 
        PSYS_SRC_OUTERANGLE,(float) 0.0,          // aka 'tilt' (0(up), PI(down) to 2*PI),
        PSYS_SRC_OMEGA,(vector) <0,0,2 * PI>,          // how much to rotate around x,y,z per burst,
            // Movement Settings
        PSYS_SRC_ACCEL,(vector) <0,0,-3>,          // aka gravity or push, ie <0,0,-1.0> = down
        PSYS_SRC_BURST_SPEED_MIN,(float) 2.5,     // Minimum velocity for new particles
        PSYS_SRC_BURST_SPEED_MAX,(float) 3.5,     // Maximum velocity for new particles
        //PSYS_SRC_TARGET_KEY,(key) llGetOwner(), // key of a target, requires *_TARGET_POS_MASK
            // for *_TARGET try llGetKey(), or llGetOwner(), or llDetectedKey(0) even. :)
            
        PSYS_PART_FLAGS,      // Remove the leading // from the options you want enabled:              
             //PSYS_PART_EMISSIVE_MASK |           // particles glow
             PSYS_PART_BOUNCE_MASK |             // particles bounce up from emitter's 'Z' altitude
             //PSYS_PART_WIND_MASK |               // particles get blown around by wind
             //PSYS_PART_FOLLOW_VELOCITY_MASK |    // particles rotate towards where they're going
             //PSYS_PART_FOLLOW_SRC_MASK |         // particles move as the emitter moves
             PSYS_PART_INTERP_COLOR_MASK |       // particles change color depending on *_END_COLOR 
             PSYS_PART_INTERP_SCALE_MASK |       // particles change size using *_END_SCALE
             //PSYS_PART_TARGET_POS_MASK |         // particles home on *_TARGET key
         0 // Unless you understand binary arithmetic, leave this 0 here. :)
        ] );
        //sound
        llLoopSound("runningriver",1.0);
    }
    
    //touch_start(integer num) {
        //if (mode++) llResetScript(); // 2nd time touched?  start over
        //else llParticleSystem([ ]); // 1st time touched?  Turn particles off.
    //}
}
