// Free Rifle Script
// by Matthias Rozensztok

/// ====================
/// Gun Settings
/// ====================

integer clipSize =      50;
    // How many bullets you can fire before having to reload the gun.
    
float reloadTime =      3;
    // How many seconds it will take to reload the gun when it is out of ammo.

integer numRezSlaves =  1;
    // The number of "T3.Gun.free.rifle.rez" scripts in this gun.
    // Makes the ammo count correct.

float velocity =        115.0;
    // The forward velocity of the bullets as they are fired.
    // SL cannot move things faster than 200 meters per second.
    
integer auto =          TRUE;
    // Is the gun fully automatic? If so, you can fire repeatedly by holding down the mouse button.
    // If not, you must click each time to fire.

float accuracy =        0.2;
    //  How the bullets will spread out as they move. 0.1 is very little spread, 10 is a lot.
    //  LOWER is more accurate.
    
float rez_spread =      0.25;
    //  How the bullets will be spread out as they rez.
    //  You need about 0.1 per "rez slave" script to minimize bullet collisions.
    
vector rez_offset =     <0.6,.15,0>;
    // How far away from the center of your view in mouselook the bullets will rez.
    // +x = Forward
    // +y = Left
    // +z = Up
    
integer delay =         0;
    // Only matters if the gun is not automatic.
    // The number of seconds between shots.
    
integer listen_channel= 5;
    // A chat channel that the gun will listen to its owner for commands on.
    // Public chat will always work.
    
string reticleName="smg";
    // T3 Ultimate Reticle HUD API:
    // This is the reticle/crosshair to show for someone wearing the T3 Ultimate Reticle HUD.
    // Leave this blank and the weapon will not override the users' existing reticle.

/// ====================
/// Animations and Sounds
/// ====================

// To replace the animations and sounds, you can add the following inventory items to the gun:
// Otherwise, default animations and sounds will be used.

// ANIMATIONS:
//  reload.anim - when you're reloading
//  active.anim - when you're in mouselook
//  idle.anim - when you're not in mouselook

// SOUNDS:
//  reload.sound - plays when you reload
//  fire.sound - plays when you fire, loops if "auto" is TRUE
//  safety.sound - plays when you try to fire while the safety is on.

/// ====================
/// SCRIPT STUFF, you can ignore the stuff below this line.
/// ====================
integer has_perms=FALSE;
integer safety=FALSE;
integer listen_handle;
integer alt_listen_handle;
integer notext=FALSE;
integer activated;
integer deactivated;
integer ammoLeft;
integer holstered;
integer lastFireTime;
integer desiredPerms;
integer controlList;
float usevel;
integer useauto;
integer damage=100;
integer useclip;
integer reloading=FALSE;

string reload_anim="";
string reload_sound="ad01461e-a54c-43ba-61b8-bd289f6b7ebd";
string fire_sound="88026413-b829-0df2-0e57-8212227a652c";
string safety_sound="f1c12ed9-7f5c-cb7f-9741-b940715b7e7e";
string active_anim="aim_r_bazooka";
string idle_anim="hold_r_bazooka";

init()
{
    desiredPerms=(PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_TRACK_CAMERA);
    controlList=(CONTROL_ML_LBUTTON | CONTROL_DOWN | CONTROL_LEFT | CONTROL_ROT_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT);
    listen_handle=llListen(0,"",llGetOwner(),"");
    alt_listen_handle=llListen(listen_channel,"",llGetOwner(),"");
    safety=TRUE;
    notext=FALSE;
    ammoLeft=clipSize;
    lastFireTime=0;
    usevel=velocity;
    useauto=auto;
    useclip=clipSize;
    reloading=FALSE;
    
    request_permissions(llGetPermissions());
      
    
    if(llGetInventoryType("reload.anim")!=INVENTORY_NONE)
        reload_anim="reload.anim";
    if(llGetInventoryType("reload.sound")!=INVENTORY_NONE)
        reload_sound="reload.sound";
    if(llGetInventoryType("fire.sound")!=INVENTORY_NONE)
        fire_sound="fire.sound";
    if(llGetInventoryType("active.anim")!=INVENTORY_NONE)
        active_anim="active.anim";
    if(llGetInventoryType("idle.anim")!=INVENTORY_NONE)
        idle_anim="idle.anim";
    if(llGetInventoryType("safety.sound")!=INVENTORY_NONE)
        safety_sound="safety.sound";
    holster();
}

