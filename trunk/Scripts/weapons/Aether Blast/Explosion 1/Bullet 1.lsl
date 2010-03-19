integer damage=30;
integer push=TRUE;

explode()
{
    llSetStatus(STATUS_PHYSICS,FALSE);
    llParticleSystem([]);
    llSetLinkPrimitiveParams(LINK_SET,[PRIM_COLOR,ALL_SIDES,<0,0,0>,0,PRIM_GLOW,ALL_SIDES,0]);
    if(!push)
        push=-1;
    llRezObject("Explosion 1", llGetPos(), ZERO_VECTOR, ZERO_ROTATION, push);
    if(damage>0)
        llRezObject("damage",llGetPos(),ZERO_VECTOR,ZERO_ROTATION,damage);
    llTriggerSound("d125e8cd-86c1-e5f5-900b-61cf848bbc4e", 1);
    llTriggerSound("645f0d59-fdfc-41d1-7598-50b61bb17730", 1);
    
    
    
}
default
{
    
    on_rez(integer sparam)
    {
        llLoopSound("electriccurrent",.5);
        if(sparam>0)
        {
            damage= sparam;
        }else if(sparam<0)
        {
            damage = (integer)llFabs(sparam);
            push=FALSE;
        }
        
        if(llFabs(sparam)>100)
        {
            damage=0;
        }
            
    }
    
    collision_start(integer n)
    {
          if(llKey2Name(llDetectedKey(0))!="damage")
          {
            explode();
            state done;
        }
      //  llDie();
    }
    
    land_collision_start(vector pos)
    {
       explode();
         state done;
      //  llDie();
    }
    
}

state done
{
    state_entry()
    {
        llSetTimerEvent(1);
    }
    
    timer()
    {
        llDie();
    }
}