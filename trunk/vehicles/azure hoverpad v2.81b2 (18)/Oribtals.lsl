// Particle Script v3 - By Ama Omega
// 'orbitals' Custom settings by Jopsy Pendragon

// Mask Flags - set to TRUE to enable
integer glow = TRUE;            // Make the particles glow
integer bounce = FALSE;          // Make particles bounce on Z plan of object
integer interpColor = TRUE;     // Go from start to end color
integer interpSize = TRUE;      // Go from start to end size
integer wind = FALSE;           // Particles effected by wind
integer followSource = FALSE;    // Particles follow the source
integer followVel = TRUE;       // Particles turn to velocity direction

// Choose a pattern from the following:
// PSYS_SRC_PATTERN_EXPLODE
// PSYS_SRC_PATTERN_DROP
// PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
// PSYS_SRC_PATTERN_ANGLE_CONE
// PSYS_SRC_PATTERN_ANGLE
integer pattern = PSYS_SRC_PATTERN_ANGLE;

// Select a target for particles to go towards
// "" for no target, "owner" will follow object owner 
//    and "self" will target this object
//    or put the key of an object for particles to go to
key target;

// Particle paramaters
float age = 3; //how long will particles live (in seconds)
float maxSpeed = .005; //maximum speed a particle should be moving
float minSpeed =0.005; //minimum speed a particle should be movie
string texture; //texture applied to the particles
float startAlpha = 1; //alpha transparency at start
float endAlpha = 1; //alpha at end
vector startColor = <1.0,1.0,1.0>; 
vector endColor = <0.1,0.1,0.6>;
vector startSize = <0.3,0.3,0>; //particles start at this size
vector endSize = <0.04,0.04,0>; //and end at this size
vector push = <0,0,0>; //how far to push particles

// System paramaters
float rate = 0.01;      // How fast to emit particles
float radius = 1.0;       // Radius to emit particles for BURST pattern
integer count = 1;   // How many particles to emit per BURST 
float outerAngle = PI_BY_TWO;   // Outer angle for all ANGLE patterns
float innerAngle =PI_BY_TWO ;   // Inner angle for all ANGLE patterns
vector omega = <0,0,0>; // Rotation of ANGLE patterns around the source
float life = 0;
 


// Script variables
integer flags;

updateParticles()
{
    if (target == "owner") target = llGetOwner();
    if (target == "self") target = llGetKey();
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;

    
    
    llParticleSystem([  PSYS_PART_MAX_AGE,age,
                        PSYS_PART_FLAGS,flags,
                        PSYS_PART_START_COLOR, startColor,
                        PSYS_PART_END_COLOR, endColor,
                        PSYS_PART_START_SCALE,startSize,
                        PSYS_PART_END_SCALE,endSize, 
                        PSYS_SRC_PATTERN, pattern,
                        PSYS_SRC_BURST_RATE,rate,
                        PSYS_SRC_ACCEL, push,
                        PSYS_SRC_BURST_PART_COUNT,count,
                        PSYS_SRC_BURST_RADIUS,radius,
                        PSYS_SRC_BURST_SPEED_MIN,minSpeed,
                        PSYS_SRC_BURST_SPEED_MAX,maxSpeed,
                        PSYS_SRC_TARGET_KEY,target,
                        //PSYS_SRC_INNERANGLE,innerAngle, 
                        //PSYS_SRC_OUTERANGLE,outerAngle,
                        PSYS_SRC_OMEGA, omega,
                        PSYS_SRC_MAX_AGE, life,
                        PSYS_SRC_TEXTURE, texture,
                        PSYS_PART_START_ALPHA, startAlpha,
                        PSYS_PART_END_ALPHA, endAlpha
                            ]);
}
default
{
    state_entry()
    {
        //updateParticles();
        llParticleSystem([]);
        llTargetOmega(<0.0,0.0,1.0>,1,.2);
        llSetText("", <3,0,0>, 1.0);
        


        //llTargetOmega(llVecNorm(<(1-llFrand(2)),(1-llFrand(2)),(1-llFrand(2))> ),1,.1);
    }
    on_rez(integer num)
    {
        llResetScript();
    }
    link_message(integer sender_num, integer num, string str, key id)
    {
        if (str == "lighta!")
        {
            updateParticles();
        } else 
        if (str == "particles_off")
        {
            llResetScript();
        }
        
    }

}
