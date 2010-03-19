// Name and Description
// Say Rotation
// This script says it's rotations in Quaternion and Vector when it's touched
//bpJ
// global variable that isn't exposed


// state sections
// default state # all scripts must have a default state
 
default
{
    // when a state is transitioned to, the state_entry event is raised
    state_entry()
    {

    }

    touch_start(integer number)
    {
    rotation gQuatRotation = llGetRot();
    llSay(0, "Quat rotation =" + (string)gQuatRotation);
    vector gRotation = llRot2Euler(gQuatRotation);
    llShout(0, "vector rotation =" + (string)gRotation);
//    key ownerKey = llGetOwner();
//      llSay(0, "owner's key = " + (string)ownerKey);
// llWhisper(0, "owner's key = " + (string)ownerKey);
// llInstantMessage(ownerKey, "owner's key = " + (string)ownerKey);
    }

}