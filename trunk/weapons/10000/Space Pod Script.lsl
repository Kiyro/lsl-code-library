//
//  Rocket
//
//  Click to fire
// 

float gTotalTime = 0.0;
float gTimeStep = 0.1;
key Owner;
integer liste;
default
{
    state_entry()
    {
        liste = llListen(51515151,"","","");
    }
    listen(integer chnl,string name, key id, string txt)
    {
        llSensorRepeat(txt,"",AGENT,96,PI*2,.1);
        llListenRemove(liste);
    }
    sensor(integer t)
    {
        llSetPos(llDetectedPos(0));
    }
    touch_start(integer t)
    {
        if(llDetectedKey(0) == llGetOwner()){
            state launch;
        }
    }
}
    
        
state launch
{
    
    
    state_entry()
    {
            llSetStatus(STATUS_PHYSICS, TRUE);
            llSetText("", <1,1,1>, 1.0);
            llSetForce(<0,0,700>, TRUE);
            llSetTimerEvent(gTimeStep);
            //llTriggerSound("launch", 1.0);
            llMakeExplosion(1, 0.5, 1, 0.5, 0.5, "fire", ZERO_VECTOR);
    }
    
    timer()
    {
        gTotalTime += gTimeStep;
        if (gTotalTime < 1.3)
            llMakeExplosion(5, 1.0, 1, 2.0, PI, "fire", ZERO_VECTOR);
        //else
        {
            //llTriggerSound("explosion", 7.0);
            //llMakeExplosion(7, 1.0, 10, 7.0, PI, "blue", ZERO_VECTOR);
            //llTriggerSound("explosion",7.0);
            //llMakeExplosion(7, 1.0, 15, 7.0, PI, "green", ZERO_VECTOR);
            //llTriggerSound("explosion",7.0);
            //llMakeExplosion(10, 1.0, 15, 13, PI, "tax", ZERO_VECTOR);
            //llTriggerSound("explosion",7.0);
            //llMakeExplosion(10,1.0,10,13,PI,"NAVY JACK.bmp",ZERO_VECTOR);

            
            //llDie();
        }        
    }
}
