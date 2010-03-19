key target;
integer lid;
float chann;
integer chan;
list List;
  integer listener; key owner;
default
{
    state_entry()
    {
        
        
        llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
        llMessageLinked(LINK_SET,0,"db",NULL_KEY); 
    }
    
    on_rez(integer start_param)
    {
        
        List = [];
        
        
        chan = (integer)llFrand(1000.0) + 1; // starts listening on a channel of 1 or higher up to 1000
        owner = llGetOwner(); llListenRemove(listener); listener = llListen(chan,"",owner,"");
        llListen(chan,"",NULL_KEY,"");
        llMessageLinked(LINK_SET,0,"db",NULL_KEY);
        llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
    }

    touch_start(integer total_number)
    {if ( llDetectedKey(0) == llGetOwner() )
        {
        target = llDetectedKey(total_number - 1);
        llDialog(llDetectedKey(total_number - 1),"XX G36 Spec Ops Options",["Silencer On", "Silencer Off","Aim","Noaim","Push Bullet","Dmg Bullet" ], chan);
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "Push Bullet")
        {
            llMessageLinked(LINK_SET,0,"pb",NULL_KEY);
            llMessageLinked(LINK_SET,0,"reload",NULL_KEY); 
        }
        
        if (message == "Dmg Bullet")
        {
            llMessageLinked(LINK_SET,0,"db",NULL_KEY);
            llMessageLinked(LINK_SET,0,"reload",NULL_KEY); 
        }
        
        if (message == "Silencer On")
        {
            llPlaySound("18f6d98d-8a76-be6f-f219-9271fbcdbc95",1.0);
            llMessageLinked(LINK_SET,0,"son",NULL_KEY);
            
        }
        
        if (message == "Silencer Off")
        {
            llPlaySound("18f6d98d-8a76-be6f-f219-9271fbcdbc95",1.0);
            llMessageLinked(LINK_SET,0,"soff",NULL_KEY);
            
        }
        if (message == "Aim")
        {
            //llMessageLinked(LINK_SET,0,"soff",NULL_KEY);
            llStartAnimation("aim_r_rifle");
                llStopAnimation("hold_r_rifle");
            
        }
        if (message == "Noaim")
        {
            //llMessageLinked(LINK_SET,0,"soff",NULL_KEY);
            llStartAnimation("hold_r_rifle");
                llStopAnimation("aim_r_rifle");
            
        }
    }
}
