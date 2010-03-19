
float gTimeout = 3.0;

default
{
    state_entry()
    {

    }

    attach(key id)
    {
        if (id != NULL_KEY)
        {
            llSetTimerEvent(0.0);
            llSetTimerEvent(gTimeout);
        }
        else
        {
            llSetTimerEvent(0.0);
        }
    }
    
    timer()
    {
        llMakeFire(
        2,  // nParticles
        1.0,  // scale
        1.0,  // velocity
        5.0,  // lifetime
        2*PI, // arc
        "steam",
        <0.0, 0.0, 1.0> // offset
        ); 
    }       
}
