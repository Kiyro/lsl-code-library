. // Remove this line to activate script.

// Sit target system by Lex Neva.  Please distribute willy-nilly.

default
{
    touch_start(integer total_number) {
        llSensor("Sit Target Helper", NULL_KEY, ACTIVE|PASSIVE, 96, PI);
        llSay(0, "Searching for Sit Target Helper...");
    }
    
    no_sensor() {
        llSay(0, "Sit Target Helper not found.  No sit target set.");
        llSitTarget(ZERO_VECTOR, ZERO_ROTATION);
    }
    
    sensor(integer num) {
        if (num > 1) {
            llSay(0, "Multiple Sit Target Helpers found.  Using closest helper.");
        } else {
            llSay(0, "Sit Target Helper found.  Setting sit target.");
        }
        
        vector   helper_pos = llDetectedPos(0);
        rotation helper_rot = llDetectedRot(0);
        
        vector   my_pos = llGetPos();
        rotation my_rot = llGetRot();
        
        // calculate where the avatar actually is
        vector avatar_pos = helper_pos + <0,0,1> * helper_rot; // due to helper's sit target
        avatar_pos = avatar_pos - <0,0,0.186> + <0,0,0.4> * helper_rot; // correct for a bug in llSitTarget(), for helper sit target
        
        vector target_pos = (avatar_pos - my_pos) / my_rot;
        target_pos = target_pos + <0,0,0.186>/my_rot - <0,0,0.4>; // correct for the bug again, this time in my sit target
        rotation target_rot = helper_rot / my_rot;
        
        llSitTarget(target_pos, target_rot);
        llSay(0, "llSitTarget(" + (string)target_pos + ", " + (string)target_rot + ");");
        llSay(0, "
// Paste the following LSL code into a new script in this prim.  Be sure to delete this \"" + llGetScriptName() + "\" script when you're done!
//
// Basic sit-pose script by Lex Neva
default
{
    state_entry() {
        llSitTarget(" + (string)target_pos + ", " + (string)target_rot + ");
    }
        
    changed(integer change) {
        if (llAvatarOnSitTarget() != NULL_KEY)
            llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_TRIGGER_ANIMATION);       
    }
    
    run_time_permissions(integer perm) {
        string anim = llGetInventoryName(INVENTORY_ANIMATION, 0);
        if (anim != \"\") {
            llStopAnimation(\"sit\");
            llStartAnimation(anim);
        }
    }
}");        
    }
    
    changed(integer change) {
        if (llAvatarOnSitTarget() != NULL_KEY)
            llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_TRIGGER_ANIMATION);       
    }
    
    run_time_permissions(integer perm) {
        string anim = llGetInventoryName(INVENTORY_ANIMATION, 0);
        if (anim != "") {
            llStopAnimation("sit");
            llStartAnimation(anim);
        }
    }
}
