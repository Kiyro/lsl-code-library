//**********************
//LoLSBS Gun Scripts V6.1
//**********************
//This script is designed to be used with the Lance of Longinus Shield Breaker system ONLY.


//**************
//Change History
//**************
//
//V5.0
//Rebuilt the entire script from scratch. Woo!
//
//V5.1
//Fixed a bug where only one shot would be fired from a burst if the script had FIRINGDELAY set above 0.
//
//Fixed a bug where rotation calculations would be reset when the gun was worn again.
//
//5.2
//Fixed a bug where some guns would not open the menu when their holster was clicked.
//
//Added a "Reload" menu and voice command.
//
//5.3
//Fixed a bug where guns could still be reloaded while holstered, causing an odd effect for guns using a reload animation.
//
//5.4
//Fixed a few bugs that let people turn on some features via voice commands when they were turned off by the gun maker.
//
//6.0
//Changed the script to use the dialog system by Nargus Asturias. This will fix the 11 bullet limit, fix the problem with bullet names being too long, and just simplify things in general.
//
//Adjusted the rez position of bullets to help prepare for new 3rd party bullets.
//
//Re-added the "Reset" command by request.
//
//Added case insensitive bullet loading for voice commands.
//
//Added option to change default voice command channel in the setup portion of the script, also added a voice command for the user to change the voice command channel.
//
//Added bullet speed adjustement menu and voice commands.
//
//6.1
//Fixed a bug with holstering and unholstering.


//*****
//SETUP
//*****

//***************
//General Options
//***************

string FIRESOUND = "";  //Type the name of the sound that plays when the gun is fired between the quotation marks, leave blank to not play a sound.

string ANIMATION = ""; //Type the name of the animation you would like to use between the quotation marks. If this is left blank, the default animation will be used.

//Built in animations:
//hold_r_handgun
//hold_r_rifle
//hold_r_bazooka
//For a list of internal animations, visit http://wiki.secondlife.com/wiki/Internal_Animations

integer MULTIBULLET = TRUE; //Set this to TRUE to enable Multi-Bullet mode. This allows the user to load more bullets in to the gun, and change them through the guns menu. NOTE: This option requires a loader ball in the guns inventory, unless you are customizing the script yourself.

integer EFFECTS = TRUE; //Set this to TRUE to enable muzzle flashes and other special effects.

float FIRINGDELAY = 0.5; //Set this to delay you would like the gun to wait after firing to fire again, set to 0 to disable the delay.

integer HOLSTER = TRUE; //Set this to TRUE to enable holstering, or FALSE to disable it.

integer VOICECHAN = 0; //set this to the default channel used for voice commands. For example, if this is set to 2, and the user wants to open the ammo menu, they will then say /2 ammo

list EXCEPTIONS = ["Loader", "Shell"]; //This is a list of objects that will not be included in the ammo menu if you have MULTIBULLET enabled. If you have any extra objects in the guns inventory, include them in this list.

//*******************
//Firing Mode Options
//*******************

integer FULLAUTO = TRUE; //Set this to TRUE to enable Full Auto, or FALSE to disable it.

integer BURST = TRUE; //Set this to TRUE to enable Burst firing mode, or FALSE to disable it.

//*****************
//Reloading Options
//*****************

integer RELOAD = TRUE; //Set this to TRUE to enable reloading.

integer CLIPSIZE = 10; //If reloading is enabled, this sets the number of bullets before the gun has to reload.

float RELOADTIME = 1.0; //This is how long reloading takes in seconds.

string RELOADANIMATION = ""; //This is the animation that will be played when the gun reloads. Leave this blank to not play an animation.

string RELOADSOUND = ""; //This is the sound that will be played when the gun reloads. Leave this blank to not play a sound.

//**********************
//Shell Ejection Options
//**********************

integer SHELLEJECTION = TRUE; //Set this to TRUE to enable shell ejection, and FALSE to disable it. NOTE: If shell ejection is enabled, a menu option will be shown in the guns menu to turn it off and on as the user wishes.

string SHELLNAME = "Shell"; //Set this to the name of the shell you would like to use if SHELLEJECTION is enabled. Make sure to add this shell to the guns inventory, and add the name to the exceptions list.

