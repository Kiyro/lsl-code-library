//•/•/•/•/•/•/•/Ð/A/M/E/N/•/H/A/X/•/•/•/•/•/•/•/•/•//

//Found on the net, modified some, have fun~
 
vector CAMERA_OFFSET = <2,0,0>;
integer MAXJUMPS = 30;  // Maximum number of jumps before quitting
float FUZZINESS = 2.0; // Don't jump unless you're going at least this far.
float CAMERA_FUZZINESS = 1.5; // How far off we expect the camera to be.
float TAU = 0.045;
string sim_name;
key owner;
float ownermass;
vector camera;
integer tnum;
integer countdown;
vector offset;
 
end_jump()
{
    if(tnum) llTargetRemove(tnum);
    tnum = 0;
    countdown = 0;
    llStopMoveToTarget();
    llParticleSystem( [ ] );
}
 
default
{
    state_entry()
    {
        owner = llGetOwner();
        end_jump();
        if ( llGetAttached() )
        llRequestPermissions(owner = llGetOwner(), PERMISSION_TRACK_CAMERA);
        offset = CAMERA_OFFSET;
    }
//
    run_time_permissions(integer what)
    {
        if(what & PERMISSION_TRACK_CAMERA)
        {
            vector new_offset =
                (llGetPos() - llGetCameraPos()) / llGetCameraRot();
            if(llVecDist(CAMERA_OFFSET,new_offset) < CAMERA_FUZZINESS)
            {
                //offset = new_offset;
            }
        }
    }
//
    on_rez(integer total_number)
    {
        if (owner != llGetOwner()) 
        {
            llResetScript();
            owner = llGetOwner();
        }
    }
//
   link_message(integer sender, integer num, string str, key id)
    {
        if (str == "TP-2-CAM") 
        {
        if(countdown > 0) // click during move to cancel
        {
            end_jump();
            return;
        }
        if(llVecDist(camera = llGetCameraPos() + (offset * llGetCameraRot()),llGetPos()) < FUZZINESS) return;
//        llOwnerSay("Camera Position: " + (string)camera);
//        llOwnerSay("Your Position: " + (string)llGetPos());
//        llOwnerSay("Distance: " + (string)llVecDist(camera, llGetPos()));
        sim_name = llGetRegionName();
        ownermass = llGetObjectMass(owner);
        countdown = MAXJUMPS;
        llMoveToTarget(camera, TAU);
        llTriggerSound("81a51389-94ef-e874-3d08-6a065d249f67", 5.0);
//        llApplyImpulse((camera - llGetPos()) * llGetMass(), FALSE);
        tnum = llTarget(camera, 0.001);
        }
    }
//
    collision_start(integer n)
    {
//        if(countdown > 0)
//            end_jump();
    }
//
    land_collision(vector pos)
    {
//        if(countdown > 0)
//            end_jump();
    }
//
    not_at_target()
    {
        if(sim_name == llGetRegionName())
        {
            if(countdown-- > 0)
                llMoveToTarget(camera, TAU);
            else
                end_jump();
        }
        else
        {
            llOwnerSay("Sim border Dectected; Activating Improbability Drive~");
            if(camera.x > 256)
                camera.x -= 256;
            else if(camera.x < 0)
                camera.x += 256;
            if(camera.y > 256)
                camera.y -= 256;
            else if(camera.y < 0)
                camera.y += 256;
            if(camera.z > 256)
                camera.z -= 256;
            else if(camera.z < 0)
                camera.z += 256;
            llMoveToTarget(camera, 0.1);
            tnum = llTarget(camera, TAU);
            sim_name = llGetRegionName();
            countdown = MAXJUMPS;
        }
    }
//
    at_target(integer tnum, vector targetpos, vector ourpos)
    {
        end_jump();
    }  
//
}
 