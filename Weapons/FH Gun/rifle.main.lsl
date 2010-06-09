string reload_sound="e5de9fb0-c4d5-4830-aa19-a57d864104c5";
string semiauto_sound="e9a17118-0fc2-e3c9-cf60-7d58d16b76c1";
string fullauto_sound="cec6d960-d580-9162-2d8d-88124ae4d9f8";
string firemodeswitch_sound="8532afcf-509e-113e-9b58-a81395d0c223";
string dryfire_sound="b38bdcc9-3a98-8875-da60-b4d1e6805796";
string deploy_sound="17ca1c1c-96a2-e966-1839-fd5d7abf4cdd";
//string initmessage = "M4 Carbine built by Griffin Yeats";
//string semiauto_silencedsound="7f4a1b73-7b30-b5b4-5f8c-b43162f06fe6";
//string fullauto_silencedsound="6a8368b6-e207-1ed8-8b0c-ea71289a37bd";
key owner;
string reloading_anim="Reload";
integer gotperms = FALSE;
integer dialoglistenhandle;
integer listenhandle;
integer firingmode;
string bulletname = "Training Bullet";

integer safe = TRUE;
integer reloading;
integer settext = TRUE;
list main_menu = ["bullet","firemode","safe","nosafe","reload","options","unholst","holst","help"];
list firemode_menu = ["auto","single","back..."];
list bullet_menu = ["training","damage","push","phantom","back..."];

list option_menu = ["texton","textoff","reset","back..."];

