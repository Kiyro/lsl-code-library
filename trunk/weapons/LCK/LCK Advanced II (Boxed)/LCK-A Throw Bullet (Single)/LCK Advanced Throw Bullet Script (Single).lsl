vector color;

init()
{
    llSetPrimitiveParams([PRIM_PHANTOM, TRUE]);
    llListen(-169, "", "", "");
    llListen(-170, "", "", "");
}
warpPos( vector destpos) 
{
    integer jumps = (integer)(llVecDist(destpos, llGetPos()) / 10.0) + 1;
    if (jumps > 100 )
        jumps = 100;    //  1km should be plenty
    list rules = [ PRIM_POSITION, destpos ];  //The start for the rules list
    integer count = 1;
    while ( ( count = count << 1 ) < jumps)
        rules = (rules=[]) + rules + rules;   //should tighten memory use.
    llSetPrimitiveParams( rules + llList2List( rules, (count - jumps) << 1, count) );
    if ( llVecDist( llGetPos(), destpos ) > .001 ) //Failsafe
        while ( --jumps ) 
            llSetPos( destpos );
}
activate()
{
    llTargetOmega(<0,0,6>, 2, 1);
    llSetLinkAlpha(ALL_SIDES, 1, ALL_SIDES);
    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);                
    llMessageLinked(LINK_SET,0,"HIDE CAL",NULL_KEY);
    llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);            
    llMessageLinked(LINK_SET,0,"ON",NULL_KEY);
}
default
{
    state_entry()
    {
        init();
    }
    on_rez(integer start_param)
    {
        init();
    }
    sensor(integer num)
    {
        integer i;
        if(llVecDist(llGetPos(), llDetectedPos(0) + <0,0,0.2>) > 1.0)
        {
            warpPos(llDetectedPos(0) + <0,0,0.2>);
        }
        else
        {
            for(i = 0; i < 3; i++)
            {
                llRegionSay(696969, llDetectedKey(0));
            }
            llRezObject("RCS", llDetectedPos(0) + <0,0,5>, <0,0,-120>, ZERO_ROTATION, 0);
            llSleep(1);
            llRezObject("RCS", llDetectedPos(0) + <0,0,7.5>, <0,0,-120>, ZERO_ROTATION, 0);
            llSleep(1);
            llRezObject("RCS", llDetectedPos(0) + <0,0,10>, <0,0,-120>, ZERO_ROTATION, 0);
            llSleep(1);
            llDie();
        }
    }

    listen(integer chan, string name, key id, string msg)
    {
        if(llGetOwnerKey(id) == llGetOwner())
        {
            if(chan == -169)
            {
                activate();
                llSensorRepeat(msg, "", AGENT, 96, TWO_PI, 0.01);
            }
            else if(chan == -170)
            {
               llMessageLinked(LINK_SET,0,"COLOR " + msg, NULL_KEY);
            }

        }
    }
}
