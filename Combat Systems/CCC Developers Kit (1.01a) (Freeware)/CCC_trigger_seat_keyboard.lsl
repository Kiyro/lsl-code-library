// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- Variables
key agentKey;
integer permissionResult;

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- States

default
{
    state_entry()
    {
        agentKey = NULL_KEY;
        permissionResult = FALSE;
    }

    on_rez(integer times)
    {
        llResetScript();
    }

    changed(integer change)
    {
        
        if (change & CHANGED_LINK)
        {
            key agent = llAvatarOnSitTarget();
            if ( agentKey == NULL_KEY && agent != NULL_KEY )
            {
                agentKey = agent;
                llRequestPermissions(agentKey,PERMISSION_TAKE_CONTROLS);
            }
            else if ( agentKey != NULL_KEY && agent == NULL_KEY)
            {
                if (permissionResult)
                {
                    llReleaseControls();
                }
                llResetScript();
            }
        }        
    }
    
    control(key id, integer level, integer edge)
    {
        if ( ( level & CONTROL_LBUTTON ) && ( edge & CONTROL_LBUTTON ) )
        {
            llMessageLinked(LINK_SET, 0, "fire", "");
        }
        else if ( !( level & CONTROL_LBUTTON ) && ( edge & CONTROL_LBUTTON ) )
        {
            llMessageLinked(LINK_SET, 0, "cease fire", "");
        }
    }

    run_time_permissions(integer value)
    {
        if (value == PERMISSION_TAKE_CONTROLS)
        {
            permissionResult = TRUE;
            llTakeControls(CONTROL_LBUTTON, TRUE, FALSE);
        }
    }
}