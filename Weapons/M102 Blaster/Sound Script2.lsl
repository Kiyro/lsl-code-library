string sound1="fire";
string sound2="fireS";
default
{
    state_entry()
    {
        llPreloadSound(sound1);
        llPreloadSound(sound2);
    }
    link_message(integer n, integer g, string m, key null)
    {
        if(m=="shot")
        {
            llTriggerSound(sound1,1.0);
        }
        if(m=="shots")
        {
            llTriggerSound(sound2,1.0);
        }
    }
}
            
            
            
        
      
