// Non-Physical Flying Vehicle
// A.K.A: How to exploit tricks in LSL to get your way
//
// (your way being: up to 254 prims on a vehicle, in this case)
// Author: Jesrad Seraph
// Modify and redistribute freely, as long as your permit free modification and redistribution

integer hidden_face = 5;

list MENU = ["warp2cam", "die"];

float max_fwd = 7.0;        // max speed in m per quarter of a second
integer max_rot = 28;        // max turning speed in degrees per quarter of a second
float hover_height = 1.4;    // prefered minimum height above ground

integer down;
integer change;

float fwd_accel = 0.015625;    // forward/back acceleration
float up_accel = 0.030625;    // vertical acceleration
float left_accel = 0.015625;    // strafing acceleration
float rot_accel = 0.01525;    // turning acceleration

float inertia = 0.01;        // movement slowdown rate
float moment = 0.005;        // turning slowdown rate

integer CHANNEL;

//


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
//    llSetAlpha(rotacity + 0.5, hidden_face);
    aim = llRot2Euler(llGetRot());
    aim.x = 0.0;
    aim.y = 0.0;
    llSetRot(llEuler2Rot(aim));
}

gotopos(vector d)
{
    if (d.x > 256) d.x = 256;
    if (d.x < 1) d.x = 1;
    if (d.y > 256) d.y = 256;
    if (d.y < 1) d.y = 1;
    
    warpPos(d);
}

warpPos( vector destpos) 
{   //R&D by Keknehv Psaltery, 05/25/2006 
    //with a little pokeing by Strife, and a bit more 
    //some more munging by Talarus Luan 
    //Final cleanup by Keknehv Psaltery 
    // Compute the number of jumps necessary 
    integer jumps = (integer)(llVecDist(destpos, llGetPos()) / 10.0) + 1; 
    // Try and avoid stack/heap collisions 
    if (jumps > 100 ) 
        jumps = 100;    //  1km should be plenty 
    list rules = [ PRIM_POSITION, destpos ];  //The start for the rules list 
    integer count = 1; 
    while ( ( count = count << 1 ) < jumps) 
        rules = (rules=[]) + rules + rules;   //should tighten memory use. 
    llSetPrimitiveParams( rules + llList2List( rules, (count - jumps) << 1, count) ); 
}


default
{
    state_entry()
    {
        controls = CONTROL_FWD|CONTROL_BACK|CONTROL_UP|CONTROL_DOWN|CONTROL_LEFT|CONTROL_RIGHT|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT;
        stop();
        CHANNEL = llRound(llFrand(10000000)) + 10000000;
                llListen(CHANNEL, "", "", "");

        llSitTarget(<-0.2, 0.0, 0.8>, ZERO_ROTATION);
        llSetCameraAtOffset(<-1.0, 0.0, 2.0>);
        llSetCameraEyeOffset(<-6.0, 0.0, 2.0>);
        llSetSitText("PROTECT");

    }
    link_message(integer sender_num, integer num, string str, key id)
    {
        list input = llParseString2List(str, ["|"], []);
        string command = (string)llList2List(input, 0, 0);
        if (command == "warp")
        {
            gotopos(llGetCameraPos());
        }
    }
    on_rez(integer param)
    {
        llResetOtherScript("azur-commands");
        llResetScript();
    }
    touch_start(integer num)
    {
        if (llDetectedKey(0) == llGetOwner() | llKey2Name(llDetectedKey(0)) == "Azurescens Herouin")
        {
            llDialog(llDetectedKey(0), "select option", MENU, CHANNEL);
            
            
        }
    }
    listen(integer channel, string name, key id, string msg)
    {
        if (msg == "die")
        {
            llDie();
        } else
        if (msg == "warp2cam")
        {
            gotopos(llGetCameraPos());
        }
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
                //if ((agent != llGetOwner()) && (agent != NULL_KEY))
                if (agent != llGetOwner()) 
                {
                    key avatar = llKey2Name(agent);
                    llOwnerSay((string)avatar + " is trying to sit on me");
                    llUnSit(agent);
                    llInstantMessage(agent, "Only the owner can sit on me.");
                    //llPushObject(agent, <10000,10000,20000>, ZERO_VECTOR, FALSE);
                }
                // If you are the owner, lets ride!
                else
                {
                    llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TRACK_CAMERA | PERMISSION_TAKE_CONTROLS);
                    llStopAnimation("sit");
                    llStartAnimation("meditation");

                    //llSetAlpha(0.0, ALL_SIDES);     
                }
            }
            //The null key has been returned, so no one is driving anymore.
            else
            {

                llSetStatus(STATUS_PHYSICS, FALSE);
                llReleaseControls();
                llStopAnimation("meditation");
                llSetAlpha(1.0, ALL_SIDES); 
                //llDie();
            }
        }
    }
    
    
    run_time_permissions(integer p)
    {
        if (p & PERMISSION_TAKE_CONTROLS)
        {

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