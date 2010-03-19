// Place this script into any prim with a VICE bullet rezzer master/slave combo, and this will disable the slave script (and stop the annoying stream of bullets when you first add the rezzer kit to your gun)

default
{
    state_entry()
    {
        string scriptname;
        integer index;
        for(index=0; index<llGetInventoryNumber(INVENTORY_SCRIPT); index+=1)
        {
            scriptname=llGetInventoryName(INVENTORY_SCRIPT,index);
            // Search for a VICE bullet rezzer slave and disable it
            if(llGetSubString(scriptname,0,3)=="VICE" && ~llSubStringIndex(scriptname,"Bullet Rez Slave"))
            {
                llSetScriptState(scriptname,FALSE);
            }
        }
        llRemoveInventory(llGetScriptName());
    }
}
