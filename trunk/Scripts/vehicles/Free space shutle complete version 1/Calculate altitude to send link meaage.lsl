
integer calculateGroundDistance()
{
    vector pos = llGetPos();
    float ground = llGround(pos);
    float distance = llRound(pos.z-ground);
    return (integer)distance;
}





default
{  state_entry()
    {
        llSetTimerEvent(6);
    }
    
    timer()
    {
        integer dist = calculateGroundDistance();
       
        
          
        if( (dist>1800 && dist<2002)  )
         {   
       llMessageLinked(LINK_SET,24,"stop",NULL_KEY);  //booster
       llMessageLinked(LINK_SET,23,"stop",NULL_KEY);
    
    }   
    
    
      
      else if( (dist>2900 && dist<3100)   )         ///red tank
         {   
      
        llMessageLinked(LINK_SET,26,"stop",NULL_KEY);
       
       }
   

      
      else if ( (dist<30 ||  dist<90)  )
         {   
      
       //on equa the visibility for the receiver and 0 is the invisibility
     
      
          llMessageLinked(LINK_SET,27,"stop",NULL_KEY);
         
          llMessageLinked(LINK_SET,23,"stop",NULL_KEY);
         
           }
        
           
      
    
    
    
    }}