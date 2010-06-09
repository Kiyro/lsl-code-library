rotation rot;
float height_offset;
vector rez_pos = <1.5, -0.0, -0.05>;
float speed = 95;
integer on = FALSE;
default
{
    state_entry()
    {
        vector size = llGetAgentSize(llGetOwner());
        height_offset = size.z / 2.9;
    }

    attach(key id)
    {
        if(id != NULL_KEY)
        {
            vector size = llGetAgentSize(llGetOwner());
            height_offset = size.z / 2.9;
        }
    }
    link_message(integer sender_num,integer num,string str,key id)
    {
        integer ammo = (integer)llGetObjectDesc();
        string firingmode = (string)id;
        if(ammo > 0 && (integer)firingmode > 1)
        {
            rot = llGetRot();
            ammo--;
            llSetObjectDesc((string)ammo);
            //llSleep(0.02);
            llRezObject(str, llGetPos() + ((rez_pos + <0.0, -0.02 + llFrand(0.08), height_offset + llFrand(0.08)>) * rot), (llRot2Fwd(rot) * speed) + llGetVel(), <0.00000, 0.70711, 0.00000, 0.70711> * rot, num);
            //llSleep(0.02);
        }
        else if(ammo < 0)
        {
            llSetObjectDesc("0");
        }   
    }
}