vector SHELLPOS = <0, 0, 1>; //This is the relative starting position the shell will be rezzed at.

vector SHELLVEL = <0, 0, 1>; //This is the relative velocity of the shell when it is ejected.

vector SHELLROT = <0, 0, 0>; //This is the relative rotation of the shell when it is ejected.

//*********************************************************************************************

//DO NOT EDIT BELOW THIS POINT UNLESS YOU KNOW WHAT YOU'RE DOING!
















//Global Variables
integer gEffects = FALSE; //This turns on and off shell ejection and the linked message "fire" command.
integer gAttached = FALSE; //Are we attached?
integer gPermissions = FALSE; //Do we have permissions yet?
vector gOffset; //This is the offset for the bullet rezzing.
list gBullets; //The bullets currently in the gun.
string gBulletName = "Bullet"; //The currently selected bullet.
string gFireMode = "single"; //The currently selected firing mode.
integer gBulletSpeed = 100;
integer gRBullets = CLIPSIZE; //The remaining number of bullets in the clip.
integer gReloading = FALSE; //Are we reloading?
integer gHolstered = FALSE; //Are we holstered?
integer gL1;
integer gL2;
integer gL3;
integer gRandomC;
integer gFireCount; // This is used to track which fire and shell script to use.
integer gHolsterChan = -873145; //This is the channel we use to communicate with holsters and other objects. If this is changed, you must change it in the holster scripts also.
integer gVoiceChan = VOICECHAN; //The voice command channel can be changed by the user, so we store it in a global variable.




//Dialog system by Nargus Asturias
// Dialog constants
integer lnkDialog = 14001;
integer lnkDialogNotify = 14004;
integer lnkDialogResponse = 14002;
integer lnkDialogTimeOut = 14003;

integer lnkDialogReshow = 14011;
integer lnkDialogCancel = 14012;

string seperator = "||";
integer dialogTimeOut = 0;

// ********** DIALOG FUNCTIONS **********
string packDialogMessage(string message, list buttons, list returns){
    string packed_message = message + seperator + (string)dialogTimeOut;
    
    integer i;
    integer count = llGetListLength(buttons);
    for(i=0; i<count; i++){
        string button = llList2String(buttons, i);
        if(llStringLength(button) > 24) button = llGetSubString(button, 0, 23);
        packed_message += seperator + button + seperator + llList2String(returns, i);
    }

    return packed_message;
}

dialogReshow(){llMessageLinked(LINK_THIS, lnkDialogReshow, "", NULL_KEY);}
dialogCancel(){
    llMessageLinked(LINK_THIS, lnkDialogCancel, "", NULL_KEY);
    llSleep(1);
}

dialog(key id, string message, list buttons, list returns){
    llMessageLinked(LINK_THIS, lnkDialog, packDialogMessage(message, buttons, returns), id);
}

dialogNotify(key id, string message){
    list rows;
   
    llMessageLinked(LINK_THIS, lnkDialogNotify,
        message + seperator + (string)dialogTimeOut + seperator,
        id);
}
// ********** END DIALOG FUNCTIONS **********








//Initializes our script
init()
{
    //Adjust the bullet offset to fire bullets from eye level.
    vector size = llGetAgentSize(llGetOwner());
    gOffset.z = (size.z / 2.0);
    llListenRemove(gL1);
    llListenRemove(gL2);
    llListenRemove(gL3);
    
    //Used for holsters and other object communications.
    gL1 = llListen(gHolsterChan, "", NULL_KEY, "");
    
    //Used for listening for voice commands.
    gL2 = llListen(gVoiceChan, "", llGetOwner(), "");
    
    
    gRandomC = -((integer)llFrand(100000) + 10000);
    
    //This is the random channel used for the loader ball
    if (MULTIBULLET)
    {
        gL3 = llListen(gRandomC, "", NULL_KEY, "");
    }
    
    //Check to make sure the shell is in the gun if we're using shell ejection.
    if(SHELLEJECTION && (llGetInventoryType(SHELLNAME) != INVENTORY_OBJECT))
    {
        llOwnerSay("Could not find shell named " + SHELLNAME + ". Disabling shell ejection!");
        SHELLEJECTION = FALSE;
    }
    
    
    //Set gEffects
    if (EFFECTS || SHELLEJECTION)
    {
        gEffects = TRUE;
    }
    
    llReleaseControls();
    llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH);
    if (FIRESOUND != "")
    { 
        llPreloadSound(FIRESOUND);
    }
    
    if (RELOADSOUND != "")
    {
        llPreloadSound(RELOADSOUND);
    }
    
    //Load bullets.
    gBullets = [];
    integer i;
    integer max = llGetInventoryNumber(INVENTORY_OBJECT);
    
    for (i = 0; i < max; i ++)
    {
        string cName = llGetInventoryName(INVENTORY_OBJECT, i);

        //If this inventory item isn't in the exceptions list...
        if (llListFindList(EXCEPTIONS, [cName]) == -1)
        {
            gBullets += [cName];
        }
    }
}


