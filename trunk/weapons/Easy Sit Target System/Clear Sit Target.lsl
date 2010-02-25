. // Remove this line to activate script.

// Drag this script into a prim to clear any sit target.  Script self-deletes automatically.

default
{
    state_entry()
    {
        llSitTarget(ZERO_VECTOR, ZERO_ROTATION);
        llRemoveInventory(llGetScriptName());
    }
}
