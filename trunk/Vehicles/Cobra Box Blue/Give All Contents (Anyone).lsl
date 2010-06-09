default {
    
    
        state_entry()
    {
        llAllowInventoryDrop(TRUE); 
        llSetText("", <1,1,1>, 1.5);
       
    }
 
    touch_start(integer total_number) {
 
        list        inventory;
        string      name;
        integer     num = llGetInventoryNumber(INVENTORY_ALL);
        integer     i;
 
        for (i = 0; i < num; ++i) {
            name = llGetInventoryName(INVENTORY_ALL, i);
            if(llGetInventoryPermMask(name, MASK_NEXT) & PERM_COPY)
                inventory += name;
            else
                llSay(0, "Don't have permissions to give you \""+name+"\".");
        }
 
 
        //we don't want to give them this script
        i = llListFindList(inventory, [llGetScriptName()]);
        inventory = llDeleteSubList(inventory, i, i);
 
        if (llGetListLength(inventory) < 1) {
            llSay(0, "No items to offer."); 
        } else {
            // give folder to agent, use name of object as name of folder we are giving
            llGiveInventoryList(llDetectedKey(0), llGetObjectName(), inventory);
        }
 
    }
 
}