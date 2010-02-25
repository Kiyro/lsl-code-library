integer running = FALSE;
//Subroutines
start_particles()
{
    llParticleSystem([
    PSYS_PART_FLAGS, PSYS_PART_EMISSIVE_MASK | PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK,
    PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE,
    PSYS_SRC_ANGLE_BEGIN, 0.0,
    PSYS_SRC_ANGLE_END, 0.0,
    PSYS_PART_START_SCALE, <0.5, 0.5, 0.0>,
    PSYS_PART_END_SCALE, <5.0, 5.0, 0.0>,
    PSYS_PART_START_ALPHA, 1.0,
    PSYS_PART_END_ALPHA, 0.0,
    PSYS_PART_START_COLOR, <0.2,0.7,1.0>,
    PSYS_PART_END_COLOR, <1.0,1.0,1.0>,
    PSYS_PART_MAX_AGE, 2.0,
    PSYS_SRC_MAX_AGE, 0.2,
    PSYS_SRC_BURST_RATE, 0.1,
    PSYS_SRC_BURST_PART_COUNT, 10,
    PSYS_SRC_BURST_RADIUS, 0.1,
    PSYS_SRC_BURST_SPEED_MAX, 150.0,
    PSYS_SRC_BURST_SPEED_MIN, 120.0
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
        llStopSound();
        stop_particles();
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }

    link_message(integer src, integer num, string msg, key id)
    {
        if ( msg == "ccc_on" )
        {
            running = TRUE;
        }
        else if ( msg == "ccc_off" )
        {
            running = FALSE;
        }
        else if (msg == "fire" && running)
        {
            start_particles();
            llPlaySound("a5a9b068-da12-fe81-2e78-a1148879c71c", 1.0);
        }
        else if ( msg == "cease fire" )
        {
            stop_particles();
        }
    }
}
