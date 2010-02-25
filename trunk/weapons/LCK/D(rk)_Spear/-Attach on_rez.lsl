//•/•/•/•/•/•/•/Ð/A/M/E/N/•/H/A/X/•/•/•/•/•/•/•/•/•//

default 
{
    on_rez(integer num_detected) 
    {
    llRequestPermissions(llGetOwner(), PERMISSION_ATTACH);
    }
    
    run_time_permissions(integer Perms) 
    {
        if (Perms == PERMISSION_ATTACH) llAttachToAvatar(ATTACH_RHAND);
        // ATTACH_HEAD  head  
        // ATTACH_LSHOULDER  left shoulder  
        // ATTACH_RSHOULDER  right shoulder  
        // ATTACH_LHAND  left hand  
        // ATTACH_RHAND  right hand  
        // ATTACH_LFOOT  left foot  
        // ATTACH_RFOOT  right foot  
        // ATTACH_BACK  back  
        // ATTACH_PELVIS  pelvis  
        // ATTACH_MOUTH  mouth  
        // ATTACH_CHIN  chin  
        // ATTACH_LEAR  left ear  
        // ATTACH_REAR  right ear  
        // ATTACH_LEYE  left eye  
        // ATTACH_REYE  right eye  
        // ATTACH_NOSE  nose  
        // ATTACH_RUARM  right upper arm  
        // ATTACH_RLARM  right lower arm  
        // ATTACH_LUARM  left upper arm  
        // ATTACH_LLARM  left lower arm  
        // ATTACH_RHIP  right hip  
        // ATTACH_LHIP  left hip  
        // ATTACH_RULEG  right upper leg  
        // ATTACH_RLLEG  right lower leg  
        // ATTACH_LULEG  left upper leg  
        // ATTACH_LLLEG  left lower leg  
        // ATTACH_BELLY  belly/stomach/tummy  
        // ATTACH_RPEC  right pectoral  
        // ATTACH_LPEC  left pectoral
    }
}