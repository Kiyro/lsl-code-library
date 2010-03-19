// Non-Physical Flying Vehicle
// A.K.A: How to exploit tricks in LSL to get your way
//
// (your way being: up to 254 prims on a vehicle, in this case)
// Author: Jesrad Seraph
// Modify and redistribute freely, as long as your permit free modification and redistribution

integer hidden_face = 5;

float max_fwd = 2.0;        // max speed in m per quarter of a second
integer max_rot = 4;        // max turning speed in degrees per quarter of a second
float hover_height = 0.25;    // prefered minimum height above ground

integer down;
integer change;

float fwd_accel = 0.015625;    // forward/back acceleration
float up_accel = 0.015625;    // vertical acceleration
float left_accel = 0.015625;    // strafing acceleration
float rot_accel = 0.03125;    // turning acceleration

float inertia = 0.75;        // movement slowdown rate
float moment = 0.5;        // turning slowdown rate


// internal stuff, don't modify
vector velocity;
float rotacity;
vector veloff = <0.5, 0.5, 0.5>;
integer timeout;

integer controls;
key pilot;

stop()
{
    vector aim;
    llReleaseControls();
    llResetOtherScript("turn");
    llResetOtherScript("turn1");
    llResetOtherScript("turn2");
    llResetOtherScript("turn3");
    llResetOtherScript("rota");
    llResetOtherScript("rota1");
    llResetOtherScript("rota2");
    llResetOtherScript("rota3");
    llResetOtherScript("move");
    llResetOtherScript("move1");
    llResetOtherScript("move2");
    llResetOtherScript("move3");
    timeout = 0;
    llSetTimerEvent(0.0);
    pilot = NULL_KEY;
    velocity = ZERO_VECTOR;
    rotacity = 0.0;
    llSetColor(velocity + veloff, hidden_face);
    llSetAlpha(rotacity + 0.5, hidden_face);
    aim = llRot2Euler(llGetRot());
    aim.x = 0.0;
    aim.y = 0.0;
    llSetRot(llEuler2Rot(aim));
}

