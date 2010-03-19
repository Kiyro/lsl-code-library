default
{
    state_entry()
    {
       
    }

    collision_start(integer chargeval)
    {
        llSleep(3);
        llDie();   
    }
    land_collision_start(vector pos)
    {
     
     
        llSleep(3);
        llDie();    
    }
}
