string updateserver = "d4af8e7d-e032-fcef-b5d1-a0bea6269b1e@lsl.secondlife.com";
string password = "stargate-sg1x";
string version;
init()
{
    version = llGetSubString(llGetObjectName(), 21, -1);
    llListen(1, "", "", "");
    llOwnerSay("Performing Automatic Update Check");
    llEmail(updateserver, password, (string)llGetOwner() + version);
}
default
{
    attach(key attached)
    {
        if(attached != NULL_KEY)
        {
            init();
        }
    }
    listen(integer chan, string name, key id, string mesg)
    {
        string msg = llToLower(mesg);
        if(id == llGetOwner() && msg == "update")
        {
            llEmail(updateserver, password, (string)llGetOwner() + version);
        }
    }
}
