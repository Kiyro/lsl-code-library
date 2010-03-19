// VICE destructible barrel
// by Creem Pye 3/13/2008 
// This barrel demonstrates the weaker type of target (normal bullets can damage it)
// If you would like to change some of the damage parameters, please edit the "VICE Destructable Object Config" notecard

integer floating_text=TRUE;  // whether to have floating text to display HP.  Set this to FALSE if you don't want floating text...
integer crashed=FALSE;
integer vice_hp=1;
integer max_vice_hp=1;
integer vice_deaths=0;

updateText()
{
    if(crashed) llSetText("Destroyed!",<1.0,1.0,1.0>,1.0);
    else llSetText((string)vice_hp+" HP\n\n\n\n",<1.0,1.0,1.0>,1.0);
}

default
{
    on_rez(integer reznum)
    {
        llResetScript();
    }
    state_entry()
    {
        llSay(0,"VICE test target.  See http://vicecombat.com for more information.\nCheck out the full-perm '"+llGetScriptName()+"' script to see how you can implement VICE in your own destructible VICE targets!");
        llCollisionSound("",0.0);  // because the default collision sound is lame
        llSetText("",<1.0,1.0,1.0>,1.0);
        llParticleSystem([]);
        // unexploded color and shape:
        llSetColor(<1.0,1.0,1.0>,ALL_SIDES);
        llSetPrimitiveParams([PRIM_TYPE,1, 0, <0.0,1.0, 0.0>, 0.0, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0,0.0,0.0>]);
        llSleep(1.0);
        // for a noncombatant, this is sufficient for enabling VICE:
        llMessageLinked(LINK_SET,TRUE,"vice ctrl","");
        //In case we want this to join a team:
        //llSleep(0.5);
        //llMessageLinked(LINK_SET,1,"vice team",""); // join team 1
    }
    
    link_message(integer sender_num, integer num, string msg, key id)
    {
        if(msg=="vice stats")
        {
            vice_deaths=(num>>20)&4095;
            vice_hp=num&1048575;
            if(vice_hp>max_vice_hp) max_vice_hp=vice_hp;
            if(floating_text) updateText();
            // I'm not doing anything with vice_deaths, but let's have the barrel smoke slightly when it's at <50% health:
            if(!crashed && vice_hp/((float)max_vice_hp)<0.5)
            {
                llParticleSystem([
                    PSYS_PART_FLAGS,            PSYS_PART_FOLLOW_VELOCITY_MASK|PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_WIND_MASK,
                    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
                    PSYS_SRC_ANGLE_BEGIN,       0.0,
                    PSYS_SRC_ANGLE_END,         PI/6.0,
                    PSYS_PART_START_COLOR,      <28, 26, 21>/255.0,
                    PSYS_PART_END_COLOR,        <63.75, 63.75, 63.75>/255.0,
                    PSYS_PART_START_ALPHA,      0.3,
                    PSYS_PART_END_ALPHA,        0.0,
                    PSYS_PART_START_SCALE,      <2.0,2.0,0.0>,
                    PSYS_PART_END_SCALE,        <4.0,4.0,0.0>,    
                    PSYS_PART_MAX_AGE,          4.0,
                    PSYS_SRC_ACCEL,             <0, 0, 1.0>,
                    PSYS_SRC_TEXTURE,           "05f956d5-9d9e-95a7-b39d-3dab596532a9",
                    PSYS_SRC_BURST_RATE,        0.25,
                    PSYS_SRC_BURST_PART_COUNT,  5,      
                    PSYS_SRC_BURST_SPEED_MIN,   0.075,
                    PSYS_SRC_BURST_SPEED_MAX,   0.75, 
                    PSYS_SRC_MAX_AGE,           0.0,
                    PSYS_SRC_BURST_RADIUS,      0.1
                ]);
            }
        }
        else if(msg=="crash")
        {
            crashed=num;
            if(crashed)  // crashing
            {
                // blacken it and make it smoke:
                llTriggerSound("04d7b598-6488-09c6-cba3-504d19137d87",1.0);
                llSetColor(<60,60,60>/255.0,ALL_SIDES);
                llParticleSystem([
                    PSYS_PART_FLAGS,            PSYS_PART_FOLLOW_VELOCITY_MASK|PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_WIND_MASK,
                    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
                    PSYS_SRC_ANGLE_BEGIN,       0.0,
                    PSYS_SRC_ANGLE_END,         PI/6.0,
                    PSYS_PART_START_COLOR,      <10, 10, 10>/255.0,
                    PSYS_PART_END_COLOR,        <63.75, 63.75, 63.75>/255.0,
                    PSYS_PART_START_ALPHA,      1.0,
                    PSYS_PART_END_ALPHA,        0.0,
                    PSYS_PART_START_SCALE,      <2.0,2.0,0.0>,
                    PSYS_PART_END_SCALE,        <4.0,4.0,0.0>,    
                    PSYS_PART_MAX_AGE,          4.0,
                    PSYS_SRC_ACCEL,             <0, 0, 1.0>,
                    PSYS_SRC_TEXTURE,           "05f956d5-9d9e-95a7-b39d-3dab596532a9",
                    PSYS_SRC_BURST_RATE,        0.25,
                    PSYS_SRC_BURST_PART_COUNT,  25,      
                    PSYS_SRC_BURST_SPEED_MIN,   0.075,
                    PSYS_SRC_BURST_SPEED_MAX,   0.75, 
                    PSYS_SRC_MAX_AGE,           0.0,
                    PSYS_SRC_BURST_RADIUS,      0.1
                ]);
                llSetPrimitiveParams([PRIM_TYPE,1, 0, <0.04992, 1.0, 0.0>, 0.0, <-0.05, 0.05, 0.0>, <1.4, 0.75, 0.0>, <0.0, -0.1, 0.0>]);
                //llSay(0,"Ouch! "+llKey2Name(id)+" that hurt!");
            }
            else // uncrashing
            {
                llParticleSystem([]);
                // unexploded color and shape:
                llSetColor(<1.0,1.0,1.0>,ALL_SIDES);
                llSetPrimitiveParams([PRIM_TYPE,1, 0, <0.0,1.0, 0.0>, 0.0, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0,0.0,0.0>]);
            }
        }
    }
    
    changed(integer change)
    {
        if(change&CHANGED_INVENTORY)  // the sensor script resets in this case, so this one should reset too
        {
            llSleep(2.0);
            llResetScript();
        }
    }
}
