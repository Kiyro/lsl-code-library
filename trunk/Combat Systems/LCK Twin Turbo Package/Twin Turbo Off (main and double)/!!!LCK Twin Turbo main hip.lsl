//Mostly found for free from SL libraries. Retouched and adjusted for LCK 2.0
//opensource by Hanumi Takakura and Salene Lusch.
// Help from Riki Barret,Areth Gall and
//Ordinal Malaprop over the SL forums. Distribute free and under the GNU
//license. Modify as needed and put your name on your changes. 

list show_cmd;
list hide_cmd;

default
{
    on_rez(integer params)
    {
        if(llGetAttached() == 0)
        {
            llSetLinkAlpha(LINK_SET,1,ALL_SIDES); 
            llSetRot(ZERO_ROTATION);
        }
    }
    
    attach(key id) {
        if (id)
            llResetScript();
    }
    state_entry()
    {
        llListen(99,"LCK TT HUD "+ llKey2Name(llGetOwner()), NULL_KEY, "");
        llListen(99,"", llGetOwner(), "");
        integer primary =  (llSubStringIndex(llGetScriptName(), "offhand")<0);
        if (primary) {
            show_cmd = ["off", "twin off", "off1", "sheath", "sheath1"];
            hide_cmd = ["on",  "twin on",  "on1",  "draw",   "draw1"];
        } else {
            show_cmd = ["off", "twin off", "off2", "sheath", "sheath2"];
            hide_cmd = ["on",  "twin on",  "on2",  "draw",   "draw2"];
        }
        llSetLinkAlpha(LINK_SET,1.0,ALL_SIDES); 
    }
    changed(integer change)
    {
        if(change & CHANGED_OWNER)
        {
            llResetScript();
        }
        if(change & CHANGED_INVENTORY)
        {
            llResetScript();
        }
    }
    listen( integer channel, string name, key id, string msg )
    {
        if (llGetOwnerKey(id) == llGetOwner()) {
            if (llListFindList(show_cmd, [msg])>=0)
                llSetLinkAlpha(LINK_SET,1.0,ALL_SIDES);
            else if (llListFindList(hide_cmd, [msg])>=0)
                llSetLinkAlpha(LINK_SET,0.0,ALL_SIDES);
            else if( msg == "cal on" )
                llSetTexture("3952f1f1-2211-f71a-3aa8-79f08378ddfa",ALL_SIDES);           else if( msg == "cal off")
                llSetTexture("9b9ea0f8-c212-4e93-d0ef-4d2042b5ecfa",ALL_SIDES);
        }
    }
}