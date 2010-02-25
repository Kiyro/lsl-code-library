// This script should be in the root prim.
// This script does all the listening for the vehicle.
// This script sends a message on touch with the string "touch" and the key of the person touching.

integer listenindex;
integer power;
vector color;
key pilot;

string trim(string input)
{
    return llDumpList2String(llParseString2List(input, [" "], []), " ");
}

default
{
    state_entry()
    {
        llCollisionSound("", 0.0);
        llListenRemove(listenindex);
        power = FALSE;
        pilot = NULL_KEY;
    }
    
    on_rez(integer sparam)
    {
        llSay(0, "Say 'start' to start the engine.");
        llSay(0, "Use mouselook to steer.");
        llSay(0, "Use WASD to fly.");
        llSay(0, "Use Page Up/Page Down to increase/decrease altitude.");
        power = FALSE;
        pilot = NULL_KEY;
        llListenRemove(listenindex);
    }
    
    touch_start(integer n)
    {
        llMessageLinked(LINK_ALL_CHILDREN, 0, "touch", llDetectedKey(0));
    }
    
    listen(integer channel, string name, key id, string message)
    {
        message = trim(message);
        message = llToLower(message);
        if ((message == "start" || message == "power up") && !power && id == pilot) {
            power = TRUE;
            llWhisper(0, "/me Online.");
            llMessageLinked(LINK_SET, 0, "on", NULL_KEY);
            llMessageLinked(LINK_SET, 0, "start", NULL_KEY);
        } else if ((message == "stop" || message == "power down") && power) {
            power = FALSE;
            llWhisper(0, "/me Powering Down");
            llMessageLinked(LINK_SET, 0, "stop", NULL_KEY);
            llMessageLinked(LINK_SET, 0, "off", NULL_KEY);
            
        } else if (message == "display on") {
            llMessageLinked(LINK_SET, 0, "display on", NULL_KEY);
        } else if (message == "display off") {
            llMessageLinked(LINK_SET, 0, "display off", NULL_KEY);
        } else if (message == "eject passenger" || message == "ep") {
            llMessageLinked(LINK_SET, 0, "eject passenger", NULL_KEY);
        } else if (message == "help") {
            llGiveInventory(id, "Hammerhead Help");
        } else if (llGetSubString(message, 0, 7) == "color 1 ") {
            llMessageLinked(llGetLinkNumber(), 0, "parse color", trim(llGetSubString(message, 8, llStringLength(message))));
        } else if (llGetSubString(message, 0, 7) == "color 2 ") {
            llMessageLinked(llGetLinkNumber(), 1, "parse color", trim(llGetSubString(message, 8, llStringLength(message))));
        } else if (llGetSubString(message, 0, 5) == "color ") {
            llMessageLinked(llGetLinkNumber(), -1, "parse color", trim(llGetSubString(message, 6, llStringLength(message))));
        } else if (llStringLength(message) == 1 && (string)((integer)message) == message) {
            llMessageLinked(llGetLinkNumber(), (integer)message, "set throttle", NULL_KEY);
        }
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "pilot" && id == NULL_KEY) {
            pilot = NULL_KEY;
            llListenRemove(listenindex);
            if (power) {
            llMessageLinked(LINK_SET, 0, "stop", NULL_KEY);
           llMessageLinked(LINK_SET, 0, "off", NULL_KEY);
                power = FALSE;
                llWhisper(0, "/me Powering Down");
            }
        } else if (str == "pilot" && id != NULL_KEY) {
            pilot = id;
            llListenRemove(listenindex);
            listenindex = llListen(0, "", pilot, "");
         // llMessageLinked(LINK_SET, 0, "pilot", NULL_KEY);
          llMessageLinked(LINK_SET, 0, "half", NULL_KEY);
            llMessageLinked(LINK_SET, 0, "half", NULL_KEY);;
              llMessageLinked(LINK_SET, 0, "off", NULL_KEY);
        }
    }
}
