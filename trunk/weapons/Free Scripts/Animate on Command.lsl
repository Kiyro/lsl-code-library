// change these variables as needed.
integer listenchannel = 3;  //channel to listen on
string anim = "Flop Dance"; //animation to play -- must be in object
string ontext ="startanim"; //text command to start the animation
string offtext ="stopanim"; //text command to stop the animation

//For the example, the commands would be:
//     /3startanim
//     /3stopanim

integer listener;
default
{
    on_rez(integer start_param)
    {
        if(listener!=0)
            llListenRemove(listener);
        listener=llListen(listenchannel,"",llGetOwner(),"");
    }
    state_entry()
    {
        if(listener!=0)
            llListenRemove(listener);
        listener=llListen(listenchannel,"",llGetOwner(),"");
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }
    listen(integer channel, string name, key id, string msg)
    {
       if (msg == ontext)
        {
            if ((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION && llGetPermissionsKey() == llGetOwner()))
            {
                    // If we do, we can animate:
                    llStartAnimation(anim);
                    llOwnerSay("Starting " + anim);
            }
            else {
                    // If we dont, ask for them:
                    llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
                    // We'll animate in the run_time_permissions event, which is triggered
                    // When the user accepts or declines the permissions request.
                }
     
        }
        if (msg == offtext)
        {
            if ((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION && llGetPermissionsKey() == llGetOwner()))
            {
                    // If we do, we can animate:
                    llStopAnimation(anim);
                    llOwnerSay("Stopping " + anim);
            }
            else {
                    // If we dont, ask for them:
                    llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
                    // We'll animate in the run_time_permissions event, which is triggered
                    // When the user accepts or declines the permissions request.
                }
        } 
    }
        run_time_permissions(integer perm)
    {
        if(perm)
        {
            // Place the code here!
            llStopAnimation("sit");
            llStartAnimation("stand");
        }
    }
}