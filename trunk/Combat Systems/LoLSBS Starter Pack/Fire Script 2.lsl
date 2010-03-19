integer number = 2;

default
{
    state_entry()
    {
    }

    link_message(integer sender_num, integer num, string str, key id)
    {
        if (num == number)
        {
            list variables = llCSV2List(str);
            
            string name = llList2String(variables, 0);
            string pos = llList2String(variables, 1);
            string fwd = llList2String(variables, 2);
            string rot = llList2String(variables, 3);
            string sparam = llList2String(variables, 4);
            
            
            llRezObject(name, (vector)pos, (vector)fwd, (rotation)rot, (integer)sparam);
        }
    }
}
