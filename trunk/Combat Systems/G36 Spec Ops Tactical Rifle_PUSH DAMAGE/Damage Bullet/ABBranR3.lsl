

test( integer chargeval )
{
    
    float SoundVal = llFrand(100);
    if (SoundVal <= 33) llTriggerSound("687bc9f2-76de-9551-3b70-91247785460f", 10.0);
    else if (SoundVal >= 66) llTriggerSound("c3ee3ba2-fee1-7ef1-bc0e-c18273331d05", 10.0);             
    else llTriggerSound("9a24a9bc-15f6-d6f1-faf5-202ef0dc22cd", 10.0); 
}

default
{
    state_entry()
    {
       
    }

    collision_start(integer chargeval)
    {
        
       
    }
    land_collision_start(vector pos)
    {
     
     test(0);
     llDie();
     
    }
}   

