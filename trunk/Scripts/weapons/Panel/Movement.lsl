default
{
    on_rez(integer start_param)
    {
        llListen(start_param,"","","");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if(llGetSubString(message,0,0) == "<")
        {
            vector TargetPosition = (vector)message;
        
            while ( llVecDist(llGetPos(), TargetPosition) > 0.001 ) llSetPos(TargetPosition);
            llSetScriptState("Movement",FALSE);
        }
    }
}
