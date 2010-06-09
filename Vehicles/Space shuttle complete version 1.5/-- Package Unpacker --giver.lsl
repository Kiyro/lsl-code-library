list    gInventoryList;

list getInventoryList()
{
    integer    i;
    integer    j;
    integer    n = llGetInventoryNumber(INVENTORY_ALL);
    list          result = [];
    string msg = "";

    for( i = 0; i < n; i++ ) {
        if (llGetInventoryName(INVENTORY_ALL, i) != llGetScriptName()) {
            for (j = 0; j < n; j++) {
                msg += "|";
            }
            llSetText("Unpacking...\n" + msg, <0.2, 0.3, 1.0>, 1.0);
            result += [ llGetInventoryName(INVENTORY_ALL, i) ];
            llSleep(1);
        }
    }
    return result;
}

transporter()
{
    // Particles Script by Zachh Barkley
    llParticleSystem([  PSYS_PART_MAX_AGE, 1.600000,
        PSYS_PART_FLAGS, 259,
        PSYS_PART_START_COLOR, <1.00000, 1.000, 1.00000>,
        PSYS_PART_END_COLOR, <1.00000, 1.00000, 1.00000>,
        PSYS_PART_START_SCALE, <1.0000, 1.00000, 0.00000>,
        PSYS_PART_END_SCALE, <0.10000, 0.10000, 0.0000>,
        PSYS_SRC_PATTERN, 2,
        PSYS_SRC_BURST_RATE,0.001000,
        PSYS_SRC_ACCEL,<0.00000, 0.00000, 0.00000>,
        PSYS_SRC_BURST_PART_COUNT,2,
        PSYS_SRC_BURST_RADIUS,0.000000,
        PSYS_SRC_BURST_SPEED_MIN,1.100000,
        PSYS_SRC_BURST_SPEED_MAX,0.700000,
        PSYS_SRC_INNERANGLE,3.141593,
        PSYS_SRC_OUTERANGLE,6.283185,
        PSYS_SRC_OMEGA,<0.00000, 0.00000, 0.00000>,
        PSYS_SRC_MAX_AGE,0.000000,
        PSYS_PART_START_ALPHA,1.000000,
        PSYS_PART_END_ALPHA,1.000000,
        PSYS_SRC_TEXTURE, "Star Gold",
        PSYS_SRC_TARGET_KEY,(key)"" ]);
}

default 
{
    on_rez(integer p)
    {
        llResetScript();
    }

    state_entry()
    {
        llSetAlpha(0.0, ALL_SIDES);
        llSetText("", <1,1,1>, 1.0);

        llTriggerSound("432c7407-aedd-c7c7-214f-898a24035c35", 1.0);
        transporter();
        llSleep(1.5);
        llParticleSystem([]);
        llSetAlpha(1.0, ALL_SIDES);
        llSetTimerEvent(.5);
       
 
 float   rANDOM;
 float   total;
 rANDOM  = llFrand(100);
 total = 1 / rANDOM;
 llSetText("Your purchase is inside.\nTouch to receive contents. It will be put in a folder in your inventory.\n Don't search in your object file.\n If you have problem, \nopen the box manually and drag and drop the product", < total+.4 , total + .8  , total +.4  >, 1.0);
}
    touch_start( integer n )
    {
        if (llGetOwner() == llDetectedKey(0)) {
            integer i;

            llSetText("Unpacking...", <0.6, 0.6, 1.0>, 1.0);
            gInventoryList = getInventoryList();
            for (i = 0; i < n; i++) {
                llGiveInventoryList(llDetectedKey(i), llGetObjectName(), gInventoryList );
            }
            llSetAlpha(0.0, ALL_SIDES);
            llTriggerSound("432c7407-aedd-c7c7-214f-898a24035c35", 1.0);
            transporter();
            llSleep(1.5);
            llParticleSystem([]);
            llDie();
        }
    }

    changed( integer change )
    {
       if ( change == CHANGED_INVENTORY )
           gInventoryList = getInventoryList();
    }

}