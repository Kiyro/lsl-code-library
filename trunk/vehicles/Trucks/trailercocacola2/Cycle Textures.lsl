default
{
    state_entry()
    {
        llSetText("", <0,1,0>,1);
        llSetTimerEvent(1.0);
    }
    timer()
    {
        integer number = llGetInventoryNumber(INVENTORY_TEXTURE);
        float rand = llFrand(number);
        integer choice = (integer)rand;
        string name = llGetInventoryName(INVENTORY_TEXTURE, choice);
        if (name != "")
            llSetTexture(name, 4);
    }
}
