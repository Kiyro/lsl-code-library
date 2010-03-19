default
{
    state_entry()
    {
    }
    
    touch_start(integer a)
    {
            string sName = llKey2Name(llDetectedKey(0));
            llSay(0, sName + " is at the Door");
    }
}