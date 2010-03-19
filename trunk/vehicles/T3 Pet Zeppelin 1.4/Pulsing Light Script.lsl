default
{
    state_entry()
    {
        llSetTimerEvent(20);
        llStopSound();
        if(llGetInventoryType(llGetInventoryName(INVENTORY_SOUND,0))!=-1)
            llLoopSound(llGetInventoryName(INVENTORY_SOUND,0),.25);
    }

    timer()
    {
        llMessageLinked(LINK_SET,1,"pulse","");
    }
}
