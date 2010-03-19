// VICE new observer
// by Creem Pye 8/10/2008

// this object listens to the default combat channel and shouts ot when an avatar kills another avatar, with all available information

list weapon_types=["SCG","LMG","HMG","CAN","SMG","SSG","MEL",0,0,0,"SMB","MDB","LGB","TRP","KMK"];
list unit_types=["INF","ALA","AMA","AHA","TLA","TMA","THA","BLA","BHA","LFG","MFG","BMA","MFG"];

default
{
    on_rez(integer reznum)
    {
        llResetScript();
    }
    state_entry()
    {
        llSay(0,"VICE observer example.  See http://vicecombat.com for more information.\nCheck out the full-perm '"+llGetScriptName()+"' script to see how you can implement VICE in your own observing objects!");
        llSleep(1.0);
        // for a noncombatant, this is sufficient for enabling VICE:
        llMessageLinked(LINK_SET,TRUE,"vice ctrl","");
        llSetText("I'm a noisy egg!",<1.0,1.0,1.0>,1.0);

    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        
        if(num>>14 == 125822)   // this is a vice observer type message, probably
        {
            integer victim_unit_type=(num>>10)&15;
            integer victim_team=(num>>7)&7;
            integer attacker_team=(num>>4)&7;
            integer attacker_weapon_type=num&15;
            //key attacker_key=id;
            //key victim_key=(key)str;
            llShout(0,llKey2Name(id)+" (Team "+(string)attacker_team+") killed "+llKey2Name((key)str)+" (Team "+(string)victim_team+") with a "+llList2String(weapon_types,attacker_weapon_type)+". So much for "+llList2String(unit_types,victim_unit_type)+"s!");
        }
        //else llOwnerSay("debug: "+(string)num);
    }
}
