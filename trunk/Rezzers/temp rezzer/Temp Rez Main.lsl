// This is one of a set of four scripts written by Eata Kitty to allow a multi-prim
// object to be rezzed as Temporary from a permanent single prim object.  Temporary
// objects are not counted against your prim total on land, so this allows you to
// reduce your prim total without cutting into your lifestyle.  You must have copy
// and modify rights to any object you wish to use with these scripts.  See the
// included Notecard for more details.
//
// Version 1.3  -   12 February 2007

// Empty variables that will store set position/rotation 
// DON'T CHANGE THESE 
vector rezPosition = <0,0,0>; 
rotation rezRotation = <0,0,0,0>; 
// Inter-object commands 
string commandDerez = "derez"; 
// Chat channel 
integer commChannel; 
// Rezzed object key 
key childKey = NULL_KEY; 
// How often our sensor checks, smaller is more responsive but more demanding 
float sensorTime = 1; 
// Rerez time - Desired life time of our object 
integer lifeTime = 50; 
// Time this object was rezzed 
integer startTime = 0; 
// Tick to avoid getting pos too often 
integer tick; 
// avSensor is running 
integer avSensor = FALSE; 

// InventoryCheck 
// Checks the status of our inventory 
integer InventoryCheck() 
{ 
    // Check if we have too many objects 
    if (llGetInventoryNumber(INVENTORY_OBJECT) > 1) 
    { 
        llOwnerSay("ERROR - Too many objects! This rezzer only takes a single object"); 
        return 1; 
    } 
    // No objects 
    else if (llGetInventoryNumber(INVENTORY_OBJECT) == 0) 
    { 
        llOwnerSay("ERROR - No objects in inventory!"); 
        return 1; 
    } 
    // Inventory must be copy 
    if (llGetInventoryPermMask(llGetInventoryName(INVENTORY_OBJECT, 0), MASK_OWNER) & PERM_COPY) 
        return 0; 
    else 
    { 
        llOwnerSay("ERROR - Object does not have copy permissions"); 
        return 1; 
    } 
} 

integer rez() 
{ 
    llSay(commChannel, commandDerez); 
    llSetTimerEvent(0); 
    childKey = NULL_KEY; 
    // Check if we have a rez position set, don't want to rez at 0,0,0 
    if (rezPosition == <0,0,0>) 
    { 
        llRezAtRoot(llGetInventoryName(INVENTORY_OBJECT, 0), llGetPos(), ZERO_VECTOR, rezRotation, commChannel); 
        return 0; 
    } 
    else 
    { 
        if (llVecDist(llGetPos(), rezPosition) > 10) 
        { 
            llOwnerSay("Rez position is over 10M away. Reset me or move me closer to: " + (string)rezPosition + "."); 
            return 1; 
        } 
        llRezAtRoot(llGetInventoryName(INVENTORY_OBJECT, 0), rezPosition, ZERO_VECTOR, rezRotation, commChannel); 
        return 0; 
    } 
} 

default 
{      
    state_entry() 
    { 
        llSetAlpha(1.0, ALL_SIDES); 
        childKey = NULL_KEY; 
    } 
      
    changed(integer change) 
    { 
        if (change & CHANGED_INVENTORY) 
        { 
            if (!InventoryCheck()) 
                llOwnerSay("Ready to run"); 
        } 
        if (change & CHANGED_OWNER) 
        { 
            llOwnerSay("New owner, resetting."); 
            llOwnerSay("To use me put a 0 Prim Object script inside the object you want to be rezzed then put it in my inventory and turn me on. You can fine tune the rez position/rotation through the Set P/R button (10M max distance)."); 
            llResetScript(); 
        } 
    } 
      
    link_message(integer sender, integer num, string message, key id) 
    { 
        // Turn on message 
        if (num == 1200) 
        { 
            if (!InventoryCheck()) 
                state running; 
        } 
        // avSensor is running 
        else if (num == 1400) 
        { 
            avSensor = TRUE; 
        } 
        // avSensor is disabled 
        else if (num == 1500) 
        { 
            avSensor = FALSE; 
        } 
        else 
        { 
            llOwnerSay("Error - Rezzer not running"); 
        } 
    } 
} 

