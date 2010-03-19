default
{
    state_entry()
    {
        llOwnerSay("Hilt ready.");
    }
    changed(integer change)
    {
        if(change & CHANGED_LINK)
        {
            llRemoveInventory(llGetScriptName());
        }
    }
}