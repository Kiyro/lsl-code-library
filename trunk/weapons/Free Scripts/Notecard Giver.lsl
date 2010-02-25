default 
{ 
    state_entry() 
    { 
         
    } 

    touch_start(integer total_number) 
    { 
        if (llGetInventoryNumber(INVENTORY_NOTECARD) > 0) 
        { 
            llGiveInventory(llDetectedKey(0), llGetInventoryName(INVENTORY_NOTECARD, 0)); 
        } 
        if (llGetInventoryNumber(INVENTORY_SOUND) > 0) 
        { 
            llTriggerSound(llGetInventoryName(INVENTORY_SOUND,   0), 1.0); 
        } 
    } 
}
