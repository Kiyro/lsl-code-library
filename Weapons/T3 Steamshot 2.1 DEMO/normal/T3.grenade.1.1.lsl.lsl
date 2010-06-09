integer damage=30;
integer push=TRUE;

explode()
{
    llSetStatus(STATUS_PHYSICS,FALSE);
    llMessageLinked(LINK_SET,damage,"BNWCS AoE","5");
    if(damage>0)
    {
        llSensor("",NULL_KEY,AGENT,5,PI);
    }
    llRezObject("explosion", llGetPos(), ZERO_VECTOR, ZERO_ROTATION, push);
    integer c=0;
    integer s=llGetInventoryNumber(INVENTORY_SOUND);
    for(c=0;c<s;c++)
    {
        llTriggerSound(llGetInventoryName(INVENTORY_SOUND,c),1);
    }
    
    
}
default
{
    state_entry()
    {
        llSetBuoyancy((float)llGetObjectDesc());
        llSetStatus(STATUS_ROTATE_X,FALSE);
        llSetStatus(STATUS_ROTATE_Y,FALSE);
        llSetStatus(STATUS_ROTATE_Z,FALSE);
        llSetAlpha(0,ALL_SIDES);
    }
    
    on_rez(integer sparam)
    {
        damage=sparam;
    }
    
    collision_start(integer n)
    {
        explode();
    }
    
    land_collision_start(vector pos)
    {
       explode();
    }
    
    sensor(integer t)
    {
        integer c=0;
        
        for(c=0;c<t;c++)
        {
            llRezObject("killprim",(vector)llList2String(llGetObjectDetails(llDetectedKey(c),[OBJECT_POS]),0),ZERO_VECTOR,ZERO_ROTATION,damage);
        }
        llDie();
    }
    
    no_sensor()
    {
        llDie();
    }
    
}