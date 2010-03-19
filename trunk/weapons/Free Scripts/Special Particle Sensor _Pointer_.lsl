//=========================Particle stuff==========================
// Particle Script 0.4
// Created by Ama Omega
// 3-7-2004

// Mask Flags - set to TRUE to enable
integer glow = FALSE;            // Make the particles glow
integer bounce = FALSE;          // Make particles bounce on Z plane of object
integer interpColor = TRUE;     // Go from start to end color
integer interpSize = TRUE;      // Go from start to end size
integer wind = FALSE;           // Particles effected by wind
integer followSource = TRUE;    // Particles follow the source
integer followVel = TRUE;       // Particles turn to velocity direction

// Choose a pattern from the following:
// PSYS_SRC_PATTERN_EXPLODE
// PSYS_SRC_PATTERN_DROP
// PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
// PSYS_SRC_PATTERN_ANGLE_CONE
// PSYS_SRC_PATTERN_ANGLE
integer pattern = PSYS_SRC_PATTERN_DROP;

// Select a target for particles to go towards
// "" for no target, "owner" will follow object owner 
//    and "self" will target this object
//    or put the key of an object for particles to go to
key target = "owner";

// Particle paramaters
float age = 5;                  // Life of each particle
float maxSpeed = 0.1;            // Max speed each particle is spit out at
float minSpeed = 0.1;            // Min speed each particle is spit out at
string texture;                 // Texture used for particles, default used if blank
float startAlpha = 1;           // Start alpha (transparency) value
float endAlpha = 1;           // End alpha (transparency) value
vector startColor = <1,1,1>;    // Start color of particles <R,G,B>
vector endColor = <1,1,1>;      // End color of particles <R,G,B> (if interpColor == TRUE)
vector startSize = <.25,.25,.25>;     // Start size of particles 
vector endSize = <.25,.25,.25>;       // End size of particles (if interpSize == TRUE)
vector push = <0,0,0>;          // Force pushed on particles

// System paramaters
float rate = .1;            // How fast (rate) to emit particles
float radius = 1;          // Radius to emit particles for BURST pattern
integer count = 1;        // How many particles to emit per BURST 
float outerAngle = 1.54;    // Outer angle for all ANGLE patterns
float innerAngle = 1.55;    // Inner angle for all ANGLE patterns
vector omega = <0,0,0>;    // Rotation of ANGLE patterns around the source
float life = 0;             // Life in seconds for the system to make particles

// Script variables
integer pre = 2;          //Adjust the precision of the generated list.

integer flags;
list sys;
integer type;
vector tempVector;
rotation tempRot;
string tempString;
integer i;

string float2String(float in)
{
    return llGetSubString((string)in,0,pre - 7);
}

updateParticles()
{
    flags = 0;
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
    sys = [  PSYS_PART_MAX_AGE,age,
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
                        PSYS_SRC_INNERANGLE,innerAngle, 
                        PSYS_SRC_OUTERANGLE,outerAngle,
                        PSYS_SRC_OMEGA, omega,
                        PSYS_SRC_MAX_AGE, life,
                        PSYS_SRC_TEXTURE, texture,
                        PSYS_PART_START_ALPHA, startAlpha,
                        PSYS_PART_END_ALPHA, endAlpha
                            ];
                            
    llParticleSystem(sys);
}
//=========================End Particle stuff==========================

// Special Particle Sensor Particle Emitter Script
// Written by Christopher Omega
// 
// Tasks:
// Process commands sent by the 'brain':
// Turn off the particle system case "RESET"
// Point at, and emit particle system at target case "POINT_AT".

// Global Constants
// MESSAGE_PARAMETER_SEPERATOR A constant that is used as a seperator in parsing lists sent as strings.
string MESSAGE_PARAMETER_SEPERATOR  = "|~|";

// AXIS_* constants, represent the unit vector 1 unit on the specified axis.
vector AXIS_UP = <0,0,1>;
vector AXIS_LEFT = <0,1,0>;
vector AXIS_FWD = <1,0,0>;

// SetLocalRot
// In a linked set, points a child object to the rotation.
// @param rot The rotation to rotate to.
SetLocalRot(rotation rot)
{
    if(llGetLinkNumber() > 1)
    {
        rotation locRot = llGetLocalRot();
        locRot.s = -locRot.s; // Invert local rot.
        
        rotation parentRot = locRot * llGetRot();
        parentRot.s = -parentRot.s; // Invert parent's rot.
    
        llSetRot(rot * parentRot);
    }
}

// getRotToPointAxisAt()
// Gets the rotation to point the specified axis at the specified position.
// @param axis The axis to point. Easiest to just use an AXIS_* constant.
// @param target The target, in region-local coordinates, to point the axis at.
// @return The rotation necessary to point axis at target.
rotation getRotToPointAxisAt(vector axis, vector target)
{
    return llGetRot() * llRotBetween(axis * llGetRot(), target - llGetPos());
}


// pointAt
// Points up axis at targetPos, and emits a particle system at targetKey.
// @param targetKey The UUID of the target to emit particles to.
// @param targetPos The poaition of the target in region-local coordinates.
pointAt(key targetKey, vector targetPos)
{
    SetLocalRot(getRotToPointAxisAt(AXIS_UP, targetPos));
    target = targetKey;
    startColor = llGetColor(-1);
    endColor = llGetColor(-1);
    updateParticles();
}
    

default {
    state_entry() {
        llParticleSystem([]);
        SetLocalRot(<0,0,0,1> );
    }
    link_message(integer sender, integer n, string parameters, key command) {
        if(command == "RESET") {
            SetLocalRot(<0,0,0,1> );
            llParticleSystem([]);
        }
        else if(command == "POINT_AT") {
            list parsedParameters = llParseString2List(parameters, [MESSAGE_PARAMETER_SEPERATOR], []);
            key targetKey = (key)llList2String(parsedParameters, 0);
            vector targetPos = (vector)llList2String(parsedParameters, 1);
            
            pointAt(targetKey, targetPos);
        }
    }
}
