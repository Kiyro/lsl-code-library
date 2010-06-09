float speed=100;

default
{ 
    attach(key on)
    {
        llWhisper(0,"Visit Abbotts Aerodrome for fast 'n' shiny stuff. Abbotts (100,100).");
        llWhisper(0,"To set the speed, type 'speed,x' in chat where x is the speed.");
        if (on != NULL_KEY)
        {
            llListen(0,"",llGetOwner(),"");
            integer perm = llGetPermissions();
            if (perm != (PERMISSION_TAKE_CONTROLS))
            {
                llRequestPermissions(on, PERMISSION_TAKE_CONTROLS);
            }
            else
            {
                llTakeControls(CONTROL_FWD , TRUE, TRUE);
            }
        }
    }
    
    listen(integer channel, string name, key id, string m)
    {
        list test = llCSV2List(m);
        if(llGetListLength(test)==2&&llList2String(test,0)=="speed")
            speed=llList2Float(test,1);
    }

    run_time_permissions(integer perm)
    {
        if (perm)
        {
            llTakeControls(CONTROL_FWD, TRUE, TRUE);
        }
    }
    
    control(key owner, integer level, integer edge)
    {
        if (!(level & CONTROL_FWD) || !(llGetAgentInfo(llGetOwner())&AGENT_FLYING))
        {
            llSetForce(<0,0,0>, FALSE);
        }
        else
        {
            vector fwd= llRot2Fwd(llGetRot());
            fwd = llVecNorm(fwd);
            fwd *= speed;
            llSetForce(fwd, FALSE);
        }
    }
}