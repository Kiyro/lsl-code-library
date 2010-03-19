default
{
    state_entry()
    {
      llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
         
    }

   
    run_time_permissions(integer perm)
    {
            
            llStartAnimation("sleep");

    }
        on_rez(integer st)
    {
    llResetScript();
    }
        attach(key id)
    {
    llStopAnimation("sleep");
    }
    
    
    
}