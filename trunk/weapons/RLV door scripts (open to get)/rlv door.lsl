// interface to the RLV relay for a door
//
// definition of link-message constants

integer MSG_DEF_VICTIM    = 42001;  // for llMessageLinked(): define victim (key, name), (can be NULL)
integer MSG_RESP_STATUS   = 42002;  // for llMessageLinked(): RLV interface spec version and viewer
integer MSG_DEF_CMD       = 42003;  // for llMessageLinked(): send an RLV command
integer MSG_DEF_RELOGGED  = 42004;  // for llMessageLinked(): sent after ping pong

float   RLV_TIMEOUT       = 50.0;     // timeout in seconds

// use of the interface
// 1. send a link message "MSG_DEF_VICTIM", with name and key of the new victim (or NULL to release
//    a previous victim)
// 2. wait for response link messages MSG_RESP_STATUS which say that the victim is using relay and RLV.
//    It returns the RLV version (for example "1.12") or a "" after a certain timeout if no RLV was found.
// 3. now you can start sending commands via MSG_DEF_CMD (command in string argument, key is NULL)

integer g_channel_RR      = 88000;

key    g_victim           = NULL_KEY;
string g_victim_name      = "";
string g_relayname        = "tpdoor,";
 
integer RLVRS_CHANNEL     = -1812221819;  // RLVRS in numbers

integer g_cfg_debug       = 0;

integer g_rlv_version     = 0;
integer g_relay_version   = 0;

integer g_listenid        = -4711;


l_shutdown_listener() {
    llSetTimerEvent(0.0);
    if (g_listenid != -4711) {
        llListenRemove(g_listenid);
        g_listenid = -4711;
    }
}

default {
    state_entry() {
        llListen(RLVRS_CHANNEL, "", NULL_KEY, "");
        g_channel_RR = 18800000 + (integer)llFrand(99999.0);
    }
    
    on_rez(integer num) {
        // define a new random listener channel for version commands
        g_channel_RR = 18800000 + (integer)llFrand(99999.0);
        l_shutdown_listener();
        g_victim      = NULL_KEY;
        g_victim_name = "";
    }
    
    link_message(integer sender_num, integer num, string str, key id) {
        if (num == MSG_DEF_VICTIM) {
            g_victim      = id;
            g_victim_name = str;
            
            if (g_cfg_debug)
                llOwnerSay("RLV capture " + g_victim_name);
                
            if (g_victim) {
                // request relay version and RLV version
                g_listenid = llListen(g_channel_RR, "", NULL_KEY, "");
                llSay(RLVRS_CHANNEL, "TPChkVer," + (string)id + ",!version");
                llSetTimerEvent(RLV_TIMEOUT);
            }
            g_rlv_version = -1;   // unknown
            return;
        }
        if (num == MSG_DEF_CMD) {
            // only progress if victim defined and RLV version OK
            if (g_rlv_version <= 0)
                return;
            if (g_victim == NULL_KEY)
                return;
            llSay(RLVRS_CHANNEL, g_relayname + (string)g_victim + "," + str);
            return;
        }        
    }

    timer() {
        // no response obtained, timeout
        l_shutdown_listener();
        llMessageLinked(LINK_SET, MSG_RESP_STATUS, "", g_victim);
        g_rlv_version = 0;   // no RLV
    }
    
    listen(integer channel, string name, key id, string msg) {
        if (channel == g_channel_RR) {
            if (g_cfg_debug)
                llOwnerSay("version: got response <" + llGetSubString(msg, 22, -1) + "> from " + name);
            if (llGetSubString(msg, 0, 21) == "RestrainedLife viewer ") {
                g_rlv_version = 1;
                l_shutdown_listener();
                llMessageLinked(LINK_SET, MSG_RESP_STATUS, llGetSubString(msg, 22, -1), g_victim);
            }
            return;
        }
        if (channel == RLVRS_CHANNEL) {
            // response from relay
            if (g_cfg_debug)
                llOwnerSay("response from " + name + " is " + msg);
                
            list words = llParseString2List(msg, [ "," ], []);
            string cmdname;
            string object_key;
            string command;
            string result;
            
            cmdname    = llList2String(words, 0);       // repeated command name
            object_key = llList2String(words, 1);  // target object
            command    = llList2String(words, 2);       // command which was sent
            result     = llList2String(words, 3);       // optional response to command
            if (object_key == (string)llGetKey() && llGetOwnerKey(id) == g_victim) {
                // for me
                if (g_cfg_debug)
                    llOwnerSay("Relay response from " + name + " was for me and is " + result);
                if (g_rlv_version == -1 && cmdname == "TPChkVer") {
                    if ((integer)result >= 1012) {
                        g_relay_version = (integer)result;
                        llSay(RLVRS_CHANNEL, "TPChkRLV," + (string)g_victim + ",@version=" + (string)g_channel_RR);
                        g_rlv_version = -2;
                    } else {
                        llSay(0, g_victim_name + " uses a relay which is too old and has bugs (" + result + "). Please update to 1014 or better");
                        g_rlv_version = 0;
                        l_shutdown_listener();
                    }
                    return;
                }
            }
        }
    }
    
    
}
