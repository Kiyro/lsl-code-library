key collisionsound = "04d7b598-6488-09c6-cba3-504d19137d87";
integer exploded=FALSE;

explode()
{
    vector mypos=llGetPos();
    if(mypos.z>llWater(ZERO_VECTOR))  // only "explode" above water... otherwise die
    {
        llMessageLinked(LINK_SET,0,"explode","");
        llTriggerSound(collisionsound, 1.0);   
        llParticleSystem([
            PSYS_PART_FLAGS,            PSYS_PART_FOLLOW_VELOCITY_MASK|PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_WIND_MASK,
            PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_EXPLODE,
            PSYS_PART_START_COLOR,      <28, 26, 21>/255.0,
            PSYS_PART_END_COLOR,        <63.75, 63.75, 63.75>/255.0,
            PSYS_PART_START_ALPHA,      1.0,
            PSYS_PART_END_ALPHA,        0.0,
            PSYS_PART_START_SCALE,      <4,4,0.0>,
            PSYS_PART_END_SCALE,        <4,4,0.0>,    
            PSYS_PART_MAX_AGE,          8.0,
            PSYS_SRC_ACCEL,             <0, 0, 0.05>,
            PSYS_SRC_TEXTURE,           "05f956d5-9d9e-95a7-b39d-3dab596532a9",
            PSYS_SRC_BURST_RATE,        0.25,
            PSYS_SRC_BURST_PART_COUNT,  50,      
            PSYS_SRC_BURST_SPEED_MIN,   0.075,
            PSYS_SRC_BURST_SPEED_MAX,   2.5, 
            PSYS_SRC_MAX_AGE,           0.0,
            PSYS_SRC_BURST_RADIUS,      3.1
        ]);
    }
    llSleep(4.0);
    llDie();
}
    
default
{
    state_entry()
    {
        llParticleSystem([]);
        llSetBuoyancy(0.9);
        exploded=FALSE;
    }   
    on_rez(integer null)
    {
        llParticleSystem([]);
        exploded=FALSE;
        llSetBuoyancy(0.9);
        llSetForce(<3.0,0.0,0.0>,TRUE);
        
        
    }  
    collision(integer detected)
    {
        if(llToLower(llGetSubString(llDetectedName(0),0,3))!="vice" && ! exploded)
        {
            explode();
            exploded=TRUE;
        }
    }
    land_collision(vector pos)
    {
        explode();
        exploded=TRUE;
    }
}