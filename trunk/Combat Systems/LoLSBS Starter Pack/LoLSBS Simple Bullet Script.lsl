//This is an example LoLSBS bullet script. This is a bit more simple than the previously released example bullet script.

//This script is only an example.



float LIFETIME = 5.0; //This sets how long the bullet will last in seconds before removing itself if it has not hit an object or an AV.

float BASEVELOCITY = 50; //This is the base velocity in meters  per second. The velocity will be adjusted by the start param set by the gun. A start param of 100 equals 100 percent of the base speed, 200 equals 200 percent of the base speed, etc... This is so that the bullet maker can control the bullet speed, and the gun maker can change it from the default if they need to for some special purpose. While this prevents gun makers from setting a specific speed for all LoLSBS bullets, it allows for easier use for non-standard bullets, such as grenades, artillery shells, etc...


init()
{
    //Preset the needed settings.
    llSetBuoyancy(1.0);
    llSetPrimitiveParams([PRIM_TEMP_ON_REZ, TRUE, PRIM_PHYSICS, TRUE]);
    llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
    llCollisionSound("", 0.0);
}

remove()
{
    //Remove the bullet.
    llSetStatus(STATUS_PHYSICS, FALSE); 
    llDie();
}

setVelocity(float velocity)
{
    //Applies the correct impulse to the bullet
    vector vect = ((<velocity,0,0> - llGetVel() / llGetRot()) * llGetMass());
    llApplyImpulse(vect,TRUE);
}

default
{
    state_entry()
    {
        init();   
    }
    
    on_rez(integer start_param)
    {
        //The bullet has been fired.
        llSetDamage(100); //Sets the damage the bullet will do if it hits an AV.
        setVelocity( (((float)start_param / 100) * BASEVELOCITY) ); //Sets the bullet in motion at the correct velocity in meters per second.
        llSetTimerEvent(LIFETIME);
    }

    collision_start(integer total_number)
    {
        if (llDetectedKey(0) != llGetOwner())
        {
            remove();
        }
    }
    
    land_collision_start(vector pos)
    {
        remove();
    }
    
    timer()
    {
        remove();
    }
}