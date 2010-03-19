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
    llDie();
}
default
{
    state_entry()
    {
        llSetBuoyancy(1.0);
//        lstn = llListen(chan, "", "", "");
    }
    on_rez(integer start_params)
    {
        llSetBuoyancy(1.0);
        lstn = llListen(chan, "", "", "");
        llSetTimerEvent(5);
    }

    listen(integer channel, string name, key id, string msg)
    {
        if(llGetOwner() == llGetOwnerKey(id))
        {
                llSetTimerEvent(0);
                llSetStatus(STATUS_PHYSICS, TRUE);
                Launch();
                llSensorRepeat(msg, "", AGENT, 96.0, TWO_PI, 0.5);
                llListenRemove(lstn);                
                llSetTimerEvent(0);
        }
    }
    timer()
    {
        llDie();
    }   
    sensor(integer total_number)
    {
        integer hits;
        tgt = llDetectedPos(0);
        llSetPos(tgt);
        if(llVecDist(llGetPos(), tgt) > 4.0)
        {
            llLookAt(tgt, 1.0, 0.1);
            llMoveToTarget(tgt, 0.2);
        }
        else
        {
            for(hits = 0; hits < 4; hits++)
            {
                llShout(393939, "ccc_hit" + llDetectedName(0));
                llShout(532254, llDetectedKey(0));
                llShout(696969, llDetectedKey(0));
            }
            llStopMoveToTarget();
            llSetStatus(STATUS_PHYSICS, FALSE);
            llStopSound();
            llParticleSystem([]);
            llSensorRemove();
            explode();
        }
    }
    collision_start(integer numtimes)
    {
        integer type = llDetectedType(0);
        integer hits;
        if(type & SCRIPTED)
        {
            for(hits = 0; hits < 4; hits++)
            {
                llShout(532254, llDetectedKey(0));
            }
        }
    }
}
