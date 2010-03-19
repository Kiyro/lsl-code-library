integer flag = 0;


default
{
    state_entry()
    {
      llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
         
    }

    run_time_permissions(integer parm)
    {
    if(parm == PERMISSION_TRIGGER_ANIMATION)
        {
       //llWhisper(0,"Coco make you feel better :)");
        
        llSetTimerEvent(15);
       
         llStartAnimation("hold_R_handgun");
         }
    
    }

    on_rez(integer st)
    {
    llResetScript();
    }

    attach(key id)
    {
    llStopAnimation("hold_R_handgun");
    }
    
    
    
    
   timer()
   {
    
    if(flag == 1)
    {
    llStartAnimation("drink");
    }
    
    if(flag == 3)
    {
    llStartAnimation("drink");
    }

    flag = flag + 1;
    
    if(flag == 4)
    {
    flag = 0;
    }    
    
    }
    
     
      
       
     listen(integer channel, string name, key id, string message)
    {
    }


}