//Ejects a shell. Based on work by Nynthan Folsom
ejectShell(vector iPos, rotation iRot, integer iParam)
{
    vector tForward = llRot2Fwd(iRot);  // Forward vector in global coords
    vector tLeft = llRot2Left(iRot);    // Left vector in global coords
    vector tUp = llRot2Up(iRot);        // Up vector in global coords 
    vector tShellPos = iPos + 
          (SHELLPOS.x * tForward)
        + (SHELLPOS.y * tLeft)
        + (SHELLPOS.z * tUp);           // Transform the starting position to global coords
    vector tShellVel =
          (SHELLVEL.x * tForward)
        + (SHELLVEL.y * tLeft)
        + (SHELLVEL.z * tUp);           // Transform the starting velocity to global coords
        
    rotation tShellRot = llEuler2Rot(SHELLROT * DEG_TO_RAD) * iRot;
                                        // Transform the origin to global rotation
    list variables = [SHELLNAME, tShellPos, tShellVel, tShellRot, iParam];
    llMessageLinked(LINK_SET, gFireCount + 10, llList2CSV(variables), NULL_KEY);
}

//Fires a bullet
fire()
{
    if (!gHolstered)
    {
        if (((!RELOAD) || (!gReloading)) && ((!RELOAD) || (gRBullets > 0)))
        {
            if (RELOAD)
            {
                gRBullets--;
            }
            
            //Gets our position data.
            rotation rot = llGetRot();
            vector fwd = llRot2Fwd(rot);
            //We add fwd to pos to offset the bullet rezzing position infront of the user by 1 meter. This helps prevent bullets from colliding with the user.
            vector pos = llGetPos() + gOffset + fwd;
            fwd *= 5;
            
            if (llGetInventoryType(gBulletName) == -1)
            {
                llOwnerSay(gBulletName + " could not be found. Please select a new bullet.");
            }
            else
            {
                if (FIRESOUND != "")
                {
                    llTriggerSound(FIRESOUND, 1.0);
                }
                
                //We only have 3 firing and shell rezzing scripts so...
                if (gFireCount > 3) gFireCount = 1;
                list variables = [gBulletName, pos, fwd, rot, gBulletSpeed];
                llMessageLinked(LINK_SET, gFireCount, llList2CSV(variables), NULL_KEY);

                //Sends the effects message and ejects a shell, if effects are turned on by user.
                if (gEffects)
                {
                    if (EFFECTS)
                    {
                        llMessageLinked(LINK_SET, 0, "fire", NULL_KEY);
                    }
                    
                    if (SHELLEJECTION)
                    {
                        ejectShell(pos, rot, 100);
                    }
                }
                
                gFireCount++;
                
            }
        }
        else if (!gReloading)
        {
            //Start reloading
            if ((RELOADANIMATION != "") && (gPermissions))
            {
                llStartAnimation(RELOADANIMATION);
            }
            if (RELOADSOUND != "")
            {
                llTriggerSound(RELOADSOUND, 1.0);
            }
            gReloading = TRUE;
            gRBullets = CLIPSIZE;
            llSetTimerEvent(RELOADTIME);
        }
    }
}

