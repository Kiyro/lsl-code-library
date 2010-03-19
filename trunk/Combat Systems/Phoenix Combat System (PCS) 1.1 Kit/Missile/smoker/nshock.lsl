start_particles()
{
    llParticleSystem([
    PSYS_PART_FLAGS, PSYS_PART_EMISSIVE_MASK | PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK | PSYS_PART_FOLLOW_VELOCITY_MASK | PSYS_PART_FOLLOW_SRC_MASK,
    PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
    PSYS_SRC_ANGLE_BEGIN, PI_BY_TWO,
    PSYS_SRC_ANGLE_END, PI_BY_TWO,
    PSYS_PART_START_SCALE, <3.5, 3.4, 3.5>,
    PSYS_PART_END_SCALE, <1.5, 1.75, 1.1>,
    PSYS_PART_START_ALPHA, 1.0,
    PSYS_PART_END_ALPHA, 0.01,
    PSYS_PART_START_COLOR, <1,1,1>,
    PSYS_PART_END_COLOR, <1,1,1>,
    PSYS_PART_MAX_AGE, 20.0,
    PSYS_SRC_TEXTURE, "fire2",
    PSYS_SRC_BURST_RATE, 0.05,
    PSYS_SRC_BURST_PART_COUNT, 25,
    PSYS_SRC_BURST_RADIUS, 0.0,
    PSYS_SRC_BURST_SPEED_MAX, 2.4,
    PSYS_SRC_BURST_SPEED_MIN, 2.1
    ]);
    llSleep(3.0);
    llDie();
}

stop_particles()
{
    llParticleSystem([]);
}

default
{
    state_entry()
    {
        start_particles();
        llSetAlpha(1,ALL_SIDES);
    }
    
    on_rez(integer num)
    {
        if ( num > 0 )
        {
            llSetTimerEvent(7);
            llSetAlpha(0,ALL_SIDES);
            start_particles();
        }
    }

    touch_start(integer total_number)
    {
        llSay(0, "Touched.");
    }
    
    timer()
    {
        llDie();
    }
}
