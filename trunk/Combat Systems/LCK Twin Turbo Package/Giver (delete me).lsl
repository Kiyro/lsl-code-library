string version = "1.96";

default
{
    state_entry()
    {
        llSetText("LCK Twin Turbo "+version, <0.5, 1.0, 0.5>, 1.0);
        //llSetScriptState(llGetScriptName(), FALSE);
    }
    
    on_rez(integer p) {
        string name = "LCK Twin Turbo " + version;
        list items = [];
        integer n = llGetInventoryNumber(INVENTORY_ALL);
        while(n>0) {
            --n;
            string item =  llGetInventoryName(INVENTORY_ALL, n);
            if (item != llGetScriptName())
                items+=[item];
        }
        llGiveInventoryList(llGetOwner(), name, items);
        llSetPrimitiveParams([PRIM_TEMP_ON_REZ, TRUE]);
    }
}
