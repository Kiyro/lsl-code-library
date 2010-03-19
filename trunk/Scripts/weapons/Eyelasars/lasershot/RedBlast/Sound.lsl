default
{
    link_message(integer s, integer n, string str, key id)
    {
        if (str == "boom")
        llTriggerSound("3ddc41a5-21e6-0e0b-4f62-50c0e433d1aa",0.3);
    }
}