//If you play with anything that goes bump, moves, etc this script needs to be in it. It allows for peace among other users.

//The function of this, is that when an object with this script hits something, there isn't any collision noise, or if so it's very little.
default
{
    state_entry()
    {
        llCollisionSound("", 0.0);
    }
}
