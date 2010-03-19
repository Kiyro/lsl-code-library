default
{
    state_entry()
    {
        llSetSitText(" ");
        llSitTarget(<0.0,0.0,0.8>, <0,0,0,0>);
    }
    changed(integer change)
    {
        if (CHANGED_LINK)
        {
            key agent = llAvatarOnSitTarget();
            if (agent)
            {
            llUnSit(agent);
            }
            else
            {
                llUnSit(agent);
            }
        }
        
    }
}
