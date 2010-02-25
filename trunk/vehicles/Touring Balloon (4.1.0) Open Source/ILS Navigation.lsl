integer channel = 36658425;

default
{
    state_entry()
    {
        llListen(channel, "", NULL_KEY, "");
    }
    on_rez(integer startup_param)
    {
        llResetScript();
    }

    listen(integer channel, string name, key id, string message)
    {
        list packet;
        list navinfo;
        string owner;
        
        packet = llCSV2List(message);
        owner = llKey2Name(llGetOwner());
        
        if (owner == llList2String(packet, 1))
        {
            navinfo += llList2String(packet, 0);
            navinfo += llToLower(llList2String(packet, 2)); 
            navinfo += llList2Float(packet, 3);
            navinfo += llList2Float(packet, 4);
            navinfo += llList2Float(packet, 5); 
            navinfo += llList2Float(packet, 6);
            
            llMessageLinked(llGetLinkNumber(), 210, llList2CSV(navinfo), NULL_KEY); 
        }
        
     }
}
