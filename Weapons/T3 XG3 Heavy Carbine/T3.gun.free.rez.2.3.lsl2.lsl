// Free Rifle Script Rez Slave
// by Matthias Rozensztok
// version 1.1
integer safety;
integer desiredPerms;
float velocity;
integer has_perms=FALSE;
float accuracy;
float rez_spread;
vector rez_offset=<0,0,0>;
integer auto=TRUE;
integer lastFireTime;
integer delay;
integer damage=100;

fire()
{
    
    if(safety)
    {
        return;
    }
    
    vector spreadVector = <(0-(rez_spread/2)) + llFrand(rez_spread),(0-(rez_spread/2)) + llFrand(rez_spread),(0-(rez_spread/2)) + llFrand(rez_spread)>;
        // We offset the rezzing randomly, within rez_spread

    rotation rotBetween=llRotBetween(<0.01,0.01,0.01>,<0.01,0.01,0.01>+(DEG_TO_RAD*accuracy*(spreadVector*llGetCameraRot())));
        // The rotation to look from DEAD CENTER to where we were rezzed...
        
    rotation modRot = llGetCameraRot() / <rotBetween.x*llPow(-1,llRound(llFrand(1))),rotBetween.y*llPow(-1,llRound(llFrand(1))),rotBetween.z*llPow(-1,llRound(llFrand(1))),rotBetween.s*llPow(-1,llRound(llFrand(1)))>;
        // We rotate to put us on a straight line in THAT direction.
        
    llRezObject(llGetInventoryName(INVENTORY_OBJECT,0),llGetCameraPos() + (rez_offset + spreadVector)*llGetCameraRot(), llRot2Fwd(modRot)*velocity, modRot,damage);

    lastFireTime=llGetUnixTime();
}

request_permissions(integer perm)
{
    has_perms=TRUE;
    if((perm != desiredPerms) || (llGetPermissionsKey()!=llGetOwner()) )
    {
        has_perms=FALSE;
        llRequestPermissions(llGetOwner(),desiredPerms);
    }else
    {
        has_perms=TRUE;
        llTakeControls(CONTROL_ML_LBUTTON | CONTROL_DOWN | CONTROL_LEFT | CONTROL_ROT_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT,TRUE,TRUE);
        }
}

default
{
    
    state_entry()
    {
        desiredPerms=PERMISSION_TAKE_CONTROLS | PERMISSION_TRACK_CAMERA;
        lastFireTime=0;
        request_permissions(llGetPermissions());
    }
    
    attach(key id)
    {
        if(id!=NULL_KEY)
        {
            request_permissions(llGetPermissions());
        }
    }
    
    run_time_permissions(integer perm)
    {
        request_permissions(perm);
    }
    
    link_message(integer sender, integer channel, string message, key id)
    {
        if(message=="velocity")
        {
            velocity=channel;
        }else if(message=="safety")
        {
            safety=channel;
        }else if(message=="rez_spread")
        {
            rez_spread = (float) ((string)id) ;
        }else if(message=="accuracy")
        {
            accuracy = (float) ((string)id) ;
        }else if(message=="rez_offset")
        {
            rez_offset=(vector) ((string)id);
        }else if(message=="auto")
        {
            auto=channel;
        }else if(message=="delay")
        {
            delay = channel;
        }else if(message=="damage")
        {
            damage=channel;
        }
    }
    
    control(key id, integer level, integer edge)
    {
        integer start = level & edge;
        integer end = ~level & edge;
        integer held = level & ~edge;
        integer untouched = ~(level | edge);
        
        if(safety || (!auto && (llGetUnixTime() - lastFireTime)<delay) )
            return;
        
        if((start & CONTROL_ML_LBUTTON) && (untouched & CONTROL_DOWN))
        {
            fire();
        }
        if((held & CONTROL_ML_LBUTTON) && auto && (untouched & CONTROL_DOWN))
        {
            fire();
        }
       
        
    }
}
