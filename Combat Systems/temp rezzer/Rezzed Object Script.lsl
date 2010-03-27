// Chat channel 
integer commChannel; 

default 
{ 
    state_entry() 
    { 
        // Makes the object temporary so the whole 0 prim part works 
        llSetPrimitiveParams([PRIM_TEMP_ON_REZ, TRUE]); 
    } 
     
    on_rez(integer param) 
    { 
        if (!param) 
            // If not rezzed by the rezzer this stops temporary so we can edit it 
            llSetPrimitiveParams([PRIM_TEMP_ON_REZ, FALSE]); 
        else 
        { 
            // Chat channel to use, passed to us as a rez parameter 
            commChannel = param; 
            llListen(commChannel, "", NULL_KEY, ""); 
        } 
    } 
     
    listen(integer channel, string name, key id, string message) 
    { 
        // Security - check the object belongs to our owner 
        if (llGetOwnerKey(id) != llGetOwner()) 
            return; 
        if (message == "derez") 
            llDie(); 
    } 
} 
