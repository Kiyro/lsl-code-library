//ZeroFlight XLR8
//hacked together script by Burke Prefect, peices from other people's code.
//NOT RESPONSIBLE... FOR ANYTHING
float speed = 15; // this is starting speed.

set_hover() // this keeps you from falling at extreme altitudes. just 'fly' normally. works in either mode.
{
    vector pos = llGetPos();
    float ground = llGround(<0,0,0>);
    if(llGetAgentInfo(llGetOwner()) & AGENT_FLYING)
    {
        if((pos.z > 75) && (pos.z > (ground + 35)))
        { 
            llSetForce(<0,0,9.8> * llGetMass(), FALSE);
        }
        else
        {
            llSetForce(<0,0,0>, FALSE);
        }
    }
    else
        {
            llSetForce(<0,0,0>, FALSE);
        }
}

default // this is where the script starts off. it's not active, it's just waiting for a command.
{
    state_entry()
    {
    key id = llGetOwner();
    llListen(0,"",id,"");
    llSetTimerEvent(.5);
    llReleaseControls();
    }

    timer()
    {
        set_hover();
    }
    
    listen( integer channel, string name, key id, string message ) {
        
        if (message == "fly")
            state freakpack;  
    }
}
    

//// By making 'freakpack' it's own state, we can control it much easier. 
state freakpack
{
    state_entry()
    {
        llSetTimerEvent(.5);
        llListen(0,"",llGetOwner(),"");
        llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);  
    }
    
    // on_rez(integer total_number)
    //{llResetScript();}
    
    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            llReleaseControls();  
            state default;
        }
    }

     timer()
    {
     set_hover();   
    }
    
    run_time_permissions(integer perm)
    {
         if(perm & PERMISSION_TAKE_CONTROLS)
        {
            llTakeControls(CONTROL_FWD|CONTROL_BACK|CONTROL_LEFT|CONTROL_RIGHT|CONTROL_UP|CONTROL_DOWN,TRUE,TRUE);
        }
    }
    
    control(key av, integer level, integer edge)
    {
         if(level & CONTROL_UP)
        {
            llApplyImpulse(<0,0,speed*3>,FALSE);
        }
         if(level & CONTROL_DOWN)
        {
            llApplyImpulse(<0,0,-speed*3>,FALSE);
        }
          if(level & CONTROL_LEFT)
        {
         if(llGetAgentInfo(llGetOwner()) & AGENT_FLYING)
            {   llApplyImpulse(<0,speed,0>,TRUE);}
        }
          if(level & CONTROL_RIGHT)
        {
            if(llGetAgentInfo(llGetOwner()) & AGENT_FLYING)
            {llApplyImpulse(<0,-speed,0>,TRUE);}
        }
         if(level & CONTROL_FWD)
        {
            if(llGetAgentInfo(llGetOwner()) & AGENT_FLYING)
            {llApplyImpulse(<speed,0,0>,TRUE);}
        }
         if(level & CONTROL_BACK)
        {
            if(llGetAgentInfo(llGetOwner()) & AGENT_FLYING)
            {llApplyImpulse(<-speed,0,0>,TRUE);}
        }
    }
    
    timer()
    {
        if(llGetAgentInfo(llGetOwner()) & AGENT_FLYING)
            set_hover();
        
        else {
            llReleaseControls();  
            state default;
        }
    }
    
    changed(integer change)
    {
        llReleaseControls();  
        state default;
    }
    
    listen(integer channel, string name, key id, string m)
    {
        string ml = llToLower(m);
        list parsed = llParseString2List(ml,[" "],[]);
        if(llList2String(parsed,0) == "speed")
        {
            speed = (float)llList2String(parsed,1);
        }
         if (m=="fly")
        {
            llReleaseControls();
            state default;
        }
    }
}
