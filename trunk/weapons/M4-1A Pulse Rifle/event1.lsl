 integer lid;
  integer listener; key owner;
default
{
    state_entry()
    {
      
       
    }

on_rez(integer param)
    {
        llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION); 
        owner = llGetOwner(); llListenRemove(listener); listener = llListen(0,"",owner,"");
         llMessageLinked(LINK_SET, 0, "safety on", "");
          llMessageLinked(LINK_SET, 0, "reload", "");
          llSleep(1.0);
          llMessageLinked(LINK_SET, 0, "reloadd", "");
         llStartAnimation("gun reload");
         llSay(0,"say help for a notecard");
    }
        

   



    listen(integer channel, string name, key id, string message)
    {
        if(message=="safe"){
             llMessageLinked(LINK_SET, 0, "safety on", "");
             //llSetText("Safe", <0.0, 1.0, 0.0>, 0.75);
             
            
        }
        if(message=="unsafe"){
            llMessageLinked(LINK_SET, 0, "safety off", "");
            
            //llSetText("", <0,1,0>, 0.0);
  
        }
        
    }
            
} 