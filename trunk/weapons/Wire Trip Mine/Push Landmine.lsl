float force_amount = 999999999999999999999999999999.0;

default
{
    on_rez(integer start_param)
    {
        llPreloadSound("Explosion");
        }
        collision_start(integer total_number)
        {
            llSetDamage(5000);
            if (llDetectedType(0) & AGENT)
            llPushObject(llDetectedKey(0), force_amount*llRot2Up(llGetRot()), ZERO_VECTOR, FALSE);
            llTriggerSound("Explosion", 10.0);
            llMakeExplosion(20, 1.0, 5, 3.0, 1.0, "Smoke", ZERO_VECTOR);
            llMakeExplosion(20, 1.0, 5, 3.0, 1.0, "fire", ZERO_VECTOR);
            llDie();
        }
    }

