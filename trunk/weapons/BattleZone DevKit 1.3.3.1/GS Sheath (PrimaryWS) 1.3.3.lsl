//This is the channel which the object will listen to. It is set to channel 9 so to make it work you will say '/9' then the command.
integer hChannel    = -458238;          // BattleZone auto-sheating communication channel.
string  type        = "sword";          // Used for the Weapons System protocol weapon type.
string  weapon      = "";               // The weapon's name to listen from.

//---------------------------------------------------------------------

default
{
    state_entry()
    {
        llListen(hChannel, weapon, "", "");
        llSetAlpha(1, ALL_SIDES);
        llMessageLinked(LINK_SET, 1, "sheath", NULL_KEY);
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if (llGetOwnerKey(id) == llGetOwner()) {
            if (msg == "sheathed " + type)
            {
                llSetAlpha(1, ALL_SIDES);
                llMessageLinked(LINK_SET, 1, "sheath", id);
            } else
            if (msg == "drawn " + type)
            {
                llSetAlpha(0, ALL_SIDES);
                llMessageLinked(LINK_SET, 1, "draw", id);
            }
        }
    }
}
