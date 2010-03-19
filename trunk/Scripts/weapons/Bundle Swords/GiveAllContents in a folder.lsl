default 
{
    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            llSay(0,"Dispensing...");
            integer i;
            list inventory;
            for (i = 0;i < llGetInventoryNumber(INVENTORY_ALL);i ++)
            {
                if (llGetInventoryName(INVENTORY_ALL,i) != llGetScriptName())
                {
                    inventory += llGetInventoryName(INVENTORY_ALL,i);    
                }
            }
            llGiveInventoryList(llGetOwner(), llGetObjectName(),inventory);
        }
        else
        {
             llSay(0, "You are not the owner.");                         
        }  
    }
}
