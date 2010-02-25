default
{
    state_entry()
    {
        llSay(0, "Hello, Avatar!");
    }

    touch_start(integer total_number)
    {
        float   FloatValue;
        integer IntValue;
        string  StringValue;
        
        FloatValue  = llFrand(100);
        IntValue    = llRound(FloatValue);
        StringValue = (string)IntValue;
        
        llSay(0, StringValue);
    }
}
