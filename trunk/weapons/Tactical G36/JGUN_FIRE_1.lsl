integer mychan; //like 4chan?
float   height;
string  bullet;
float   rezvel;
integer reztype;
float  sprd = 0;
float  rezsprd = 0;
vector scriptoffset = <0.0,0.0,0>;
default
{
    state_entry()
    {
        if (llGetAttached() == 6)
        {
            llRequestPermissions(llGetOwner(), PERMISSION_TRACK_CAMERA);
            mychan = 10 + (integer)llGetSubString(llGetScriptName(), 10, 10);
            vector scale = llGetAgentSize(llGetOwner());
            height = scale.z/2;
            rezvel = 120.0;
        }
    }
    
    link_message(integer snd, integer chn, string msg, key uid)
    {
        if (chn == mychan)
        {
             vector velo = < 120, 0.0 , 0.0 >; 
        rotation spy = llEuler2Rot( llRot2Euler(llGetCameraRot())+(<-(sprd/2)+llFrand(sprd),-(sprd/2)+llFrand(sprd),-(sprd/2)+llFrand(sprd)>*DEG_TO_RAD));        
        llRezObject(msg,(llGetCameraPos() + scriptoffset +(llRot2Fwd(llGetCameraRot())*4))+<0,-(rezsprd/2)+llFrand(rezsprd),-(rezsprd/2)+llFrand(rezsprd)>*llGetRot(),velo*spy,spy,1);
            llMessageLinked(LINK_SET , 0, "muzzleflash", NULL_KEY);
        }
    }
}