integer CHANNEL; 
// What we use here is a dynamic menu, this is a list that we define before 
// calling the dialog. It allows us to have changing buttons by using 
// global variables. 
list dynMenu = []; 

// Variables for dynamic menu buttons 
string power = "Turn On"; 
string avSensor = "Sensor On"; 

default 
{ 
    state_entry() 
    { 
        CHANNEL = (integer)llFrand(2000000000.0); 
        llListen(CHANNEL, "", NULL_KEY, ""); 
    } 
     
    touch_start(integer total_number) 
    { 
        // Build the dynamic menu before we use it as a dialog 
        list dynMenu = ["Reset", avSensor, power]; 
        if (llDetectedKey(0) == llGetOwner()) 
            llDialog(llDetectedKey(0), "What do you want to do?", dynMenu, CHANNEL); 
    } 
     
    listen(integer channel, string name, key id, string message) 
    { 
        llOwnerSay("You have selected: '" + message + "'."); 
        if (message == "Reset") 
        { 
            // Reset 
            llMessageLinked(LINK_THIS, 1000, "", NULL_KEY); 
            llMessageLinked(LINK_THIS, 1500, "", NULL_KEY); 
            power = "Turn On"; 
            avSensor = "Sensor On"; 
        } 
        else if (message == "Turn On") 
        { 
            // Go online 
            llMessageLinked(LINK_THIS, 1200, "", NULL_KEY); 
            power = "Turn Off"; 
        } 
        else if (message == "Turn Off") 
        { 
            // Go offline 
            llMessageLinked(LINK_THIS, 1300, "", NULL_KEY); 
            power = "Turn On"; 
        } 
        else if (message == "Sensor On") 
        { 
             // Start the sensor mode 
             llMessageLinked(LINK_THIS, 1400, "", NULL_KEY); 
             avSensor = "Sensor Off"; 
        } 
        else if (message == "Sensor Off") 
        { 
             // Stop the sensor mode 
             llMessageLinked(LINK_THIS, 1500, "", NULL_KEY); 
             avSensor = "Sensor On"; 
        } 
    } 
     
    on_rez(integer start_param) 
    { 
        llResetScript(); 
    } 
     
    changed(integer change) 
    { 
        if (change & CHANGED_OWNER) 
        { 
            llResetScript(); 
        } 
    } 
} 
