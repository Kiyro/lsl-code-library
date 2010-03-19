// CATEGORY:Weapon
// CREATOR:Ferd Frederiex
// DESCRIPTION:Sand Hurricane! Script.lsl
// ARCHIVED BY:Ferd Frederix

default
{
    on_rez(integer startparam)
    {
        llResetScript();
    }
    state_entry()
    {
        llListen(0,"",llGetOwner(),"Sand Hurricane!");
    }

    listen(integer channel, string name, key id, string message)
    {
        
        
            llRezObject("Sand Hurricane!", llGetPos(), ZERO_VECTOR, ZERO_ROTATION, 0);
         
    }
}// END //
