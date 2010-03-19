test( integer chargeval )
{
    
    float SoundVal = llFrand(100);
    if (SoundVal <= 33) llTriggerSound("ric2.wav", 10.0);
    else if (SoundVal >= 66) llTriggerSound("ric1.wav", 10.0);             
    else llTriggerSound("ric4.wav", 10.0); 
}

default
{
    state_entry()
    {
        //llSay(0, "Hello, Avatar!");
    }

    collision_start(integer chargeval)
    {
        test( (integer) chargeval );
}
}