fire()
{
    if(safety)
    {
        llPlaySound(safety_sound,1);
        return;
    }
    if(!holstered && ammoLeft >0)
    {
        vector spreadVector = <(0-(rez_spread/2)) + llFrand(rez_spread),(0-(rez_spread/2)) + llFrand(rez_spread),(0-(rez_spread/2)) + llFrand(rez_spread)>;
        // We offset the rezzing randomly, within rez_spread

        rotation rotBetween=llRotBetween(<0.01,0.01,0.01>,<0.01,0.01,0.01>+(DEG_TO_RAD*accuracy*(spreadVector*llGetCameraRot())));
        // The rotation to look from DEAD CENTER to where we were rezzed...
        
        rotation modRot = llGetCameraRot() / <rotBetween.x*llPow(-1,llRound(llFrand(1))),rotBetween.y*llPow(-1,llRound(llFrand(1))),rotBetween.z*llPow(-1,llRound(llFrand(1))),rotBetween.s*llPow(-1,llRound(llFrand(1)))>;
        // We rotate to put us on a straight line in THAT direction.
        
        llRezAtRoot(llGetInventoryName(INVENTORY_OBJECT,0),llGetCameraPos() + (rez_offset + spreadVector)*llGetCameraRot(), llRot2Fwd(modRot)*usevel, modRot,damage);
 
        if(!auto)
        {
            lastFireTime=llGetUnixTime();
        }
        ammoLeft -= 1;
        
        if(auto && useauto)
            ammoLeft-=numRezSlaves;
        
        if(ammoLeft<0)
            ammoLeft=0;
        setFloating();
        if(ammoLeft<=0)
        {
            reload();
        }
        
    }
}

request_permissions(integer perm)
{
    has_perms=TRUE;
    if(perm != desiredPerms || llGetPermissionsKey() !=llGetOwner())
    {
        has_perms=FALSE;
        llRequestPermissions(llGetOwner(),desiredPerms);
    }else
    {
        llTakeControls(controlList,TRUE,TRUE);
    }  
}

string getTextString()
{
    if(safety)
        return "[ safety on ]";
        
    string textString="[ " + (string)ammoLeft + " / " + (string)useclip + " ]\n";
        
    if(auto)
    {
        if(useauto)
        {
            textString+="[ auto ]";
        }else
        {
            textString+="[ semi ]";
        }
    }
    
    return textString;
}  

setFloating()
{
    if(!notext)
    {
        vector floatColor=<255,255,255>;
        if(!safety)
        {
            floatColor=<41,219,0>;
            if(ammoLeft<=useclip/3)
            {
                floatColor=<219,216,0>;
            }else if(damage<100)
            {
                floatColor=<86,185,255>;
            }
        }
        llSetText(getTextString(),floatColor/255.0,1);
    }
}

holster()
{
    safe(TRUE);
    llListenRemove(listen_handle);
    listen_handle=llListen(0,"",llGetOwner(),"draw");
    llListenRemove(alt_listen_handle);
    alt_listen_handle=llListen(listen_channel,"",llGetOwner(),"draw");
    llSetTimerEvent(0);
    llSetLinkAlpha(LINK_SET,0,ALL_SIDES);
    holstered=TRUE;
    
    if(has_perms)
    {
        llStopAnimation(idle_anim);
        llStopAnimation(active_anim);
    }
    llSetText("",<1,1,1>,1);
    
}


draw()
{
    llMessageLinked(LINK_SET,0,"uroverride", reticleName);
    llListenRemove(listen_handle);
    listen_handle=llListen(0,"",llGetOwner(),""); 
    llListenRemove(alt_listen_handle);
    alt_listen_handle=llListen(listen_channel,"",llGetOwner(),"");  
    llSetTimerEvent(1);
    llSetLinkAlpha(LINK_SET,1,ALL_SIDES);
    deactivated=FALSE;
    holstered=FALSE;
    safe(FALSE);
}

safe(integer t)
{
    safety=t;
    llMessageLinked(LINK_SET,(integer)usevel,"velocity","");
    llMessageLinked(LINK_SET,0,"rez_spread",(string)rez_spread);
    llMessageLinked(LINK_SET,0,"accuracy",(string)accuracy);
    llMessageLinked(LINK_SET,0,"rez_offset",(string)rez_offset);
    if((auto && useauto) || (auto && !useauto && safety) || !auto)
        llMessageLinked(LINK_SET,safety,"safety","");
    llMessageLinked(LINK_SET,useauto,"auto","");
    llMessageLinked(LINK_SET,delay,"delay","");
    llMessageLinked(LINK_SET,damage,"damage","");
    setFloating();
}

reload()
{
    if(ammoLeft==useclip || reloading)
        return;
    reloading=TRUE;
    
    if(!notext)
        llSetText("[ reloading ]",<255,60,0>/255.0,1);
    llStopSound();
    llMessageLinked(LINK_SET,TRUE,"safety","");
    llPlaySound(reload_sound,1);
    if(has_perms && reload_anim!="")
    {
        llStartAnimation(reload_anim);
    }
    llSleep(reloadTime);
    ammoLeft=useclip;
    if(!(auto && !useauto))
        llMessageLinked(LINK_SET,FALSE,"safety","");
    setFloating();
    reloading=FALSE;
}

