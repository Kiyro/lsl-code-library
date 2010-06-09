// Free Rifle Script Secondary Fire
// Hold "down" and click the mouse button to use this.
// Version 1.0.1

float time_between_shots    =   5;
float velocity              =   50.0;
integer listen_channel      =   5;
vector offset               =   <.5,0,-.1>;
// +x = forward
// +y = left
// +z = up

// If you place a "secondary.fire.sound" sound in this guns' inventory, that sound will be used instead.
key fire_sound="e08ab712-7fea-f86c-faca-e4d5aa346f61";
// If you place a "secondary.recharge.sound" sound in this guns' inventory, that sound will be used instead.
key recharge_sound="f73c270b-177d-2d45-932f-6ad20a04830a";

// Script stuff, ignore this.
integer readyToFire=TRUE;
integer holstered=TRUE;
integer safety=TRUE;
integer desiredPerms;
integer has_perms=FALSE;
integer damage=100;

fire()
{
    if(!safety && readyToFire)
    {
        readyToFire=FALSE;
        string rezMe=llGetInventoryName(INVENTORY_OBJECT,0);
        if(llGetInventoryNumber(INVENTORY_OBJECT)>1)
            rezMe=llGetInventoryName(INVENTORY_OBJECT,1);
        llRezAtRoot(rezMe,llGetCameraPos() + offset*llGetCameraRot(), llRot2Fwd(llGetCameraRot())*velocity, llGetCameraRot(),damage);
        llPlaySound(fire_sound,1);
        
        llSetTimerEvent(time_between_shots);
    }
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
        llListen(listen_channel,"",llGetOwner(),"fire one");
        holstered=TRUE;
        readyToFire=TRUE;
        safety=TRUE;
        desiredPerms = (PERMISSION_TAKE_CONTROLS | PERMISSION_TRACK_CAMERA);
        if(llGetInventoryType("secondary.fire.sound")!=INVENTORY_NONE)
            fire_sound="secondary.fire.sound";
        if(llGetInventoryType("secondary.recharge.sound")!=INVENTORY_NONE)
            recharge_sound="secondary.recharge.sound";
            
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
        if(message=="safety")
        {
            safety=channel;
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
        if(safety || !readyToFire)
            return;
        
        if((start & CONTROL_ML_LBUTTON) && (held & CONTROL_DOWN))
        {
            fire();
        }        
    }
    
    timer()
    {
        readyToFire=TRUE;
        llTriggerSound(recharge_sound,1);
        llSetTimerEvent(0);
    }
}
