// Is the sensor enabled 
integer active = FALSE; 
// How often sensor checks, longer uses less resources but means slower reaction 
integer sensorPeriod = 10; 
// Distance in M the sensor will find avs 
integer sensorDist = 20; 
// Sensor detected an av on last run if true 
integer avDetected = FALSE; 

default 
{ 
    link_message(integer sender, integer num, string message, key id) 
    { 
        // Sensor on message 
        if (num == 1400) 
        { 
            avDetected = FALSE; 
            llSensorRepeat("", NULL_KEY, AGENT, sensorDist, PI, sensorPeriod); 
        } 
        // Sensor off message 
        else if (num == 1500) 
        { 
            avDetected = FALSE; 
            llSensorRemove(); 
        } 
    } 
     
    sensor(integer total_number) 
    { 
        // Only do something if this is the first detection of an av 
        if (!avDetected) 
        { 
            // We detected something, tell Main to rez 
            llMessageLinked(LINK_THIS, 2000, "", NULL_KEY); 
            avDetected = TRUE; 
        } 
    } 
     
    no_sensor() 
    { 
        // Only do something if we had detected an av last sensor 
        if (avDetected) 
        { 
            // No avs, disable rezzing 
            llMessageLinked(LINK_THIS, 2100, "", NULL_KEY); 
            avDetected = FALSE; 
        } 
    } 
     
    changed(integer change) 
    { 
        if (change & CHANGED_OWNER) 
        { 
            llResetScript(); 
        } 
    } 
} 
