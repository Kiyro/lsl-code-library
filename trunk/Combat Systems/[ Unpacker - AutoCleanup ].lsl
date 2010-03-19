vector TextColor = <1.0,1.0,1.0>;
float TextAlpha = 1.0;
////

string ItemName;

default
{
    on_rez(integer Start) { llResetScript(); }
    
    state_entry()
    {
        ItemName = llGetObjectName();
        llSetText("Touch to unpack your\n" + ItemName,TextColor,TextAlpha);
    }
    touch_start(integer Number)
    {
        if(llDetectedKey(0) == llGetOwner())
        {
            list Inventory;
            
            integer InvNum = llGetInventoryNumber(INVENTORY_ALL);
            integer LodNum;
            
            for(; LodNum < InvNum; LodNum++)
            {
                Inventory += [llGetInventoryName(INVENTORY_ALL, LodNum)];
            }
            
            integer ThiScr = llListFindList(Inventory, [llGetScriptName()]);
            Inventory = llDeleteSubList(Inventory, ThiScr, ThiScr);
            
            llGiveInventoryList(llDetectedKey(0), ItemName, Inventory);
            llDie();
        }
    }
}