default
{
    touch_start(integer total_number)
    {
        llDialog(llDetectedKey(0),"Click the link in your chat history to join the group.",["Okay"],-1111);
        llInstantMessage(llDetectedKey(0),"Click this link to join the group:\n" + "secondlife:///app/group/"+ llGetObjectDesc() + "/about");
    }
}
