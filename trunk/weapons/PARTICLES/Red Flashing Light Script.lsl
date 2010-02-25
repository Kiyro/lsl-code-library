// Creates slow, red, flashing light effect.

default {
    state_entry() {
        llParticleSystem
        ([
            PSYS_PART_FLAGS,
            PSYS_PART_INTERP_COLOR_MASK|
            PSYS_PART_FOLLOW_SRC_MASK|
            PSYS_PART_EMISSIVE_MASK, PSYS_SRC_PATTERN,
            PSYS_SRC_PATTERN_ANGLE_CONE,
            PSYS_SRC_INNERANGLE, 0.0,
            PSYS_SRC_OUTERANGLE, 0.1,
            PSYS_SRC_BURST_SPEED_MIN, 0.0,
            PSYS_SRC_BURST_SPEED_MAX, 0.0,
            PSYS_SRC_BURST_RADIUS, 0.0,
            PSYS_SRC_BURST_PART_COUNT, 5,
            PSYS_SRC_BURST_RATE, 1.0,
            PSYS_PART_MAX_AGE, 1.0,
            PSYS_PART_START_SCALE, <1,1,1>,
            PSYS_PART_START_COLOR, <1,0.2,0.2>,
            PSYS_PART_END_COLOR, <1,0,0>,
            PSYS_PART_START_ALPHA, 1.0,
            PSYS_PART_END_ALPHA, 0.0
        ]);
    }
}