//Displays the guns menu.
displayMenu()
{
    if (RELOAD || FULLAUTO || BURST || MULTIBULLET || HOLSTER)
    {
        list dialog;
        list dialogReturns;
        
        if (RELOAD && !gHolstered)
        {
            dialog += ["Reload"];
            dialogReturns += ["Reload"];
        }
        
        if (FULLAUTO || BURST)
        {
            dialog += ["Fire Modes"];
            dialogReturns += ["Fire Modes"];
        }
        
        if (MULTIBULLET)
        {
            dialog += ["Ammo", "Loader"];
            dialogReturns += ["Ammo", "Loader"];
        }
        
        if (HOLSTER)
        {
            if (gHolstered)
            {
                dialog += ["Unholster"];
                dialogReturns += ["Unholster"];
            }
            else
            {
                dialog += ["Holster"];
                dialogReturns += ["Holster"];
            }
        }
        
        if (EFFECTS || SHELLEJECTION)
        {
            if (gEffects)
            {
                dialog += ["Effects Off"];
                dialogReturns += ["Effects Off"];
            }
            else
            {
                dialog += ["Effects On"];
                dialogReturns += ["Effects On"];
            }
        }
        
        dialog += ["Speed", "Reset"];
        dialogReturns += ["Speed", "Reset"];
        
        dialog(llGetOwner(), "Please make a selection.", dialog, dialogReturns);
    }
}

