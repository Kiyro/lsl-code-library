//This script just makes a single prim visable/invisable when the gun is holstered/unholstered.
//It needs the main holster script to controll it


integer holstered = FALSE;

default
{
    state_entry()
    {
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        if (num == 0 && !holstered)
        {
            //receiving the message 0 means the gun was holstered, so show it in the holster
            llSetAlpha(1.0, ALL_SIDES);
            holstered = TRUE;
        }
        else if (num == 1 && holstered)
        {
            //1 means the gun was unholstered. So make the copy in the holster invisable.
            llSetAlpha(0.0, ALL_SIDES);
            holstered = FALSE;
        }
    }
}
