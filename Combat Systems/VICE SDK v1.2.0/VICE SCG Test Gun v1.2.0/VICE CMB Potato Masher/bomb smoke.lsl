key dropsound = "d40b4b01-8ca7-7745-7dfe-31be9df67d43";
key collisionsound = "06621924-d03f-7551-11e7-c34d05063abb";

explode()
{
    vector mypos=llGetPos();
    if(mypos.z > llWater(ZERO_VECTOR))  // only "detonate" above water
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
    }   
    on_rez(integer reznum)
    {
        llParticleSystem([]);
        if(reznum!=0)
        {
            llPlaySound(dropsound, 1.0);
            llApplyRotationalImpulse(<0,0.025,0>,TRUE);
            llSleep(3.0);
            explode();
        }
    }    
}