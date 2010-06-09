string name;
integer chan = 2000;
vector tgt;
integer blah;
integer lstn;

Launch()
{
      llLoopSound("rocket-transit", 2.0);
    llParticleSystem([
        PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK,
        
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,
        
        PSYS_PART_START_COLOR, <1, 1, 1>,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_START_SCALE, <.1, .1, 0>,
        PSYS_PART_END_SCALE, <.25, .25, 0>,
        PSYS_PART_END_ALPHA, 0.0,
        
        PSYS_SRC_BURST_RATE, .01,
        PSYS_SRC_BURST_PART_COUNT, 150,
        
        PSYS_SRC_TEXTURE, "smoke",
        
        PSYS_PART_MAX_AGE, 3.0
    ]);
}
explode()
{
    llTriggerSound("exp1", 10.0);
    llTriggerSound("exp2", 10.0);
    llTriggerSound("exp3", 10.0);
    llTriggerSound("qwk1", 10.0);
    llRezObject("flareburst", llGetPos() + <0,0,0>, ZERO_VECTOR, ZERO_ROTATION, 1);
    llRezObject("smoker", llGetPos() + <0,0,0>, ZERO_VECTOR, ZERO_ROTATION, 1);
    llRezObject("lineplasma", llGetPos() + <0,0,0>, ZERO_VECTOR, ZERO_ROTATION, 1);
    llRezObject("smoke1", llGetPos() + <0,0,0>, ZERO_VECTOR, ZERO_ROTATION, 1);
    llRezObject("smoke2", llGetPos() + <0,0,0>, ZERO_VECTOR, ZERO_ROTATION, 1);
    llRezObject("Glow", llGetPos() + <0,0,0>, ZERO_VECTOR, ZERO_ROTATION, 1);
    llRezObject("smoke3", llGetPos() + <0,0,0>, ZERO_VECTOR, ZERO_ROTATION, 1);
    llTriggerSound("qwk1", 10.0);
    llTriggerSound("qwk1", 10.0);
}
default
{
    state_entry()
    {
        llSetBuoyancy(1.0);
        llStopSound();
//        lstn = llListen(chan, "", "", "");
    }
    on_rez(integer start_params)
    {
        llSetBuoyancy(1.0);
        llSetStatus(STATUS_PHYSICS, TRUE);
        Launch();
    }

    sensor(integer total_number)
    {
        integer i;
        integer j;
        llSetStatus(STATUS_PHYSICS, FALSE);
        llStopSound();
        explode();
        for(i = 0; i < total_number; i++)
        {
            if(llDetectedType(i) & AGENT)
            {
                llShout(696969, llDetectedKey(i));
                llShout(393939, "ccc_hit" + llDetectedName(i));
                llShout(393939, "ccc_hit" + llDetectedName(i));
                llShout(393939, "ccc_hit" + llDetectedName(i));
            }
            else
            {
                llShout(696969, (string)llDetectedKey(i) + "M");
            }
        }
        llParticleSystem([]);
        llSensorRemove();
        llSetTimerEvent(5);
    }
    no_sensor()
    {
        llSetStatus(STATUS_PHYSICS, FALSE);
        llStopSound();
        explode();
        llSetTimerEvent(5);
    }

    collision_start(integer numtimes)
    {
        llSensor("", "", AGENT | ACTIVE, 30, TWO_PI);
    }
    land_collision_start(vector vec)
    {
        llSensor("", "", AGENT | ACTIVE, 30, TWO_PI);
    }
    timer()
    {
        llDie();
    }
}
