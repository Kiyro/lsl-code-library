// This script keeps objects that get away from you from going into your lost and found when they leave the world due to getting away. The objects delete at the edge of the world, but doesn't go into your trash. So be carefull with this, make sure you have a copy of your object before letting an object go  that has this.
default
{
    state_entry()
    {
        llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
    }
}
