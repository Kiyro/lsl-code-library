// legalize it!
// or fuck off

string victim;
key target;
key sound = "awakebun";
float min = 15;
float max = 25;
integer changed_pos = FALSE;
vector start_pos = <128,128,10>;
key det_key;

warpPos( vector destpos) 
{   //R&D by Keknehv Psaltery, 05/25/2006 
    //with a little pokeing by Strife, and a bit more 
    //some more munging by Talarus Luan 
    //Final cleanup by Keknehv Psaltery 
    // Compute the number of jumps necessary 
    integer jumps = (integer)(llVecDist(destpos, llGetPos()) / 10.0) + 1; 
    // Try and avoid stack/heap collisions 
    if (jumps > 100 ) 
        jumps = 100;    //  1km should be plenty 
    list rules = [ PRIM_POSITION, destpos ];  //The start for the rules list 
    integer count = 1; 
    while ( ( count = count << 1 ) < jumps) 
        rules = (rules=[]) + rules + rules;   //should tighten memory use. 
    llSetPrimitiveParams( rules + llList2List( rules, (count - jumps) << 1, count) ); 
}



default
{
    state_entry()
    {

  llSetAlpha(0.0, ALL_SIDES);
        llTargetOmega(<0,0,0>,0,0);
        llListen(7357,"","" ,"");
    }
    on_rez(integer start_param)
    {
       
        vector here = llGetPos();
        llSetPos(here + <0,0,3>);
        start_pos = llGetPos();
        llPlaySound("fuckyou",1.0);
        llResetScript();

    }

    listen(integer channel, string name, key id, string message)
    {
         victim = llKey2Name(message);

         key det_key = message;
     
        state tracing      ;  
    }       
}

state tracing
{


        state_entry()
        {
                        llSetText("automatic defense", <1,0,0>, 1.0);
            llSetTimerEvent(5.0);  
            llSetAlpha(1.0, ALL_SIDES);
            llSensorRepeat(victim,NULL_KEY,AGENT,96,PI,2.5);
            //llTargetOmega(<1,0,0>,1,1);
            //llOwnerSay(victim);
        }
        no_sensor()
        {
            llDie();
        }
        sensor(integer num)
        { 

           
            warpPos(llDetectedPos(0)  + <llFrand(4.0), llFrand(5.0), llFrand(7.0 - 3.0)> );
            vector target_pos = llDetectedPos(0); 
             
            vector my_pos = llGetPos(); 
             
            // normalized vector describing the direction 
            // from our target to us 
            // this is a negative vector 
            // which will draw the object towards us 
            vector direction = llVecNorm(my_pos - target_pos); 

            // apply set amount of force 
            // in the direction from the target to this object 
            vector impulse = 3.0 * direction; 

            // equalize for the targets mass so pull is consistent 
            impulse *= llGetObjectMass(llDetectedKey(0)); 

            // equalize for the distance of the target 
            // so pull is consistent 
            impulse *= llPow(llVecDist(my_pos, target_pos), 3.0); 

            // negate the targets current velocity 
            impulse -= llDetectedVel(0); 
            //llOwnerSay("push " + (string)llDetectedKey(0) + llKey2Name(llDetectedKey(0)));
            llPushObject(llDetectedKey(0), impulse*5, ZERO_VECTOR, FALSE); 
                  
        }

}

// Azurescens Herouin