//This script makes sure that your objects stay in the sim that they are created. You can't save an object to inventory and rez in in another sim while this script is active.

123//remove the 123 to be able to use this script. Just delete the numbers and make sure running in the lower left is checked and hit save.

//Make sure you save a copy of this script and all others in this package before removing the 123.default


{
    state_entry()
    {
        llSetStatus(STATUS_DIE_AT_EDGE,TRUE);
        vector INITCorner = llGetRegionCorner();
        while(TRUE)
        {
            if(llGetRegionCorner() != INITCorner)
            {
                llDie();
            }
        }
    }
}
