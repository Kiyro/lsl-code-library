integer hidden_face = 5;
float max_vel;

default
{
    link_message(integer part, integer code, string msg, key id)
    {
        if (msg != "nonphy") return;
        max_vel = (float)code * DEG_TO_RAD;
        llSleep(0.05 * (integer)llGetSubString(llGetScriptName(), -1, -1));
        while(TRUE)
        {
            llSetRot(llGetRot() * llEuler2Rot(<0,0,max_vel * (llGetAlpha(hidden_face) - 0.5)>) );
            llSetRot(llGetRot() * llEuler2Rot(<0,0,max_vel * (llGetAlpha(hidden_face) - 0.5)>) );
            llSetRot(llGetRot() * llEuler2Rot(<0,0,max_vel * (llGetAlpha(hidden_face) - 0.5)>) );
            llSetRot(llGetRot() * llEuler2Rot(<0,0,max_vel * (llGetAlpha(hidden_face) - 0.5)>) );
            llSetRot(llGetRot() * llEuler2Rot(<0,0,max_vel * (llGetAlpha(hidden_face) - 0.5)>) );
        }
    }
}