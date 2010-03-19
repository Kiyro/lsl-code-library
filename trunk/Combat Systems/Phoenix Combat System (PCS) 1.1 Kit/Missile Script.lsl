integer fireable;
integer ccc = 0;
default
{
    state_entry()
    {
        llListen(1, "", "", "");
//        llListen(2, "", "", "");        
    }

    on_rez(integer params)
    {
        llListen(1, "", "", "");
//        llListen(2, "", "", "");        
    }
    sensor(integer num_targets)
    {
            vector pos;
            rotation rot;
            rot = <0.00000, 0.70711, 0.00000, 0.70711>;
            rot *= llGetRot();
            pos = llGetPos();            
            llRezObject("Missile", pos + <0,0,2>, ZERO_VECTOR, rot, 1);
//            llMessageLinked(LINK_SET, 0, "sensor", NULL_KEY);
            llSleep(0.2);
            if(llDetectedKey(0) != llGetOwner())
            {
                llShout(2000, llDetectedName(0));
                llSay(0, "Locked onto target: " + llDetectedName(0));
            }
            else if(llDetectedKey(1) != NULL_KEY)
            {
                llShout(2000, llDetectedName(1));
                llSay(0, "Locked onto target: " + llDetectedName(1));
            }
            else
            {
                llSay(0, "No Targets to Lock On To.");
            }
            fireable = 0;
        
    }
    no_sensor()
    {
        llSay(0, "No Targets to Lock On To.");
        fireable = 0;
    }
    listen(integer chan, string name, key id, string msg)
    {
        if (llToLower(msg) == "arm" && id == llGetOwner() && ccc == 1)
        {
            llOwnerSay("Missile Armed");
            fireable = 1;
            llMessageLinked(LINK_SET, 0, "arm", "");
        }
        else if (llToLower(msg) == "arm2" && id == llGetOwner() && ccc == 1)
        {
            llOwnerSay("AG Missile Armed");
            fireable = 2;
            llMessageLinked(LINK_SET, 0, "arm", "");
        }
        
    }
    link_message(integer sender, integer number, string msg, key id)
    {
//        vector pos;
//        rotation rot;
 //       llOwnerSay(msg);

        if(msg == "fire_missile" && fireable == 1 && ccc == 1)
        {
            llSensor("", "", AGENT, 96.0, (12 * DEG_TO_RAD));
//            rot = <0.00000, 0.70711, 0.00000, 0.70711>;
//            rot *= llGetRot();
//            pos = llGetPos();            
//            llRezObject("Missile", pos + <0,0,2>, ZERO_VECTOR, rot, 1);
//            llMessageLinked(LINK_SET, 0, "sensor", NULL_KEY);
//            fireable = 0;
        }
        else if(msg == "fire_missile" && fireable == 2 && ccc == 1)
        {
            vector pos;
            vector vel;
            rotation rot;
            rot = llGetRot();               
            vel = llRot2Fwd(rot); 
            pos = llGetPos();
            pos += llRot2Fwd(rot) * 4;
            pos += llRot2Up(rot) * -2;
            vel = vel * 40.0;
//            rot = <0.00000, 0.70711, 0.00000, 0.70711>;
//            rot *= llGetRot();
//            pos = llGetPos();            

            llRezObject("AGMissile", pos, vel, rot, 1);

        }
        else if(msg == "ccc_on")
        {
            ccc = 1;
        }
        else if(msg == "ccc_off")
        {
            ccc = 0;
            fireable = 0;
        }

    }
}
