list menulist = ["Help", "HUD", "Update", "Regen", "Stopregen", "Reset", "FullReset"];

init()
{
    llListen(1, "", "", "");
}


default
{
    state_entry()
    {
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
        if(id == llGetOwner() && llToLower(msg) == "sfcs")
        {
            llDialog(llGetOwner(), "SFCS Menu", menulist, 1);
        }
        else if(id == llGetOwner() && llToLower(msg) == "hud")
        {
            llGiveInventory(llGetOwner(), "SFCS HUD");
        }
    }
}
