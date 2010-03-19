default
{
    // Waits for another script to send a link message.
    link_message(integer sender_num, integer num, string str, key id)
    {
        list input = llParseString2List(str, [" "], []);
        string command = (string)llList2List(input, 0, 0);
        key detkey = (string)llList2List(input, 1, 1);
        if (command == "particles")
        {
            llParticleSystem([PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE,
            PSYS_PART_START_ALPHA, 1.0,
            PSYS_PART_END_SCALE, <0.5,0.5,0.5>,
            PSYS_PART_START_SCALE, <0.01,0.01,0.01>,
            PSYS_PART_START_COLOR, <0.1,0.1,0.7>,
            PSYS_PART_END_COLOR, <1.0,1.0,1.0>,
            PSYS_PART_MAX_AGE, 5.0,
            PSYS_SRC_BURST_RATE, .04,
            PSYS_SRC_BURST_RADIUS, 0.2,
            PSYS_SRC_ANGLE_END, 130.2,
                        PSYS_SRC_BURST_PART_COUNT, 3,
            PSYS_SRC_TARGET_KEY, detkey, 
            PSYS_PART_FLAGS, PSYS_PART_TARGET_POS_MASK | PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_EMISSIVE_MASK | PSYS_PART_INTERP_SCALE_MASK,
            PSYS_SRC_ACCEL, <0,-2,1>]);

            
        }   else    {
            llParticleSystem([]);
            llResetScript();
        }
                   
    }
}
