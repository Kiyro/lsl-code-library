init()
{
    llListen(0, "", NULL_KEY, "");
    llSay(0, "Hello, im feeling good today. I'm listening to what you say.");
}

default
{
    state_entry()
    {
        init();
        
    }
    on_rez(integer param)
    {
        init();
    }
    listen(integer channel, string name, key id, string message)
    {
        string token;
        integer i;
        //list parsed = llParseString2List( message, [ " ", ".", "!", "?", ",", ";", "\"", "-", "(", ")", "[", "]", "{", "}","«","»" ], [] );
        list parsed = llParseString2List( message, [ " ", ".", "!", "?", ",", ";", "\"", "-", "(", ")", "[", "]", "{", "}"],
        [] );
        //llOwnerSay("Got "+(string)llGetListLength(parsed)+" words");
        for(i=-1+llGetListLength(parsed); i>=0; --i){
            token = llList2String( parsed, i );
            if( token == "hear"){
                llSay(0, "Yes, I will always listen.");
            }else if( token == "beg"){
                llSay(0, "Im a prim. Prims dont beg. Avatars beg but not me.");
            }else if( token == "run"){
                llSay(0, "Did you ever see a running prim? A running gag, yes, but a prim? No.");
            }
        }
    }
}