DoSetText()
{
    integer ammo = (integer)llGetObjectDesc();
    string text;
    string safety;
    if(ammo < 0)
    {
        ammo = 0;
    }
    if(safe) 
    {
        safety = "On";
    }
    else 
    {
        safety = "Off";
    }
    text = llGetObjectDesc() + "\n" + "Safety:" + safety;
    if(settext)
    {
        llSetText(text,<1,1,1>,1.0);
    }
    else
    {
        llSetText("",<0,0,0>,0.0);
    }
}    
Dialog(key id,list menu,string text)
{
    llDialog(id,text,menu,25);
}
Rez(string what,integer passed)
{
    llMessageLinked(LINK_SET,passed,what,(string)firingmode);
}       
Init()
{
    gotperms = FALSE;
    if(owner != llGetOwner())
    {
        NewOwner();
    }
    else
    {
        GetPerms(llGetOwner());
        llMessageLinked(LINK_SET,-5,"silenceroff",NULL_KEY);
//        silenced = FALSE;
        llWhisper(6666,"invisible " + (string)llGetOwner());
        //llInstantMessage(llGetOwner(),initmessage);
        llListen(0,"",llGetOwner(),"");
        llListen(25,"",llGetOwner(),"");
        DoSetText();
    }
}
NewOwner()
{
    owner = llGetOwner();
    firingmode = 1;
    //bulletname = "Training Bullet";
    listenhandle = llListen(0,"",owner,"");
    llMessageLinked(LINK_SET,-5,"lookforupdate",NULL_KEY);
    GetPerms(owner);
    Reload();
    Init();
}
GetPerms(key id)
{
    llRequestPermissions(id,PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH);
    
}
Reload()
{
    if(settext)
    {
        llSetText("Reloading",<1,0,0>,1.0);
    }
    llStopSound();
    //llResetOtherScript("rifle.rez4");
    llMessageLinked(LINK_SET,-1,"reload",NULL_KEY);
    llSetObjectDesc("900");
    llStartAnimation(reloading_anim);
    //Rez("default clip",0);
    llSleep(1);
    llTriggerSound(reload_sound,0.8);
    reloading = FALSE;
    DoSetText();
}     
Fire()
{    
    integer ammo = (integer)llGetObjectDesc();
    if(!safe && !reloading)
    {
        if(ammo > 0)
        {
            Rez(bulletname,10000);
            if(firingmode == 1)
            {
                llTriggerSound(semiauto_sound,1.0);
            }
            if(firingmode == 3)
            {
                llTriggerSound(fullauto_sound,1.0);
            }
            DoSetText();
        }
        else if (reloading != TRUE && ammo <= 0)
            {
                reloading = TRUE;
               // Reload();
            }
    }
}
default
{
    state_entry()
    {
        if(owner != llGetOwner())
        {   
            NewOwner();
        }
    }
        
    attach(key id)
    {
        if(id != NULL_KEY)
        {
            //llSetScriptState("rifle.perms",TRUE);
            Init();
        }
        else
        {
            //llSetScriptState("rifle.perms",FALSE);
            llWhisper(6666,"visible " + (string)llGetOwner());
            //llStopAnimation("hold_r_rifle");
            llReleaseControls();
        }
    }
    control(key id,integer held,integer change)
    {
        integer pressed = held & change;
        integer down = held & ~change;
        integer released = ~held & change;
        integer inactive = ~held & ~change;
        
        if(pressed & CONTROL_ML_LBUTTON)
        {
            if(firingmode==1 && !safe && !reloading)
            {  
                Fire();
            }
            if(firingmode==3 && !safe && !reloading)
            {
                Fire();
            }
        }
        if(released & CONTROL_ML_LBUTTON)
        {
            if(firingmode==2) Fire();
            llStopSound();
            llResetOtherScript("rifle.rez");
            llResetOtherScript("rifle.rez2");
            llResetOtherScript("rifle.casings");
            llResetOtherScript("rifle.casings2");
            if(reloading)
            {
                Reload();
            }
        }
        if(down & CONTROL_ML_LBUTTON)
        {
            if(firingmode==2 & !reloading) 
            {
                Fire();
            }
            if(firingmode==2 && !safe && !reloading)
            {
                //if(silenced)
                //{
                //    llLoopSound(fullauto_silencedsound,1.0);
                //}
                //else
                //{
                    llLoopSound(fullauto_sound,1.0);
                //}
            }       
        }
        if(pressed || down & CONTROL_ML_LBUTTON)
        {
            if(reloading)
            {
                llStopSound();
                llTriggerSound(dryfire_sound,1.0);
            }
        }
    }
    listen(integer channel,string name,key id,string message)
    {
        
        list args = llParseString2List(llToLower(message),[" "],[]);
        if (id == llGetOwner())
        {
            if(llList2String(args,0) == "back...")
            {
                Dialog(id,main_menu,"main menu");
            }
            if(llList2String(args,0) == "help")
            {
                llGiveInventory(llGetOwner(),"help");
            }
            if(llList2String(args,0) == "options")
            {
                Dialog(id,option_menu,"Options");
            }
            if(llList2String(args,0) == "resetgun")
            {
                llOwnerSay("Resetting Scripts...");
                llResetOtherScript("rifle.casings");
                llResetOtherScript("rifle.rez");
                llResetOtherScript("rifle.rez2");
                llResetScript();
            }
            if(llList2String(args,0) == "texton")
            {
                llOwnerSay("SetText Enabled");
                settext = TRUE;
                DoSetText();
            }
            if(llList2String(args,0) == "textoff") 
            {
                llOwnerSay("SetText Disabled");
                settext = FALSE;
                DoSetText();
            }
            if(llList2String(args,0) == "bullet")
            {
                Dialog(id,bullet_menu,"Bullet Menu");
            }
            if(llList2String(args,0) == "effectson")
            {
                llOwnerSay("Special Effects on - clipfall/bulletcasings");
                llSetScriptState("rifle.casings",TRUE);
                llSetScriptState("rifle.casings2",TRUE);
                llMessageLinked(LINK_SET,-5,"effectson",NULL_KEY);
            }
            if(llList2String(args,0) == "effectsoff")
            {
                llOwnerSay("Special Effects off");
                llSetScriptState("rifle.casings",FALSE);
                llSetScriptState("rifle.casings2",FALSE);
                llMessageLinked(LINK_SET,-5,"effectsoff",NULL_KEY);
            }
            if(llList2String(args,0) == "firemode")
            {
                Dialog(id,firemode_menu,"Firing Mode Menu");
            }
            if(llList2String(args,0) == "reload")
            {
                Reload();
            }
            if(llList2String(args,0) == "auto")
            {
                llTriggerSound(firemodeswitch_sound,0.5);
                llOwnerSay("Auto Firingmode Selected");
                firingmode = 2;
            }
            if(llList2String(args,0) == "single")
            {
                llTriggerSound(firemodeswitch_sound,0.5);
                llOwnerSay("Single Firingmode Selected");
                firingmode = 1;
            }
            if(llList2String(args,0) == "training")
            {
                llTriggerSound(firemodeswitch_sound,0.5);
                llOwnerSay("Training Bullet Selected. Causes 1 Dmg");
                bulletname = "Training Bullet";
            }
            if(llList2String(args,0) == "damage")
            {
                llTriggerSound(firemodeswitch_sound,0.5);
                llOwnerSay("Damage Bullet Selected, Causes 100 Dmg");
                bulletname = "Damage Bullet";
            }
            if(llList2String(args,0) == "phantom")
            {
                llTriggerSound(firemodeswitch_sound,0.5);
                llOwnerSay("Phantom Bullet Selected, Goes through walls and shields easily.");
                bulletname = "Phantom Bullet";
            }
            if(llList2String(args,0) == "push")
            {
                llTriggerSound(firemodeswitch_sound,0.5);
                llOwnerSay("Push Bullet Selected, Pushes av a good distance.");
                bulletname = "Push Bullet";
            }
            if(llList2String(args,0) == "safe")
            {
                llTriggerSound(firemodeswitch_sound,0.5);
                llOwnerSay("Safety On");
                safe = TRUE;
            }
            if(llList2String(args,0) == "nosafe")
            {
                llTriggerSound(firemodeswitch_sound,0.5);
                llOwnerSay("Safety Off");
                safe = FALSE;
            }
            if(llList2String(args,0) == "unholst")
            {
                safe = FALSE;
                //settext = TRUE;
                llSetScriptState("rifle.anims",TRUE);
                llWhisper(6666,"invisible " + (string)llGetOwner());
                llSetLinkAlpha(LINK_SET,1.0,ALL_SIDES);
            }
            if(llList2String(args,0) == "holst")
            {
                safe = TRUE;
                settext = FALSE;
                llSetScriptState("rifle.anims",FALSE);
                llStopAnimation("rifle.anim.standing");
                llStopAnimation("rifle.anim.aim");
                llWhisper(6666,"visible " + (string)llGetOwner());
                llSetLinkAlpha(LINK_SET,0.0,ALL_SIDES);
            }
       }
       DoSetText();
       llListenControl(dialoglistenhandle,FALSE);
    }      
    touch_start(integer total_number)
    {
        if(llDetectedKey(0) == llGetOwner())
        {
            Dialog(llDetectedKey(0),main_menu,"Main Menu");
        }
    }
    on_rez(integer start_params)
    {
        GetPerms(llGetOwner());
    }
    run_time_permissions(integer perm)
    {
        llAttachToAvatar(ATTACH_RHAND);
        llTakeControls(CONTROL_ML_LBUTTON | CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT,TRUE,TRUE);
        gotperms = TRUE;
    }
}