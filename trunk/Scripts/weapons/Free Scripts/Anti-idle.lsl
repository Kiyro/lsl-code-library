default
{
    changed(integer change){
        if (change & 128){
            llResetScript();
        }
    }
    
    attach(key id){
        if (id != NULL_KEY){
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        }
    }
    
    run_time_permissions(integer perm){
        if (perm & PERMISSION_TRIGGER_ANIMATION){
            llSetTimerEvent(30);
        }
    }
    
    timer(){
        if (llGetPermissions() & PERMISSION_TRIGGER_ANIMATION){
            llStopAnimation("away");
        } else {
            llSetTimerEvent(0);
        }
    }
}