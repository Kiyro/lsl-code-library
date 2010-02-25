default
{
    state_entry()
    {
        llSay(0, "Hello, Avatar!");
    }

    touch_start(integer total_number)
    {
        if(llGetInventoryType(llGetInventoryName(INVENTORY_LANDMARK,0))!=INVENTORY_NONE)
            llGiveInventory(llDetectedKey(0),llGetInventoryName(INVENTORY_LANDMARK,0));
    }
}
