integer MSG_DEF_VICTIM    = 42001;  // for llMessageLinked(): define victim (key, name), (can be NULL)
integer MSG_RESP_STATUS   = 42002;  // for llMessageLinked(): RLV interface spec version and viewer
integer MSG_DEF_CMD       = 42003;  // for llMessageLinked(): send an RLV command
integer MSG_DEF_RELOGGED  = 42004;  // for llMessageLinked(): sent after ping pong

vector base_pos;
vector open_pos;


default {
    state_entry() {
        base_pos = llGetPos();
        open_pos = base_pos - <0.0, 0.0, 3.55>;
    }

    touch_start(integer total_number) {
        llWhisper(0, "Please wait, checking validity...");
        llMessageLinked(LINK_SET, MSG_DEF_VICTIM, llDetectedName(0), llDetectedKey(0));
    }
    
    
    link_message(integer sender_num, integer num, string str, key id) {
        if (num == MSG_RESP_STATUS) {
            if (str == "") {
                llWhisper(0, "Access denied, you are not using a recent relay or accepted viewer");
            } else {
                llWhisper(0, "Relay and viewer " + str + " verified, door opens 10 seconds for " + llKey2Name(id));
                llSetPos(open_pos);
                llSetTimerEvent(10.0);                
            }
        }
    }
    
    timer() {
        llSetPos(base_pos);
        llSetTimerEvent(0.0);
    }
    
}
