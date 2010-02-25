list getInventoryList()
{
    integer    i;
    integer    n = llGetInventoryNumber(INVENTORY_ALL);
    list          result = [];

    for( i = 0; i < n; i++ )
    {
        if (llGetInventoryName(INVENTORY_ALL,i) != llGetScriptName())
        result = (result = []) + result + [llGetInventoryName(INVENTORY_ALL, i)];
    }
    return result;
}

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }

    state_entry()
    {
        list gInventoryList = getInventoryList();
        llGiveInventoryList(llGetOwner(),llGetObjectName(),gInventoryList);
        llSetTimerEvent(20);
    }

    timer()
    {
        llDie();
    }
}