default
{
    state_entry()
    {
        controls = CONTROL_FWD|CONTROL_BACK|CONTROL_UP|CONTROL_DOWN|CONTROL_LEFT|CONTROL_RIGHT|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT;
        stop();
        llSitTarget(<0.25, 0.0, 0.4>, ZERO_ROTATION);
        llSetCameraAtOffset(<-1.0, 0.0, 2.0>);
        llSetCameraEyeOffset(<-3.0, 0.0, 2.0>);
        llSetSitText("PROTECT");
    }

    on_rez(integer param)
    {
        llResetScript();
    }

    changed(integer change)
    {
        //Make sure that the change is a link, so most likely to be a 
        // sitting avatar.
        if (change & CHANGED_LINK)
        {
            //The llAvatarSitOnTarget function will let us find the key 
            // of an avatar that sits on an object using llSitTarget
            // which we defined in the state_entry event. We can use 
            // this to make sure that only the owner can drive our vehicle.
            // We can also use this to find if the avatar is sitting, or is getting up, because both will be a link change.
            // If the avatar is sitting down, it will return its key, otherwise it will return a null key when it stands up.
            key agent = llAvatarOnSitTarget();

            //If sitting down.
            if (agent)
            {
                //We don't want random punks to come stealing our 
                // motorcycle! The simple solution is to unsit them,
                // and for kicks, send um flying.
                if (agent != llGetOwner())
                {
                    llSay(0, "You aren't the owner");
                    llUnSit(agent);
                    llPushObject(agent, <0,0,50>, ZERO_VECTOR, FALSE);
                }
                // If you are the owner, lets ride!
                else
                {
                    
                    llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
                    llStopAnimation("sit");
                    llStartAnimation("hover");
                    llSetAlpha(0.0, ALL_SIDES);     
                }
            }
            //The null key has been returned, so no one is driving anymore.
            else
            {
                
                llSetStatus(STATUS_PHYSICS, FALSE);
                llReleaseControls();
                llStopAnimation("sit");
                llSetAlpha(1.0, ALL_SIDES);                
                //llDie();
            }
        }

    }
    
    run_time_permissions(integer p)
    {
        if (p & PERMISSION_TAKE_CONTROLS)
        {
            llResetOtherScript("turn");
            llResetOtherScript("turn1");
            llResetOtherScript("turn2");
            llResetOtherScript("turn3");
            pilot = llGetPermissionsKey();
            llTakeControls(controls, TRUE, FALSE);
            velocity = ZERO_VECTOR;
            rotacity = 0.0;
            llSetColor(velocity + veloff, hidden_face);
            llSetAlpha(rotacity + 0.5, hidden_face);
            llMessageLinked(LINK_THIS, 0, "piloted", pilot);
        } else if (llGetPermissions() & PERMISSION_TAKE_CONTROLS == FALSE)
        {
            stop();
        }
    }

    control(key id, integer level, integer edge)
    {
        down = level;
        change = edge;
        
        if (down & controls)
        {
            if (timeout == 0)
            {
                llMessageLinked(LINK_THIS, max_rot, "nonphy", (key)((string)max_fwd));
                llSetTimerEvent(0.05);
            }
            timeout = 12;
        }
    }
    
    timer()
    {
        if (--timeout == 0)
        {
            llResetOtherScript("move");
            llResetOtherScript("move1");
            llResetOtherScript("move2");
            llResetOtherScript("move3");
            llResetOtherScript("rota");
            llResetOtherScript("rota1");
            llResetOtherScript("rota2");
            llResetOtherScript("rota3");
            llSetTimerEvent(0.0);
            return;
        }

        if (down & CONTROL_FWD)
        {
            if (velocity.x < 0.0) velocity.x = 0.0;
            velocity.x += fwd_accel;
            if (velocity.x > 0.5 ) velocity.x = 0.5;
        } else if (down & CONTROL_BACK)
        {
            if (velocity.x > 0.0) velocity.x = 0.0;
            velocity.x -= fwd_accel;
            if (velocity.x < -0.5 ) velocity.x = -0.5;
        } else {
            velocity.x *= inertia;
        }
        
        if (down & CONTROL_UP)
        {
            if (velocity.z < 0.0) velocity.z = 0.0;
            velocity.z += up_accel;
            if (velocity.z > 0.5 ) velocity.z = 0.5;
        } else if (down & CONTROL_DOWN)
        {
            if (velocity.z > 0.0) velocity.z = 0.0;
            velocity.z -= up_accel;
            if (velocity.z < -0.5 ) velocity.z = -0.5;
            if (llGetPos() * <0,0,1> < llGround(ZERO_VECTOR) + max_fwd * velocity.z + hover_height)
                velocity.z = 0.0;
        } else {
            velocity.z *= inertia;
            if (llGetPos() * <0,0,1> < llGround(ZERO_VECTOR) + max_fwd * velocity.z + hover_height)
                velocity.z = 0.0;
        }
        
        if (down & CONTROL_LEFT)
        {
            if (velocity.y < 0.0) velocity.y = 0.0;
            velocity.y += left_accel;
            if (velocity.y > 0.5 ) velocity.y = 0.5;
        } else if (down & CONTROL_RIGHT)
        {
            if (velocity.y > 0.0) velocity.y = 0.0;
            velocity.y -= left_accel;
            if (velocity.y < -0.5 ) velocity.y = -0.5;
        } else {
            velocity.y *= inertia;
        }
        
        if (down & CONTROL_ROT_LEFT)
        {
            if (rotacity < 0.0) rotacity = 0.0;
            rotacity += rot_accel;
            if (rotacity > 0.5 ) rotacity = 0.5;
        } else if (down & CONTROL_ROT_RIGHT)
        {
            if (rotacity > 0.0) rotacity = 0.0;
            rotacity -= rot_accel;
            if (rotacity < -0.5 ) rotacity = -0.5;
        } else {
            rotacity *= moment;
        }

        llSetColor(velocity * llGetRot() + veloff, hidden_face);
        llSetAlpha(rotacity + 0.5, hidden_face);
    }
}