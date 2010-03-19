integer handle;
key owner;
string flttxt="Massage 1";
vector txtclr=<1.0,0,1.0>;

default
{
    state_entry()
    {
    llListenRemove(handle);
    handle = llListen(1, "", "", "");
    owner = llGetOwner();
    llSitTarget(<0,0,-1.01>, <0,0,0,0>); 
    llSetSitText("=^.^=");
    }
    
   // money(key id,integer amount)
   // {
   //     if(id == llGetOwner()){llResetScript();}
   // }
    
    on_rez(integer param)
    {
        if(owner != llGetOwner()){llResetScript();}
    }

    run_time_permissions(integer perms)
    {
        if (perms)
        {
        llSetTimerEvent(.25);
        }  
        else 
        {
        llSetTimerEvent(0.0);
        }
    }
    
    timer()
    {
        if(llGetAnimation(llAvatarOnSitTarget()) == "Sitting")
        {
        llStartAnimation(llGetInventoryName(INVENTORY_ANIMATION,0));
        llSetAlpha(0, ALL_SIDES);
        llSetText("",txtclr,3);
        }
        else
        {
        integer perm = llGetPermissions();
        if((perm & PERMISSION_TRIGGER_ANIMATION) == PERMISSION_TRIGGER_ANIMATION)
            {
            llStopAnimation(llGetInventoryName(INVENTORY_ANIMATION,0));
            llSetAlpha(100, ALL_SIDES);
            llSetText(flttxt,txtclr,3);
            llResetScript();
            }
        }

    }
    
   listen( integer channel, string name, key id, string msg )
    {
     if (msg == "hide") {
         llSetAlpha(0.0, ALL_SIDES);
         llSetText("",txtclr,3);
         }
     else if (msg == "show") {
         llSetAlpha(100.0, ALL_SIDES);
         llSetText(flttxt,txtclr,3);
         }
    }

    changed(integer change) 
    { 
        if (change & CHANGED_LINK) 
        { 
        key agent = llAvatarOnSitTarget(); 
            if (agent) 
            { 
        llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_TRIGGER_ANIMATION);
        llSitTarget(<.25,0,.9>, <0,0,0,0>); 
        llSetSitText("Nap Here");
        llStopAnimation("sit_generic");
        llStopAnimation("sit");
        llStopAnimation("sit_female");
        llStopAnimation("motorcycle_sit");
        llStopAnimation("sleep");
            } 

        }
    }
}
