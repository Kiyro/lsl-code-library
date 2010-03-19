particles()
    {
        llSetAlpha(1.0, ALL_SIDES);
    llParticleSystem([
    PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK, 
    PSYS_PART_START_COLOR, <.2,.2,.2>, 
    PSYS_PART_START_ALPHA, 1.0, 
    PSYS_PART_END_COLOR, <.4,.4,.4>, 
    PSYS_PART_END_ALPHA, 0.0, 
    PSYS_PART_START_SCALE, <11,12,10>, 
    PSYS_PART_END_SCALE, <12,12,10>, 
    PSYS_PART_MAX_AGE, 0.5,
    PSYS_SRC_ACCEL, <0.00,0.00,0.00>, 
    PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
    PSYS_SRC_BURST_RATE, 0.0,
    PSYS_SRC_BURST_PART_COUNT, 30, 
    PSYS_SRC_BURST_RADIUS, 1.0, 
    PSYS_SRC_BURST_SPEED_MIN, 4.00, 
    PSYS_SRC_BURST_SPEED_MAX, 4.30, 
    PSYS_SRC_MAX_AGE, 0.0, 
    PSYS_SRC_TEXTURE, "d1df5743-efa9-8fab-0d2f-8c206931299b",
    PSYS_SRC_OMEGA, <0.00,0.00,0.00>
    ]);
}
default
{
    state_entry()
    {
       particles();
       llSetAlpha(0,ALL_SIDES);
    }
    on_rez(integer param)
    {
        if(param)
        {
        particles();
        llSleep(.2);
        llDie();
        }
    }
}
