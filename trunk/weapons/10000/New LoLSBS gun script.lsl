//This is a free script designed to be used with the Lance of Longinus Shield Breaker System.
//Created by Auron Prefect

//SETUP:
string firesound = "Report"; //Type the name of the sound you would like to use when firing between the "".
integer customanimation = FALSE; //Change to true to use a custom animation.
string customname = "Dual Aim"; //Type the name of the animation between the "".
integer handgun =FALSE; //If you are not using a custom animation, set to TRUE to use a default handgun animation. Set to FALSE to use a default rifle animation.
integer multibullet = TRUE; //Set to TRUE to enable multi bullet. This allows the user to put in multiple bullets, and change them by clicking on the gun.
integer fullauto = TRUE; //Set to true to allow the user to switch from single shot to full auto. Set to false to stop them.
integer burst = TRUE; //Set to true to allow the user to use burst fire mode. When in burst fireing mode the gun will fire 3 shots every time the trigger is pulled.
integer reload = TRUE; //Set to true to force the user to reload after a number of shots are fired.
integer clipsize = 15; //How many shots are fired before the user has to reload.
float reloadtime = 2.00; //How many second it takes to reload the gun.
integer reloadanimation = FALSE; //Set to true if you want to use a reload animation.
string rcustomname = "Reload"; //Type the name of the reload animation between the "".
integer reloadsound = TRUE; //Set to true to play a sound when reloading.
string rsound = "Reload"; //Type the name of the sound you want to play when reloading between the "".
integer holster = FALSE; //Set to true if you are using the included free holster script.
integer loader = TRUE; //Set to true if you are using the loaderball for loading bullets.
list exceptions = ["Loader"]; //If you have objects in the gun besides bullets, add them to this list to prevent the bullet scanner from adding them. The format for lists is ["Object1", "Object2", "Object3"} and so on.
//END SETUP


//DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING!


integer attached = FALSE;  
integer permissions = FALSE;
vector  eye = <0.0, 0.0, 0.84>;
list bullets;
string bulletname = "Bullet";
string firemode = "Single";
integer rbullets = clipsize;
integer reloading = FALSE;
integer holstered = FALSE;
integer listen1;
integer listen2;
integer listen3;
integer randomc;
integer listen1c = 2657;
//This is the channel for dialogs. If you change this, you must also change it in the main holster script and menu click script if you are using them.


init()
{
    vector size = llGetAgentSize(llGetOwner());
    eye.z = eye.z * (size.z / 2.0);
    llListenRemove(listen1);
    llListenRemove(listen2);
    llListenRemove(listen3);
    listen1 = llListen(listen1c, "", NULL_KEY, "");
    listen2 = llListen(0, "", llGetOwner(), "");
    randomc = (integer)llFrand(1000) + 1000;
    //This creates a random number to use as a channel for the loader to talk to the gun.
    listen3 = llListen(randomc, "", NULL_KEY, "");
}


fire()
{
    if (!holstered)
    {
        if (((!reload) || (!reloading)) && ((!reload) || (rbullets > 0)))
        {
            rbullets --;
            rotation rot = llGetRot();
            vector fwd = llRot2Fwd(rot);
            vector pos = llGetPos() + eye;
            fwd *= 5;
            llTriggerSound(firesound, 1.0);
            if (multibullet)
            {
                if (llGetInventoryType(bulletname) == -1)
                {
                    llOwnerSay(bulletname + " Load the gun, Moron!");
                }
                else
                {
                    //NOTE: New versions of LoLSBS bullets will be using the start parameter to controll bullet speed. 100 = %100 of the base bullet speed. 
                    llRezObject(bulletname, pos, fwd, rot, 100);
                }
            }
            else
            {
                llRezObject("Bullet", pos, fwd, rot, 100);
            }
        }
        else
        {
            if (!reloading)
            {
                if (reloadanimation)
                {
                    llStartAnimation(rcustomname);
                }
                if (reloadsound)
                {
                    llTriggerSound(rsound, 1.0);
                }
                reloading = TRUE;
                rbullets = clipsize;
                llSetTimerEvent(reloadtime);
            }
        }
    }
}


