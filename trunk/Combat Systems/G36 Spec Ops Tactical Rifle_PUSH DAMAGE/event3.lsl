 integer lid;
  integer listener; key owner;
default
{
    state_entry()
    {
     
    }

on_rez(integer param)
    {
       
        owner = llGetOwner(); llListenRemove(listener); listener = llListen(0,"",owner,"");
      llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION); ;
    }
        

   



    listen(integer channel, string name, key id, string message)
    {
        if(message=="r"){
           
             llMessageLinked(LINK_SET, 0, "reload", NULL_KEY);
             llStartAnimation("gun reload");
             llMessageLinked(LINK_SET, 0, "Eclip", NULL_KEY);
        }
        if(message=="help"){
          llGiveInventory(owner, "G36 Specs Ops");    
        }
    }
            
    }