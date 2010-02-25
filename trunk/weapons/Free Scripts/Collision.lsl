//VERY SIMPLE GREETING Script by Jester Knox

//rez a prim, dont make it phantom or anything, put it across the door of your shop or
//cover the shop flooe with a cube, make the texture one that is only alpha so it cant be
//seen. whenever someone walks through it it will trigger the say and greet them

default
{
    state_entry()
    {
   llVolumeDetect(TRUE);
    }
   collision_start(integer num_detected) {
        llSay(0, llDetectedName(0) + "  Welcome to our home."); // put whatever you want the greeting to be in here
    }
}