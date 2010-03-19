rotation rot;
float height_offset;
vector rez_pos = <1.5, 0.0, 0.05>;
float speed = 95;

default
{
    attach(key id)
    {
        if(id != NULL_KEY)
        {
            vector size = llGetAgentSize(llGetOwner());
            height_offset = size.z / 2.9;
        }
    }
    state_entry()
    {
        vector size = llGetAgentSize(llGetOwner());
            height_offset = size.z / 2.9;
    }
    link_message(integer sender_num,integer num,string str,key id)
    {
        integer ammo = (integer)llGetObjectDesc();
        if(ammo > 0 && num > -1)
        {
            //llSay(0,(string)num);
            rot = llGetRot();
            //rez_pos = <2.5, 0.0, (integer)llFrand(0.5)>;
            //llMessageLinked(LINK_SET,0,"fire",NULL_KEY);
            ammo--;
            llMessageLinked(LINK_SET,-5,"fire",NULL_KEY);
            llSetObjectDesc((string)ammo);
            //llSleep(0.01);
            llRezObject(str, llGetPos() + ((rez_pos + <0.0, -0.02 + llFrand(0.08), height_offset + llFrand(0.08)>) * rot), (llRot2Fwd(rot) * speed) + llGetVel(), <0.00000, 0.70711, 0.00000, 0.70711> * rot, num);
            //llSleep(0.03);
        }
        
    }
}
