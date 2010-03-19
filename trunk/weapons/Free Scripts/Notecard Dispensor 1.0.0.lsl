default
{
    touch_start(integer total_number)
    {
        llGiveInventory(llDetectedKey(0), "Inventory Item");
    }
}
