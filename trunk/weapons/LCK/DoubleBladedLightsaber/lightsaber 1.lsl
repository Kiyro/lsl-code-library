string name ;
vector pushpower ;
float range ;

default
{
    state_entry() 
    {
       
         key owner = llGetOwner();
      
        llListen(0,"",owner,"");
        
        
        llSetStatus(STATUS_BLOCK_GRAB, TRUE);
       
    }


    attach(key on)
    {
           
        llSetStatus(STATUS_PHYSICS, TRUE);
      
    
          
          llResetScript();
      
            
       
    }
    run_time_permissions(integer perm)
    {
        llTakeControls(CONTROL_UP | CONTROL_DOWN |  CONTROL_LBUTTON | CONTROL_FWD | CONTROL_BACK,TRUE,TRUE);
  llStartAnimation("sith saber stance");
    }
     listen( integer channel, string name, key id, string message )
    {
        if( message == "fe off" )
        {  
      
         
              llStopAnimation("sith saber stance");
            llReleaseControls();
           
             
                llStopSound();
             
             
            
           
           
            
        }
        if( message == "fe on" )
        {
           
            
           

      llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
       
            
          
        }
    }

        
    control(key owner, integer level, integer edge)
    {
        
            
          
         
              if (edge & level & CONTROL_BACK )  
            {
               
                
                 llStartAnimation("backflip");
                    
            llApplyImpulse(<-3,0,5*llGetMass()>,TRUE);
            
             
               llSensor(name,NULL_KEY,AGENT | ACTIVE | PASSIVE,96,PI*2);
            llSay(56,"10forcecost");
            
             
             
              
              
            
             
            }
            if (edge & level & CONTROL_FWD)  
            {
               
                 llStartAnimation("backflip");
           
              
               pushpower = <-90000,0,40000> ;
               llSensor(name,NULL_KEY,AGENT | ACTIVE | PASSIVE,96,PI/2);
               llStopAnimation("walk");
            
              llApplyImpulse(<-3,0,5*llGetMass()>,TRUE);
               
         
               llSensor(name,NULL_KEY,AGENT | ACTIVE | PASSIVE,10,PI/2);
            
            llSensor(name,NULL_KEY,AGENT | ACTIVE | PASSIVE,10,PI);
              
                
            }
             if (edge & level & CONTROL_LBUTTON)  
            {
               
                 llStartAnimation("saber slash 1");
           
              
               pushpower = <-90000,0,40000> ;
               llSensor(name,NULL_KEY,AGENT | ACTIVE | PASSIVE,96,PI/2);
               llStopAnimation("walk");
            
              
               
         
               llSensor(name,NULL_KEY,AGENT | ACTIVE | PASSIVE,10,PI/2);
            
            llSensor(name,NULL_KEY,AGENT | ACTIVE | PASSIVE,10,PI);
              
                
            }
          
          
               
               
               
     
         
             
             
              
               
               }
            


    sensor(integer tnum)
    {
        if (  pushpower = <-90000,0,40000>)
        {
             llPushObject(llDetectedKey(0),pushpower,ZERO_VECTOR,TRUE);
  
    }
    else if (pushpower == <-99999,0,3000> )
    {
           llPushObject(llDetectedKey(0),pushpower,ZERO_VECTOR,TRUE);
        }
    
            }
}
