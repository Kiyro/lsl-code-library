//Finder Script
//By Hank Ramos
//Portions originally by Eggy Lippmann
//===========================
//Configurable Options...
float sensorInterval = 1800; //Seconds between scans
float sensorDistance = 30.0; //Max distance owner can be from object, Max is 96 meters
//===========================
string  OwnerName;
integer dispOnce;
integer gotName;

disp(string message)
{
    llMessageLinked(LINK_ALL_CHILDREN, 411, message, NULL_KEY);
}

initialize()
{
    dispOnce = FALSE;
    gotName  = FALSE;
    llSensorRepeat("", llGetOwner(), AGENT, 96, TWO_PI, 1); //Get Name of Avatar, so use max diatance and min time
}

checkC(string message, key id)
{
    
    if ((llSameGroup(id)) || (id == llGetOwner()))
    {
        message = llToLower(message);
        if (llSubStringIndex(message, "finder rate ") == 0)
        {
            sensorInterval = (float)llGetSubString(message,12,18) * 60;
            disp("Finder Sensor Rate Set To " + (string)((integer)(sensorInterval/60)) + " minutes");
        }
    
        else if (llSubStringIndex(message, "finder distance ") == 0)
        {
            sensorDistance = (float)llGetSubString(message,16,22) * 60;
            disp("Finder Sensor Distance Set To " + (string)((integer)(sensorDistance/60)) + " meters");
        }
     
        else if ((message == "startup") || (message == "finder on"))
        {
            dispOnce = FALSE;
            disp("Finder is On.  If lost, will IM " + OwnerName);
        }
        
        else if ((message == "shutdown") || (message == "finder off"))
        {
            disp("Finder is Off. No lost notifications will be sent.");
            llSensorRemove();
        }
    }
}
default
{
    state_entry()
    {
        initialize();
    }
    on_rez(integer start_param)
    {
        llResetScript();
    }
    sensor(integer num_detected)
    {
        if (!gotName)
        {
            gotName   = TRUE;
            OwnerName = llDetectedName(0);
            llSensorRepeat("", "", AGENT, sensorDistance, TWO_PI, 5); //Get Name of Avatar, so use max diatance and min time
        }
        dispOnce = FALSE;
    }
    no_sensor() 
    { 
        if ((llGetTime() >= sensorInterval) || (!dispOnce))
        {
            llWhisper(0, OwnerName + " lost me! Tell them to come and get me at " + (string) llGetPos() + " in the " + llGetRegionName() + " region."); 
            llInstantMessage(llGetOwner(), "I'm lost!  Come and get me at " + (string) llGetPos() + " in the " + llGetRegionName() + " region.");
            llResetTime();
        } 
        if (!dispOnce) 
        {
            dispOnce = TRUE;
            llResetTime();
        }
    }
    link_message(integer sender_number, integer number, string message, key id)
    {
        if (number == 95562)
        {
            checkC(message, id);
            return;
        }
        //Process API Commands
        if (number == 240)
        {
            checkC(message, id);
            return;
        }
    }

}
