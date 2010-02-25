vector wheel ;

default
{
    state_entry()
    {
        llListen( 3288, "", NULL_KEY, "" ); 
    } 
   


listen( integer channel, string name, key id, string message )
{
    
       if ( message == "off" )
    { 
        
        llSleep(1);
        llSetTexture("navette spacial - museau avant jpeg",ALL_SIDES);
        
    
    }
 
 
 
   else if ( message == "on" )
   {
       
        
       
        llSetTexture("navette spacial - museau avant png",ALL_SIDES);
       
       
    }
 

}

}