default
{
    state_entry()
    {
        init();
    }
    
    attach(key id)
    {
        if(id!=NULL_KEY)
        {
            init();
            llOwnerSay("Say 'draw' to draw me, then enter mouselook and click to fire.");
            
        }
    }
    
    run_time_permissions(integer perm)
    {
        request_permissions(perm);
    }
    
    listen(integer channgel, string name, key id, string message)
    {
        message==llToLower(message);
        if(message=="draw")
        {
            draw();
        }else if(message=="holster" || message=="holst" || message=="sling")
        {
            holster();
        }else if(message=="reload" || message=="r")
        {
            reload();
        }else if(message=="safe" || message=="safety" || message=="safety on")
        {
            safe(TRUE);
        }else if(message=="unsafe" || message=="nosafe" || message=="safety off")
        {
            safe(FALSE);
        }else if(message=="notext" || message=="textoff" || message=="text off" || message=="no text")
        {
            notext=TRUE;
            llSetText("",<1,1,1>,1);
        }else if(message=="text" || message=="texton" || message=="text on")
        {
            notext=FALSE;
            safe(safety);
        }else if(message=="damage" || message=="db" || message=="d")
        {
            llOwnerSay("Damage Bullet selected. Does 100 LL damage.");
            damage=100;
            llMessageLinked(LINK_SET,damage,"damage","");
            setFloating();
        }else if(message=="training" || message=="tb" || message=="t")
        {
            llOwnerSay("Training Bullet selected. Does 1 LL damage.");
            damage=1;
            llMessageLinked(LINK_SET,damage,"damage","");
            setFloating();
        }else if(message=="a" || message=="auto" || message=="automatic" || message=="full auto")
        {
            if(auto && !useauto)
            {
                useauto=TRUE;
                llOwnerSay("Full Automatic firing mode selected.");
                llMessageLinked(LINK_SET,FALSE,"safety","");
                setFloating();
            }
        }else if(message=="s" || message=="semi" || message=="semiauto" || message=="single")
        {
            if(auto && useauto)
            {
                useauto=FALSE;
                llOwnerSay("Semi-Automatic firing mode selected.");
                llMessageLinked(LINK_SET,TRUE,"safety","");
                setFloating();
            }
        }else if(message=="version")
        {
            llWhisper(0,llGetScriptName());
        }else
        {
            list parts = llParseString2List(message,[" ",".",":"],[]);
            string command = llList2String(parts,0);
            if(command=="vel" || command=="v" || command=="velocity")
            {
                integer newvel = (integer)llList2String(parts,1);
                if(newvel<=0)
                {
                    usevel=velocity;
                }else
                {
                    usevel = newvel;
                }
                llMessageLinked(LINK_SET,(integer)usevel,"velocity","");
                llOwnerSay("Velocity: " + (string)((integer)usevel));
            }else if(command=="ammo" || command=="clip" || command=="mag" || command=="m")
            {
                integer newclip = (integer)llList2String(parts,1);
                if(newclip<=clipSize && newclip>0)
                {
                    useclip=newclip;
                }else
                {
                    useclip=clipSize;
                }
                llOwnerSay("Magazine Size: " + (string)useclip + " rounds.");
                if(ammoLeft>useclip)
                    ammoLeft=useclip;
                
                setFloating();
            }
        }
    }
    
    control(key id, integer level, integer edge)
    {
        integer start = level & edge;
        integer end = ~level & edge;
        integer held = level & ~edge;
        integer untouched = ~(level | edge);
        
        if(!safety && ((held & CONTROL_LEFT) || (held & CONTROL_ROT_LEFT)) &&
                      ((held & CONTROL_RIGHT) || (held & CONTROL_ROT_RIGHT)) )
        {
            reload();
        }
        
        if(safety || (!auto && (llGetUnixTime()-lastFireTime)<delay ) )
            return;
        
        if((start & CONTROL_ML_LBUTTON) && (untouched & CONTROL_DOWN) )
        {
            if(useauto)
            {
                llLoopSound(fire_sound,1);
            }else
            {
                llTriggerSound(fire_sound,1);
            }
            fire();
        }
        if( (held & CONTROL_ML_LBUTTON) && useauto && (untouched & CONTROL_DOWN))
        {
            fire();
        }
        if(end & CONTROL_ML_LBUTTON && (untouched & CONTROL_DOWN))
        {
            if(useauto)
                llStopSound();
        }
        
        
        
    }
    
    changed(integer change)
    {
        if(change & CHANGED_OWNER)
        {
            llResetScript();
        }
    }

    timer()
    {
        if((llGetAgentInfo(llGetOwner()) & AGENT_MOUSELOOK) && !activated && !holstered)
        {
            llStopAnimation(idle_anim);
            llStartAnimation(active_anim);
            activated=TRUE;
            deactivated=FALSE;
        }
        else if(!(llGetAgentInfo(llGetOwner()) & AGENT_MOUSELOOK) && !deactivated && !holstered)
        {
            llStopAnimation(active_anim);
            llStartAnimation(idle_anim);
            deactivated=TRUE;
            activated=FALSE;
        }
    }
}