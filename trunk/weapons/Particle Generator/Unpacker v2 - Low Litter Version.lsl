default
{
    on_rez(integer start_param)
    {
        integer i;
        integer n = llGetInventoryNumber(INVENTORY_ALL);
        list result = [];
        llOwnerSay("Freebie ready for unpacking, please select Yes to recieve contents.");

        for(i=0;i<n;i++)
        {
            if (llGetInventoryName(INVENTORY_ALL,i) != llGetScriptName())
            result = (result = []) + result + [llGetInventoryName(INVENTORY_ALL, i)];
        }
        llGiveInventoryList(llGetOwner(),llGetObjectName(),result);
        llSetTimerEvent(120);
        if (llGetAttached())
        {
            llRequestPermissions(llGetOwner(),PERMISSION_ATTACH);
            llOwnerSay("Freebie detected as attached to body, plz select Yes on dialog to unpack and it will delete itself");
        }
    }

    timer()
    {
        llDetachFromAvatar();
        llDie();
    }
}