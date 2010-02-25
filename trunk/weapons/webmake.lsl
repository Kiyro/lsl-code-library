//
//  Popgun pellet
//

vector velocity;
integer shot = FALSE; 
integer fade = FALSE;
float alpha = 1.0;

default
{
    state_entry()
    {
        llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
    }
    
    on_rez(integer start_param)
    {
        llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
        llSetBuoyancy(1.0);
        llCollisionSound("", 1.0);          //  Disable collision sounds
        velocity = llGetVel();
        float vmag;
        vmag = llVecMag(velocity);
        if (vmag > 0.1) shot = TRUE;
        llSetTimerEvent(5.0);
    }

    collision_start(integer num)
    {
        if (llDetectedType(0) & AGENT)
        {
           // llTriggerSound("frozen", 1.0);
            llRezObject(">:)", llDetectedPos(0), ZERO_VECTOR, llGetRot(), 0);
        }
        llDie();
    }
    
    timer()
    {
        if (!fade)
        {
            if (shot)
            {
                llDie();       
            }
        }   
        else
        {
            llSetAlpha(alpha, -1);
            alpha = alpha * 0.95;  
            if (alpha < 0.1) 
            {
                llDie();
            }     
        }
    }
}
