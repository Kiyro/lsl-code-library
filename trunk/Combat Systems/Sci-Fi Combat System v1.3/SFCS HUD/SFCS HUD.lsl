integer health;
integer stamina;
integer blocking = 0;
string stats;
vector color;
init()
{
    llListen(-696969, "", "", "");
    llShout(-690069, "updatehp");
    llOwnerSay("HUD Active.");
}

updatehealth()
{
    stats = "SFCS HUD\nHealth: "+ (string)health + "% / Stamina: " + (string)stamina + "%";
    llSetText(stats, color, 1.0);
}

default
{
    state_entry()
    {
        color = <253,225,149> / 255;
        init();
    }
    attach(key attached)
    {
        if(attached != NULL_KEY)
        {
            init();
        }
    }
    listen(integer chan, string name, key id, string msg)
    {
        list blah;
        if(llGetOwnerKey(id) == llGetOwner())
        {
            if(llToLower(llGetSubString(msg, 0, 5)) == "color ")
            {
                color = (vector)llGetSubString(msg, 6, -1);
            }
            else if(llGetOwnerKey(id) == llGetOwner())
            {
                blah = llCSV2List(msg);
                health = (integer)llList2String(blah, 0);
                stamina = (integer)llList2String(blah, 1);
                updatehealth();                
            }
        }
    }
}
