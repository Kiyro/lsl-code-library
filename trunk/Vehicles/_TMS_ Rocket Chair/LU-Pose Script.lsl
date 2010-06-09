string TITLE="";            
string ANIMATION=""; 
string sit_text="";
key avatar;
key trigger;

key dataserver_key = NULL_KEY;


use_defaults()
{
    llSetSitText(sit_text);
        llSetText(TITLE,<1,1,1>,0.7);
}

init()
{

    if(llGetInventoryNumber(INVENTORY_ANIMATION) == 0)      
    {
        llWhisper(0,"Error: No animation found. Cannot pose.");
        ANIMATION = "sit";
    }
    else
        ANIMATION = llGetInventoryName(INVENTORY_ANIMATION,0);
}

default
{
    state_entry()
    {
        llSitTarget(<-0.05933, -0.05097, 0.36168>, <0.00000, 0.00000, 0.00000, 1.00000>); 
        init();
    }
        
    touch_start(integer detected)
    {
        
    }
    
    changed(integer change)
    {
        if(change & CHANGED_LINK)
        {
            avatar = llAvatarOnSitTarget();
            if(llKey2Name(avatar) != "")
            {
                llRequestPermissions(avatar, PERMISSION_TRIGGER_ANIMATION);
            }
            else
            {
                if (llKey2Name(llGetPermissionsKey()) != "" && trigger == llGetPermissionsKey()) 
                {
                    llStopAnimation(ANIMATION);
                    trigger = NULL_KEY;
                }
            }
        }
    }
    
    run_time_permissions(integer perm)
    {
        avatar = llAvatarOnSitTarget();
        if(perm & PERMISSION_TRIGGER_ANIMATION && llKey2Name(avatar) != "" && avatar == llGetPermissionsKey())
        {
            trigger = avatar;
            llStopAnimation("sit");
            llStartAnimation(ANIMATION);
            llSetText("",<1,1,1>,0);
        }
    }
}  