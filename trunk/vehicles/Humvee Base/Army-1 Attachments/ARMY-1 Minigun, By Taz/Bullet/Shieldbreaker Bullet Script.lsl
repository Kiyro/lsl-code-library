//
//  Winter's Shieldbreaker Bullet
//  Modified from the Bolter Round
//

vector velocity;
integer shot = FALSE; 
integer fade = FALSE;
float alpha = 1.0;
float damage = 0;
float hitpower = 1000000000;
float lifetime = 5;
integer push = 9999;

explode()
{
    llSetStatus(STATUS_PHYSICS, FALSE); 
    vector vel = llGetVel() * hitpower;
    llPushObject(llDetectedKey(0), vel, ZERO_VECTOR, FALSE);
    llSetForce(<0,0,0>, TRUE);
    llMakeExplosion(20, 1, 1, 1, 1, "Smoke", ZERO_VECTOR);
    llDie();
}

nuke(key person,vector target_normalised_vector)
{
    llUnSit(person);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    llPushObject(person,llPow(push,6.42)*target_normalised_vector,ZERO_VECTOR,FALSE);
    // okay fine i know it's a bit excessive :P
}

default
{
    state_entry()
    {
        llSetDamage(damage);
    }
    
    on_rez(integer start_param)
    {
        llSensorRepeat("",NULL_KEY,AGENT,96,PI,0.001);
        llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
        llSetBuoyancy(1.0);
        llCollisionSound("", 1.0);          //  Disable collision sounds
        velocity = llGetVel() * 5;
        float vmag;
        vmag = llVecMag(velocity);
        if (vmag > 0.1) shot = TRUE;
        llSetTimerEvent(lifetime);
    }
    
    collision_start(integer total_number)
    {
        explode();
    }
    
    timer()
    {
        if (!fade)
        {
            if (shot)
            {
                explode();
            }
        }   
        else
        {
            llSetAlpha(alpha, -1);
            alpha = alpha * 0.999999;  
            if (alpha < 0.1) 
            {
                explode();
            }     
        }
    }
}