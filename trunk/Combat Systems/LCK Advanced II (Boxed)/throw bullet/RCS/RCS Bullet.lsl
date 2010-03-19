init()
{
        llSetStatus( STATUS_DIE_AT_EDGE, TRUE);
        llSetBuoyancy(1.0);                 //  Make bullet float and not fall 
        llCollisionSound("", 1.0);          //  Disable collision sounds
}    

default
{
    state_entry()
    {
        init();
    }
    
    on_rez(integer delay)
    {
        init();
    }
    collision_start(integer number)
    {
       
        llDie();
    }
    land_collision_start(vector coords)
    {
        llDie();
    }
}
