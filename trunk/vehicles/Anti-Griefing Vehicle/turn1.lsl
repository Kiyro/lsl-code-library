default
{
    link_message(integer part, integer code, string msg, key id)
    {
        if (msg == "piloted")
        {
            if (id != "")
            {
                llRequestPermissions(id, PERMISSION_TRACK_CAMERA);
            }
        }
    }

    run_time_permissions(integer p)
    {
        if (p & PERMISSION_TRACK_CAMERA)
        {
            vector aim;
            rotation ro;
            key id = llGetPermissionsKey();
            vector cor = ZERO_VECTOR;
            llSleep(0.05 * (integer)llGetSubString(llGetScriptName(), -1, -1));
            while(TRUE)
            {
                if (llGetAgentInfo(id) & AGENT_MOUSELOOK)
                {
                    aim = llRot2Fwd(llGetCameraRot());
                    cor = aim;
                    aim.z = 0.0;
                    ro = llRotBetween(<1, 0, 0>, aim) * llRotBetween(aim, cor);
                    llSetRot(ro);
                } else llSleep(0.2);
            }
        }
    }
}