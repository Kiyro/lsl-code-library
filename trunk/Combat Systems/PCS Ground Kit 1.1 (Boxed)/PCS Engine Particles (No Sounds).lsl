string particle_texture = "particle_flameBlue2";
integer currentspeed = 0;

integer running = TRUE;
//float subage;
//float addage;
float maxage;

//Subroutines
start_particles()
{
    llParticleSystem([
    PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK 
| PSYS_PART_FOLLOW_SRC_MASK 
| PSYS_PART_FOLLOW_VELOCITY_MASK 
| PSYS_PART_EMISSIVE_MASK, 
                PSYS_PART_START_COLOR, <0.9,0.9,1.0>, PSYS_PART_END_COLOR, <0.0,0.0,1.0>,
                PSYS_PART_START_ALPHA, 0.0, PSYS_PART_END_ALPHA, 0.1, PSYS_PART_START_SCALE, <1.3,1.75,0.0>,
                PSYS_PART_END_SCALE, <0.1,0.1,0.0>, PSYS_PART_MAX_AGE, maxage, PSYS_SRC_PATTERN,
                PSYS_SRC_PATTERN_ANGLE_CONE, PSYS_SRC_INNERANGLE, 0.0, PSYS_SRC_OUTERANGLE, 0.0,
                PSYS_SRC_OMEGA, ZERO_VECTOR, PSYS_SRC_TEXTURE, particle_texture, PSYS_SRC_BURST_RATE, 0.1,
                PSYS_SRC_BURST_PART_COUNT, 3, PSYS_SRC_BURST_RADIUS, 0.0, PSYS_SRC_BURST_SPEED_MIN, 0.5,
                PSYS_SRC_BURST_SPEED_MAX, 0.7, PSYS_SRC_MAX_AGE, 0.0]);
}

stop_particles()
{
    llParticleSystem([]);
}

default
{
    state_entry()
    {
        //llStopSound();
        stop_particles();
        llMessageLinked(LINK_SET, 0, "jet", NULL_KEY);
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }

    link_message(integer src, integer num, string strnz, key id)
    {
        if ( strnz == "runup" )
        {
            maxage = 1.0;
            currentspeed = 0;
            start_particles();
        }
        if ( strnz == "runloop" )
        {            
            maxage = 1.0;
            currentspeed = 0;
            start_particles();
        }
        if (strnz == "THROTTLE")
        {
            if(num == 0)
            {
                currentspeed = num;
                maxage = 1.0;
            }
            else if(num > currentspeed)
            {
                currentspeed = num;
                ++maxage;
            }
            else if(num < currentspeed)
            {
                currentspeed = num;
                --maxage;
            }
            start_particles();
        }
        if ( strnz == "rundown" )
        {
            stop_particles();
            //maxage = 0.0;
        }
    }
}
