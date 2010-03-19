
default
{
    state_entry()
    {
        llSay(0, "Door 1.0");
        state open;
    }
}

state open
{
    
    touch_start(integer total_number)
    {
            llTriggerSound("Door", 0.5);
       
            rotation rot = llGetRot();
            rotation delta = llEuler2Rot(<0,0,(PI/4)+-0.1>);
            rot = delta * rot;
            llSetRot(rot);
            llSleep(0.25);
            rot = delta * rot;
            llSetRot(rot);
            state closed;
    }
}

state closed
{
    state_entry()
    {
        llSleep(20.0);
        llTriggerSound("Door", 0.5);
              
        rotation rot = llGetRot();
        rotation delta = llEuler2Rot(<0,0,(-PI/4)+0.1>);
        rot = delta * rot;
        llSetRot(rot);
        
        llSleep(0.25); 
        rot = delta * rot;
        llSetRot(rot);
        state open;
    }
}
