default
{

    state_entry()
    {
        llSetText("", <1,0,0>, 1.0);
    }
        
    link_message(integer sender_num, integer num, string str, key id)
    {
        list input = llParseString2List(str, [" "], []);
        string command = (string)llList2List(input, 0, 0);
        list text = llList2List(input, 1, -1);
        string text2 = llList2String(text, -1);
        if (command == "settext") {
            if (text2 == "clear") {
                llResetScript();
            } else {
                                list input2 = llList2List(input, 1, -1);
                llSetText(llDumpList2String(input2, " "), <1,0,0>, 1.0);
            }
        }
    }            


}