//This function parses dialog and voice commands.
doCommand(string message)
{
    string lMessage = llToLower(message);
    if ((lMessage == "ammo") && (MULTIBULLET))
    {
        list bulletButtons;
        integer i;
        integer max = llGetListLength(gBullets);
        
        if (max > 0)
        {
            for (i = 0; i < max; i ++)
            {
                //Prevent names that are too long for the dialog.
                string cName = llList2String(gBullets, i);
                if (llStringLength(cName) > 10)
                {
                    bulletButtons += [(llGetSubString(cName, 0, 9))];
                }
                else
                {
                    bulletButtons += [cName];
                }
            }
            
            dialog(llGetOwner(), "Please select your ammunition. Select \"List Ammo\" for a verbal list of all loaded ammunition.", ["List Ammo"] + bulletButtons, ["List Ammo"] + gBullets);
        }
        else
        {
            llOwnerSay("Sorry, but you do not appear to have any bullets loaded.");
        }
    }
    else if (lMessage == "list ammo" && MULTIBULLET)
    {
        integer i;
        integer max = llGetListLength(gBullets);
        
        for (i = 0; i < max; i ++)
        {
            //Prevent names that are too long for the dialog.
            llOwnerSay(llList2String(gBullets, i));
        }
        llOwnerSay("To load a bullet, simply say its name, or use the \"Ammo\" menu.");
    }
    else if (lMessage == "reload" && !gHolstered && RELOAD)
    {
        //Start reloading
        if ((RELOADANIMATION != "") && (gPermissions))
        {
            llStartAnimation(RELOADANIMATION);
        }
        if (RELOADSOUND != "")
        {
            llTriggerSound(RELOADSOUND, 1.0);
        }
        gReloading = TRUE;
        gRBullets = CLIPSIZE;
        llSetTimerEvent(RELOADTIME);
    }
    else if ((lMessage == "fire modes") && (FULLAUTO || BURST))
    {
        list dialog = ["Single"];
        list dialogReturns = ["Single"];
        if (FULLAUTO)
        {
            dialog += ["Full Auto"];
            dialogReturns += ["Full Auto"];
        }
        
        if (BURST)
        {
            dialog += ["Burst"];
            dialogReturns += ["Burst"];
        }
        
        dialog(llGetOwner(), "Please select a fire mode.", dialog, dialogReturns);
    }
    else if (lMessage == "single" || (lMessage == "full auto" && FULLAUTO)
    || (lMessage == "burst" && BURST))
    {
        gFireMode = lMessage;
        llOwnerSay(llToUpper(message) + " Firing mode has been activated");
    }
    else if((lMessage == "holster") && (HOLSTER) && (!gHolstered))
    {
        llSetLinkAlpha(LINK_SET, 0.0, ALL_SIDES);
        gHolstered = TRUE;
        
        llStopAnimation(ANIMATION);
        
        llSay(gHolsterChan, "holster" + (string)llGetOwner());
    }
    else if((lMessage == "unholster") && (HOLSTER) && (gHolstered))
    {
        llSetLinkAlpha(LINK_SET, 1.0, ALL_SIDES);
        llMessageLinked(LINK_SET, 0, "unh", NULL_KEY);
        
        gHolstered = FALSE;
        llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
        
        llStartAnimation(ANIMATION);
        
        llSay(gHolsterChan, "unholster" + (string)llGetOwner());
    }
    else if ((lMessage == "loader") && (MULTIBULLET))
    {
        //Here we rez the loader object. The rez param is the random channel we will use to communicate with it.
        llRezObject("Loader", llGetPos() + <0,0,2>, ZERO_VECTOR, ZERO_ROTATION, gRandomC);
    }
    else if (((lMessage == "effects on") || (lMessage == "effects off")) && (EFFECTS || SHELLEJECTION))
    {
        if (lMessage == "effects on")
        {
            gEffects = TRUE;
            llOwnerSay("Effects on!");
        }
        else
        {
            gEffects = FALSE;
            llOwnerSay("Effects off!");
        }
    }
    else if (llGetSubString(lMessage, 0, 4) == "speed")
    {
        //The user is changing the bullet speed. This number will be used as the start param when firing bullets, and sets the bullet speed percentage.
        if (llStringLength(lMessage) > 5)
        {
            integer speed = (integer)llDeleteSubString(lMessage, 0, 5);
            if (speed > 0)
            {
                gBulletSpeed = speed;
            }
            else
            {
                gBulletSpeed = 100;
            }
            llOwnerSay("Bullet speed has been set to " + (string)gBulletSpeed + " percent. Say \"speed #\", where # is the speed percentage, to change the bullet speed.");
        }
        else
        {
            dialog(llGetOwner(), "Please select a bullet speed. You can also change bullet speed by saying \"speed #\", where # is the speed percentage.", ["150%", "175%", "200%", "75%", "100%", "125%", "25%", "50%"], ["speed 150", "speed 175", "speed 200", "speed 75", "speed 100", "speed 125", "speed 25", "speed 50"]);
        }
    }
    else if (lMessage == "reset")
    {
        llOwnerSay("Reseting main gun script.");
        llResetScript();
    }
    else if (lMessage == "menu")
    {
        displayMenu();
    }
    else if (llGetSubString(lMessage, 0, 6) == "channel")
    {
        //Change the voice command channel
        gVoiceChan = (integer)llDeleteSubString(lMessage, 0, 7);
        llListenRemove(gL2);
        gL2 = llListen(gVoiceChan, "", llGetOwner(), "");
        
        
        llOwnerSay("Voice command channel has been set to " + (string)gVoiceChan + ". Say \"channel #\" on channel " + (string)gVoiceChan + ", where # is the new channel, to change it. All voice commands must now be made through this channel.");
    }
    else
    {
        //Case insensitive bullet loading.
        integer i;
        integer max = llGetListLength(gBullets);
        integer continue = TRUE;
        
        if (max > 0)
        {
            while (continue)
            {
                string cName = llList2String(gBullets, i);
                if (lMessage == llToLower(cName))
                {
                    gBulletName = cName;
                    llOwnerSay(cName + " is now loaded.");
                    continue = FALSE;
                }
                
                i++;
                if (i >= max)
                {
                    continue = FALSE;
                }
            }
        }
    }
}

