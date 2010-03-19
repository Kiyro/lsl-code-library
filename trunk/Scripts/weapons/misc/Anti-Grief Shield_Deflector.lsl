//Exile's Simple Anti-Grief Auto shield! Please don't resell or use in any products you plan 
//to sell. This is open-sourced, so give full rights to anyone who gets this script. 
// Please don't remove this disclaimer, as it isn't nice to take the the gratitude that's 
//supposed to be for me. Have fun and keep safe! 

default 
{ 
    state_entry() 
    { 
        llListen(2,"",llGetOwner(),""); 
    } 
     
    listen(integer channel,string name,key id,string message) 
    { 
        if(message=="auto shield on") 
        { 
            llOwnerSay("Auto Shields Activated."); 
            llSensorRepeat("","",ACTIVE,5,TWO_PI,0.1); 
        } 
         
        if(message=="auto shield off") 
        { 
            llOwnerSay("Auto Shields deactivated."); 
            llSensorRemove(); 
        } 
    } 
     
    
         
            sensor(integer num_detected) 
    { 
             if(llVecMag(llDetectedVel(0)) > 7.0) 
            { 
                rotation rot = llGetRot(); 
                rotation drot = llDetectedRot(0); 
                rotation between = llGetRot() * llRotBetween(<0.5,0,0> * llGetRot(), llDetectedPos(0) - llGetPos()); 
            llRezObject("Auto Shield",llGetPos() + <0.5,0,0> * between,ZERO_VECTOR,between,0); 
            
            } 
        } 
    } 


