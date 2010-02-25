// CATEGORY:Vehicle
// CREATOR:Ferd Frederiex
// DESCRIPTION:seat script bumper car.lsl
// ARCHIVED BY:Ferd Frederix

default
{
    state_entry()
    {
        llSetSitText("Sit");
        llSitTarget(<0.04,-0.3,0.45>, <0,0,180,-180>);
        llSetCameraEyeOffset(<-8.0, 0.0, 3.0>);
        llSetCameraAtOffset(<4.0, 0.0, 2.0>);
    }
    changed(integer change)
    {
        if (CHANGED_LINK)
        {
            key agent = llAvatarOnSitTarget();
            if (agent)
            {
            }
            else
            {
                llPushObject(agent, <0,0,10>, ZERO_VECTOR, FALSE);
            }
        }
        
    }
}
// END //