default
{
    state_entry()
    {
        llOwnerSay("Voice command channel has been set to " + (string)gVoiceChan + ". Say \"channel #\" on channel " + (string)gVoiceChan + ", where # is the new channel, to change it. All voice commands must now be made through this channel.");
        init();
    }

    on_rez(integer start_param)
    {
        init();
    }
    
    run_time_permissions(integer perm)
    {
        if (perm > 0)
        {
            //We got permissions to do stuff.
            gPermissions = TRUE;
            llAttachToAvatar(ATTACH_RHAND);
            
            //Check to make sure the loaded bullet is there.
            if (llGetInventoryType(gBulletName) == -1)
            {
                llOwnerSay(gBulletName + " could not be found. Please select a new bullet.");
            }
            
            //Take control of mouselook.
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            
            //Start up our animation if we aren't holstered.
            if (!gHolstered)
            {
                if (ANIMATION == "")
                {
                    ANIMATION = "hold_r_handgun";
                }
                
                llStartAnimation(ANIMATION);
            }
        }
    }
    
    attach(key id)
    {
        if (id != NULL_KEY)
        {
            //We are attached.
            gAttached = TRUE;
        }
    }
    
    //Here we catch mouse clicks and fire the weapon.
    control(key id, integer level, integer edge) 
    {
        if((level & CONTROL_ML_LBUTTON) && (edge & CONTROL_ML_LBUTTON))
        {
            if (gFireMode == "single")
            {
                fire();
                llSleep(FIRINGDELAY);
            }
            else if (gFireMode == "burst")
            {
                integer x;
                for(x = 0; x < 3; x++)
                {
                    fire();
                    llSleep(FIRINGDELAY);
                }
            }
        }
        
        if((level & CONTROL_ML_LBUTTON) && !(edge & CONTROL_ML_LBUTTON))
        {
            if (gFireMode == "full auto")
            {
                fire();
                llSleep(FIRINGDELAY);
            }
        }
    }
    
    //Now we'll set up the menu.
    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            displayMenu();
        }
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        //This means that the user selected a dialog option.
        if(num == lnkDialogResponse)
        {
            //So we send the option they selected to the doCommand function.
            doCommand(str);
        }
    }
    
    //Here we handle voice commands amd communication with the loader system.
    listen(integer channel, string name, key id, string message)
    {
        if (id == llGetOwner())
        {
            //Parse the voice command.
            doCommand(message);
        }
        else if ((channel == gRandomC) && (name == "Loader" + (string)llGetOwner()) && (MULTIBULLET))
        {
            //This is all for the loader system
            if (message == "Connect")
            {
                integer i;
                integer max = llGetInventoryNumber(INVENTORY_OBJECT);
                
                for (i = 0; i < max; i ++)
                {
                    string cName = llGetInventoryName(INVENTORY_OBJECT, i);
        
                    //If this inventory item isn't in the exceptions list...
                    if (llListFindList(EXCEPTIONS, [cName]) == -1)
                    {
                        llGiveInventory(id, cName);
                    }
                }
                
                llSay(gRandomC, "Connected" + (string)llGetOwner());
            }
            else if (message == "Readyload" + (string)llGetOwner())
            {
                //This deletes bullets in the guns inventory before the loader gives it new ones
                integer i;
                integer max = llGetInventoryNumber(INVENTORY_OBJECT);
                
                for (i = max - 1; i >= 0; i --)
                {
                    string cName = llGetInventoryName(INVENTORY_OBJECT, i);
        
                    //If this inventory item isn't in the exceptions list...
                    if (llListFindList(EXCEPTIONS, [cName]) == -1)
                    {
                        llRemoveInventory(cName);
                    }
                }
                
                //AllowInventoryDrop lets the loader put bullets in
                llAllowInventoryDrop(TRUE);
                llSay(gRandomC, "Ready" + (string)llGetOwner());
            }
            else if (message == "Done" + (string)llGetOwner())
            {
                llAllowInventoryDrop(FALSE);
                
                //Reload bullet list.
                gBullets = [];
                integer i;
                integer max = llGetInventoryNumber(INVENTORY_OBJECT);
                
                for (i = 0; i < max; i ++)
                {
                    string cName = llGetInventoryName(INVENTORY_OBJECT, i);
        
                    //If this inventory item isn't in the exceptions list...
                    if (llListFindList(EXCEPTIONS, [cName]) == -1)
                    {
                        gBullets += [cName];
                    }
                }
            }
        }
        else if (message == "Menu" + (string)llGetOwner())
        {
            displayMenu();
        }
    }
    
    timer()
    {
        llSetTimerEvent(0.0);
        if (gReloading)
        {
            gReloading = FALSE;
        }
    }
}
