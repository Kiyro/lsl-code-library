list chans=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,10];
integer i;
default
{
    on_rez(integer foo)
    {
        llResetScript();
    }
    state_entry()
    {
        for(i=0;i<llGetListLength(chans);i++)
            llListen(llList2Integer(chans,i),"",NULL_KEY,"");
    }

    listen(integer channel, string name, key id, string message)
    {
        llOwnerSay("["+(string)channel+"] ["+name+"|"+llKey2Name(llGetOwnerKey(id))+"] "+message);
    }
}