default
{
    state_entry()
    {
        llReleaseControls();
        llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH); 
        llPreloadSound(firesound);
        if (reloadsound)
        {
            llPreloadSound(rsound);
        }
        
        init();
    }
    
    on_rez(integer start_param)
    {
        llReleaseControls();
        llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH); 
        llPreloadSound(firesound);
        if (reloadsound)
        {
            llPreloadSound(rsound);
        }
    }
    
    run_time_permissions(integer permissions)
    {
        if (permissions > 0)
        {

            if (!attached)
            {
                llAttachToAvatar(ATTACH_RHAND);
                //This tells it where to attach to.
            }
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            if ( !holstered)
            {
                if (customanimation)
                {
                    llStartAnimation(customname);
                }
                else if (handgun)
                {
                    llStartAnimation("hold_R_handgun");
                }
                else
                {
                    llStartAnimation("hold_R_rifle");
                }
            }
            
            attached = TRUE;
            permissions = TRUE;
        }
    }
    
    attach(key attachedAgent)
    {

        if (attachedAgent != NULL_KEY)
        {
            attached = TRUE;
            if (multibullet)
            {
                if (llGetInventoryType(bulletname) == -1)
                {
                    llSay(0, bulletname + " could not be found. Please select a new bullet");
                }
            }
            
            init();
            
            if (!permissions)
            {
                llReleaseControls();
                llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH);   
            }
            
        }
        else
        {
           
            attached = FALSE;
            if (customanimation)
            {
                llStopAnimation(customname);
            }
            else if (handgun)
            {
                llStopAnimation("hold_R_handgun");
            }
            else
            {
                llStopAnimation("hold_R_rifle");
            }
            llReleaseControls();
           

        }
    }

    control(key name, integer levels, integer edges) 
    {
        if((levels & CONTROL_ML_LBUTTON) && (edges & CONTROL_ML_LBUTTON))
        {
            if (firemode == "Single") fire();
            
            else if (firemode == "Burst")
            {
                integer x;
                for(x = 0; x < 3; x++) {
                    
                    fire();
                }
            }
        }
        
        if((levels & CONTROL_ML_LBUTTON) && !(edges & CONTROL_ML_LBUTTON))
        {
            if (firemode == "Full Auto") fire();
        }
    }
    
    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            if (fullauto || burst || multibullet || loader || holster)
            {
                //This will create a list of buttons for the menu
                list dialog;
                if (fullauto || burst)
                {
                    dialog += ["Fire Modes"];
                }
                
                if (multibullet)
                {
                    dialog += ["Ammo"];
                }
                
                if (loader)
                {
                    dialog += ["Loader"];
                }
                
                if((holster) && (holstered))
                {
                    dialog += ["Unholster"];
                }
                else if((holster) && (!holstered))
                {
                    dialog += ["Holster"];
                }
                            llDialog(llDetectedKey(0), "Please make a selection.", dialog, listen1c);
            }
        }
    }
    
    listen(integer channel, string name, key id, string message) 
    {
        if (id == llGetOwner())
        {
            if ((message == "Ammo") && (multibullet))
            {
                integer counter = 0;
                integer fakes = 0;
                bullets = [];
                integer finding = TRUE;
                while (finding)
                {
                    if (llGetInventoryName(INVENTORY_OBJECT, counter) != "" && counter < 12 - fakes)
                    {
                        if (llListFindList(exceptions, [llGetInventoryName(INVENTORY_OBJECT, counter)]) == -1)
                        {
                            bullets += [llGetSubString(llGetInventoryName(INVENTORY_OBJECT, counter), 0, 23)];
                        }
                        else
                        {
                            fakes ++;
                        }
                        counter ++;
                    }
                    else
                    {
                        llDialog(id, "Please select your ammunition.", bullets, listen1c);
                        finding = FALSE;
                    }
                }
            }
            else if ((message == "Fire Modes") && (fullauto || burst))
            {
                list dialog = ["Single"];
                if (fullauto)
                {
                    dialog += ["Full Auto"];
                }
                
                if (burst)
                {
                    dialog += ["Burst"];
                }
                
                llDialog(id, "Please select a fire mode.", dialog, listen1c);
            }
            else if (message == "Single" || message == "Full Auto" || message == "Burst")
            {
                firemode = message;
                llSay(0, firemode + " Firing mode has been activated");
            }
            else if((llToLower(message) == "holster") && (holster) && (!holstered))
            {
                llSetLinkAlpha(LINK_SET, 0.0, ALL_SIDES);
                holstered = TRUE;
                if (customanimation)
                {
                    llStopAnimation(customname);
                }
                else if (handgun)
                {
                    llStopAnimation("hold_R_handgun");
                }
                else
                {
                    llStopAnimation("hold_R_rifle");
                }
            }
            else if((llToLower(message) == "unholster") && (holster) && (holstered))
            {
                llSetLinkAlpha(LINK_SET, 1.0, ALL_SIDES);
                holstered = FALSE;
                llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
                if (customanimation)
                {
                    llStartAnimation(customname);
                }
                else if (handgun)
                {
                    llStartAnimation("hold_R_handgun");
                }
                else
                {
                    llStartAnimation("hold_R_rifle");
                }
            }
            else if ((message == "Loader") && (loader))
            {
                llRezObject("Loader", llGetPos() + <0,0,2>, ZERO_VECTOR, ZERO_ROTATION, randomc);
            }
            else if (llGetInventoryType(message) != -1)
            {
                bulletname = message;
                llSay(0, message + " is now loaded");
            }
        }
        else if ((name == "Loader" + (string)llGetOwner()) && (loader))
        {
            //This is all for the loader system
            if (message == "Connect")
            {
                integer finding = TRUE;
                integer counter = 0;
                integer fake = 0;
                while (finding)
                {
                    //This gives the bullets in the guns inventory to the loader.
                    if (llGetInventoryName(INVENTORY_OBJECT, counter) != "" && counter - fake < 12)
                    {
                        if (llListFindList(exceptions, [llGetInventoryName(INVENTORY_OBJECT, counter)]) == -1)
                        {
                            llGiveInventory(id, llGetInventoryName(INVENTORY_OBJECT, counter));
                        }
                        else
                        {
                            fake ++;
                        }
                        counter ++;
                    }
                    else
                    {
                        llSay(randomc, "Connected" + (string)llGetOwner());
                        finding = FALSE;
                    }
                }
            }
            else if (message == "Readyload" + (string)llGetOwner())
            {
                //This deletes bullets in the guns inventory before the loader gives it new ones
                integer finding = TRUE;
                integer fakes = 0;
                while (finding)
                {
                    if (llGetInventoryName(INVENTORY_OBJECT, 0 + fakes) != "")
                    {
                        if (llListFindList(exceptions, [llGetInventoryName(INVENTORY_OBJECT, 0 + fakes)]) == -1)
                        {
                            llRemoveInventory(llGetInventoryName(INVENTORY_OBJECT, 0 + fakes));
                        }
                        else
                        {
                            fakes ++;
                        }
                    }
                    else
                    {
                        //AllowInventoryDrop lets the loader put bullets in
                        llAllowInventoryDrop(TRUE);
                        llSay(randomc, "Ready" + (string)llGetOwner());
                        finding = FALSE;
                    }
                }
            }
            else if (message == "Done" + (string)llGetOwner())
            {
                llAllowInventoryDrop(FALSE);
            }
        }
        else if (message == "Menu" + (string)llGetOwner())
        {
            //Opens the menu
            if (fullauto || burst || multibullet || loader || holster)
            {
                list dialog;
                if (fullauto || burst)
                {
                    dialog += ["Fire Modes"];
                }
                
                if (multibullet)
                {
                    dialog += ["Ammo"];
                }
                
                if (loader)
                {
                    dialog += ["Loader"];
                }
                
                if((holster) && (holstered))
                {
                    dialog += ["Unholster"];
                }
                else if((holster) && (!holstered))
                {
                    dialog += ["Holster"];
                }
                llDialog(llGetOwner(), "Please make a selection.", dialog, listen1c);
            }
        }
    }
    
    timer()
    {
        reloading = FALSE;
        llSetTimerEvent(0.0);
    }
}
