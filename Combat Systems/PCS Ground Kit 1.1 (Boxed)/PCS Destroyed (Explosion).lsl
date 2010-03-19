start_particles()
{
    llParticleSystem([
    PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK | PSYS_PART_WIND_MASK,
    PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
    PSYS_SRC_TEXTURE, "05f956d5-9d9e-95a7-b39d-3dab596532a9",
    PSYS_SRC_ANGLE_BEGIN, 0.0,
    PSYS_SRC_ANGLE_END, TWO_PI,
    PSYS_PART_START_SCALE, <5.0, 5.0, 0>,
    PSYS_PART_END_SCALE, <5.0, 5.0, 0>,
    PSYS_PART_START_ALPHA, 0.6,
    PSYS_PART_END_ALPHA, 0.0,
    PSYS_PART_START_COLOR, <0,0,0>,
    PSYS_PART_END_COLOR, <0.25,0.25,0.25>,
    PSYS_PART_MAX_AGE, 20.5,
    PSYS_SRC_MAX_AGE, 0.0,
    PSYS_SRC_BURST_RATE, 0.1,
    PSYS_SRC_BURST_PART_COUNT, 10,
    PSYS_SRC_BURST_RADIUS, 0.5,
    PSYS_SRC_BURST_SPEED_MAX, 1.0,
    PSYS_SRC_BURST_SPEED_MIN, 0.2,
    PSYS_SRC_ACCEL, <0,0,1>
    
    ]);
}

stop_particles()
{
    llParticleSystem([]);
}

default
{
    state_entry()
    {
        stop_particles();
    }

    on_rez(integer n)
    {
        llResetScript();
    }
    
    link_message(integer src, integer num, string msg, key id)
    {
        if ( msg == "ccc_destroyed" )
        {
            llTriggerSound("34f3c286-c910-02a7-155d-c6290b364c93", 1.0);
            start_particles();
        }
        else if ( msg == "ccc_init" )
        {
            stop_particles();
        }
    }
}
