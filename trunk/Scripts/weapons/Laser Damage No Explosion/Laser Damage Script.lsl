integer damage;
string jectile;

explode(vector v, string object)
{
    //llSetStatus(STATUS_PHYSICS,FALSE);
    //llParticleSystem([]);
    llSetLinkPrimitiveParams(LINK_SET,[PRIM_COLOR,ALL_SIDES,<0,0,0>,0,PRIM_GLOW,ALL_SIDES,0]);
    //llRezObject("Explosion 1", v, ZERO_VECTOR, ZERO_ROTATION, 1);
    if(damage>0)
        llRezObject(object,v,ZERO_VECTOR,ZERO_ROTATION,damage);
    //llTriggerSound("d125e8cd-86c1-e5f5-900b-61cf848bbc4e", 1);
    //llTriggerSound("645f0d59-fdfc-41d1-7598-50b61bb17730", 1);
    
    
    
}

default
{
    state_entry()
    {
        //llVolumeDetect(TRUE);
        llSetStatus(STATUS_DIE_AT_EDGE,TRUE);
        llSetBuoyancy(.998);
        llSetLinkAlpha(LINK_SET,0,ALL_SIDES);
        llCollisionSound("",1);
    }

    on_rez(integer t)
    {
        damage=t;
        llSetDamage(t);
        jectile = llGetInventoryName(INVENTORY_OBJECT,0);
        llSetBuoyancy(.998);
        if(damage!=0)
            llSetTimerEvent(.33);
        if(damage<0)
        {
            llSetDamage(0);
        }
    }
    
    collision_start(integer num)
    {
        llSetStatus(STATUS_PHYSICS,FALSE);
        integer c=0;
        key id;
        string name;
        for(c=0;c<num;c++)
        {
            id = llDetectedKey(c);
            name=llKey2Name(id);
            if(name!="damage" && name!="Blue Laser" && name!="Explosion 1")
            {
                if(llDetectedType(c)==AGENT)
                {
                    explode((vector)llList2String(llGetObjectDetails(llDetectedKey(c),[OBJECT_POS]),0 ),"damage avatar");
                }else
                {
                    explode(llGetPos(),"damage");
                }
            }
        }
        llSleep(.25);
        llDie();
    }
    
    land_collision(vector t)
    {
        explode(t,"damage");
    }
    
    timer()
    {
        llDie();
    }
}
