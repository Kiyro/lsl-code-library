default
{
    state_entry()
    {
        llSetSitText("Teleport");
         
         //Sit target coordinates are <X, Y, Z> change the numbers to change where you end up.
        llSitTarget(<13,119,40>, ZERO_ROTATION); 
        
        llSetCameraEyeOffset(<-8.0, 0.0, 47.0>);
        
        // it's usually best to match the camera offset to your sit target
        llSetCameraAtOffset(<0,0,45>);
    }
    changed(integer change)
    {
        if (CHANGED_LINK)
        {
            key agent = llAvatarOnSitTarget();
            if (agent)
            {
                llUnSit( agent);
                llPushObject(agent, <0,0,10>, ZERO_VECTOR, FALSE);
                
            }
            else
            {
            }
        }
        
    }
}