state running 
{ 
    state_entry() 
    { 
        llOwnerSay("Running."); 
        childKey = NULL_KEY; 
        llSetTimerEvent(0.0); 
// **** Comment out the following line if you don't want to make your container object invisible
        llSetAlpha(0.0, ALL_SIDES); 
        // Random comm channel 
        commChannel = (integer)llFrand(2000000000.0); 
        // Create object 
        if (!avSensor) 
            // The rez() function returns a integer value depending on success 
            // If we get a 1 we want to go back to the inactive state 
            if (rez() == 1) 
                state default; 
    } 
      
    object_rez(key child) 
    { 
        // Very important, we use this to sense our child 
        childKey = child; 
        startTime = llGetUnixTime(); 
        llSetTimerEvent(sensorTime); 
    } 
      
    timer() 
    { 
        if (llGetUnixTime() >= (startTime + lifeTime)) 
        { 
            llSay(commChannel, commandDerez); 
            rez(); 
        } 
        else 
            llSensor("", childKey, SCRIPTED, 96, PI); 
    } 
      
    sensor(integer num_detected) 
    { 
        // Check every 5 runs of the sensor 
        if (tick >= 5) 
        { 
            tick = 0; 
            // Is our stored position the same as detected? 
            if (rezPosition != llDetectedPos(0)) 
            { 
                if (llVecDist(llGetPos(), llDetectedPos(0)) > 10) 
                { 
                    llOwnerSay("Deactivating: Object has moved out of 10M rez range. Move the sensor closer to the target rez position."); 
                    llSay(commChannel, commandDerez); 
                    state default; 
                } 
                llOwnerSay("Set pos"); 
                rezPosition = llDetectedPos(0); 
            } 
            // Is our stored rotation the same as detected? 
            if (rezRotation != llDetectedRot(0)) 
            { 
                llOwnerSay("Set rot"); 
                rezRotation = llDetectedRot(0); 
            } 
        } 
        else 
            tick++; 
    } 
      
    no_sensor() 
    { 
        // Our child object is missing, rerez it 
        rez(); 
    } 
      
    on_rez(integer param) 
    { 
        // Move back to default, keep object info 
        state default; 
    } 
      
    changed(integer change) 
    { 
        // If out inventory changes 
        if (change & CHANGED_INVENTORY) 
        { 
            // This calls our inventory check function, if there is an inventory 
            // problem it returns a 1 which will causes us to return to default 
            if (InventoryCheck()) 
                state default; 
        } 
    } 
      
    link_message(integer sender, integer num, string message, key id) 
    { 
        // Reset 
        if (num == 1000) 
        { 
            llOwnerSay("Resetting - Object info cleared"); 
            llSay(commChannel, commandDerez); 
            llResetScript(); 
        } 
        // Turn on message 
        else if (num == 1200) 
        { 
            llOwnerSay("Rezzer already running... resynching with dialog"); 
            // Inform user, we don't really need to do anything as dialog will now be in synch 
        } 
        // Turn off message 
        else if (num == 1300) 
        { 
            llOwnerSay("Rezzer turning off..."); 
            llSay(commChannel, commandDerez); 
            llMessageLinked(LINK_THIS, 1500, "", NULL_KEY); 
            state default; 
        } 
        // avSensor is running 
        else if (num == 1400) 
        { 
            avSensor = TRUE; 
        } 
        // avSensor is disabled 
        else if (num == 1500) 
        { 
            avSensor = FALSE; 
        } 
        // avSensor detected an av 
        else if (num == 2000) 
        { 
            if (childKey == NULL_KEY) 
                rez(); 
        } 
        // avSensor detects no av 
        else if (num == 2100) 
        { 
            llSetTimerEvent(0.0); 
            llSay(commChannel, commandDerez); 
            childKey = NULL_KEY; 
        } 
    }     
} 
