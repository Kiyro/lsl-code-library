//This script just makes a single prim visible/invisible when the gun is holstered/unholstered.
//It needs the main holster script to control it.



default
{
    state_entry()
    {
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        if (num == 1)
        {
            //The gun has been unholstered.
            llSetAlpha(0.0, ALL_SIDES);
        }
    }
}
