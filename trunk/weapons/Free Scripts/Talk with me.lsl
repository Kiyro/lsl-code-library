init()
{
    llListen(0, "", NULL_KEY, "");
    llSay(0, "Hello, im feeling good today. I'm listening to what you say.");
    llSay(0, "Commands: hear, beg, howl, play, run");
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
        list parsed = llParseString2List( message, [ " " ], [] );
        string command = llList2String( parsed, 0 );
        string state_string = llList2String( parsed, 1);
        
        if( command == "hear"){
            llSay(0, "Yes, I will always listen.");
        }else if( command == "beg"){
            llSay(0, "Im a prim. Prims dont beg. Avatars beg but not me.");
        }else if( command == "howl"){
            llSay(0, "Owwwwwwww!");
        }else if( command == "play"){
            llSay(0, "Play dead? Uhm... How can a ball turn on its back?");
        }else if( command == "run"){
            llSay(0, "Did you ever see a running prim? A running gag, yes, but a prim? No.");
        }
    }
}
