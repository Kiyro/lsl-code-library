//Title: Lost Die Script
//Date: 10-30-2003 06:53 AM
//Scripter: ZHugh Becquerel

float LastTimeOwnerDetected;
key owner;

TellOwner( string Message )
{
   // llWhisper( 0, "Trace: " + Message );    
   
    llInstantMessage(owner, (string)llGetPos() + " " + Message );
}

Init()
{
        owner = llGetOwner();
       LastTimeOwnerDetected = llGetTimeOfDay();
       llSetTimerEvent(10.0);
       llSensorRepeat( "", "", AGENT, 50, PI, 10.0 );
}
    
SelfDestructNow()
{
            llSay(0, "Too far from owner.  Self-destructing...");
            llInstantMessage(owner,"Too far from owner.  Self-destructing...");
            llDie();
}

default
{
    state_entry()
    {
        Init();
    }
    on_rez(integer start_param)
    {
        Init();
    }
    timer()
    {
        if( llGetTimeOfDay() - LastTimeOwnerDetected > 60 )
        {
            //TellOwner( (string)llGetTimeOfDay() + " " + (string)LastTimeOwnerDetected );
            SelfDestructNow();
        }
        else if( llGetTimeOfDay() - LastTimeOwnerDetected > 30 )
        {
            
            TellOwner( "Self destructing in 30 seconds..." );
        }
    }
    sensor(integer num_detected)
    {
           integer i;
           integer near_owner;
           near_owner = FALSE;
           for( i=0;i<num_detected;i++)
           {
               //TellOwner("Sensed:" + llDetectedName(i));
              if( llDetectedKey(i) == owner)
              {
                  //TellOwner( "You're close");
                  near_owner = TRUE;
              }
           }
           if( near_owner == TRUE )
           {
                LastTimeOwnerDetected = llGetTimeOfDay();
           }
    }
}
