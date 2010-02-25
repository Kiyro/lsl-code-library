integer hidden_face = 5;

float max_vel;
vector veloff = <-0.5, -0.5, -0.5>;

default
{
    link_message(integer part, integer code, string msg, key id)
    {
        if (msg != "nonphy") return;
        max_vel = (float)((string)id);
        llSleep(0.05 * (integer)llGetSubString(llGetScriptName(), -1, -1));

        while(TRUE)
        {
            llSetPos(max_vel * (llGetColor(hidden_face) + veloff) + llGetPos());
            llSetPos(max_vel * (llGetColor(hidden_face) + veloff) + llGetPos());
            llSetPos(max_vel * (llGetColor(hidden_face) + veloff) + llGetPos());
            llSetPos(max_vel * (llGetColor(hidden_face) + veloff) + llGetPos());
            llSetPos(max_vel * (llGetColor(hidden_face) + veloff) + llGetPos());
        }
    }
}