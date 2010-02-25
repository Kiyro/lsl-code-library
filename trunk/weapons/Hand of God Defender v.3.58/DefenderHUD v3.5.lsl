string assname = "";
key assown = "";
key assob = "";
key this = "";
key owner = "";
integer asstype = 0;
integer power = 500000;
integer on = TRUE;
integer avon = TRUE;
integer obon = TRUE;
integer flyplus = TRUE;
integer orbdef = FALSE;
integer floating = FALSE;
integer shield = FALSE;
integer invis = FALSE;
vector asspos = <0,0,0>;
vector assownpos = <0,0,0>;
vector assvel = <0,0,0>;
rotation rot = <0,0,0,0>; 
list buttons = ["On/Off","Power","Filter","No-Orbit","SuperFly"];
string status = "Hand of God";




default
{   touch_start(integer num)
    {
        this = llGetKey();
        owner = llGetOwner();
        llListen(-88, "",owner, "");
        
        llDialog(owner,status,buttons,-88);
    }
    on_rez(integer p)
    {
     this = llGetKey();
     owner = llGetOwner();
     llListen(-88, "",owner, "");
          
    }
    changed(integer change)
    {
        if(change & CHANGED_LINK)
        {
            llResetScript(); 
        }
    }
    
    attach(key id)
    {
        this = llGetKey();
        owner = llGetOwner();
        
        llListen(-88, "",owner, "");
        llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);
    }
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TAKE_CONTROLS)
        {
            llTakeControls(CONTROL_UP | CONTROL_DOWN |CONTROL_FWD|CONTROL_LEFT|CONTROL_RIGHT|CONTROL_BACK|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT|CONTROL_ML_LBUTTON|CONTROL_LBUTTON,1,1);
        }
    }
    control(key id, integer held, integer change)
    {
      
      integer pressed = held & change; 
      integer down = held & ~change; 
      integer released = ~held & change; 
      integer inactive = ~held & ~change;
      
      
      
      if (flyplus == TRUE)
                {
                if(llGetAgentInfo(llGetOwner()) & AGENT_FLYING)
                {
                   if(down & CONTROL_UP)
                   {
                     llPushObject(llGetOwner(),<0,0,150.0>,<0,0,0>,FALSE);                 
                    } 
                    
                    if(pressed & CONTROL_UP)
                   {
                     llPushObject(llGetOwner(),<.0,.0,30.>,<.0,.0,.0>,FALSE);                 
                    }
                    
                    if(released & CONTROL_UP && inactive & CONTROL_DOWN)
                   {
                     //float push = 9.8 * llGetMass() + llGround(llGetPos());
                     //llPushObject(llGetOwner(),<.0,.0,20.>,<0.,0.,0.>,FALSE);
                     floating = TRUE;                 
                    }
                    else
                    {
                        floating = FALSE;
                    }
                    if(down & CONTROL_DOWN)
                   {
                       if(orbdef == TRUE)
                       {
                            llPushObject(llGetOwner(),<.0,.0,-5000.>,<.0,.0,.0>,FALSE);         
                        }
                        else
                        {
                     llPushObject(llGetOwner(),<.0,.0,-40.>,<.0,.0,.0>,FALSE);                               }
                    } 
                    
                    if(pressed & CONTROL_DOWN)
                   {
                     llPushObject(llGetOwner(),<.0,.0,-13.>,<.0,0.0,0.0>,FALSE);                 
                    }
                     if(down & CONTROL_FWD)
                   {
                     llPushObject(llGetOwner(),llRot2Fwd(llGetRot()) * 40.0,<0.0,0.0,0.0>,FALSE);                 
                    } 
                    
                    if(pressed & CONTROL_FWD)
                   {
                     llPushObject(llGetOwner(),llRot2Fwd(llGetRot()) * 15.0,<0.0,0.0,0.0>,FALSE);                 
                    }
                }
                    
                    
                    
                      
                    
                    
                }  
        
    }
    
    state_entry()
    {
        this = llGetKey();
        owner = llGetOwner();
        
        llSetTimerEvent(.2); 
        llSetText("Hand of God",<1,0,0>,1.0);       
        llListen(-88, "",owner, "");
       status = "ON: " + (string)on + "\n" + "Avatars: " + (string)avon+ "\n" +"Objects: " + (string)obon + "\n" +"No-Orbit: " + (string)orbdef + "\n" +"SuperFly: " + (string)flyplus   ;
       llDialog(owner,status,buttons,-88);
    }
    
    timer ()
    {
        
        
        
        
        if (~ llGetAgentInfo(llGetOwner()) & AGENT_FLYING)
        {
            vector loc = llGetPos(); 
            if(loc.z > llGround(loc) + 25.0)
            {   if (orbdef == TRUE)
                {
                llPushObject(llGetOwner(),<0,0,-2147483647>,<0,0,0>,FALSE);
                llSleep(0.0);
                llPushObject(llGetOwner(),<0,0,-2147483647>,<0,0,0>,FALSE);
                llSleep(0.0);
                llPushObject(llGetOwner(),<0,0,-2147483647>,<0,0,0>,FALSE);
                }
            }
            
               
        }
        else
        {
            if (floating == TRUE)
            {
                 float push = 9.8 * llGetMass() ;
                     llPushObject(llGetOwner(),<.0,.0,push>,<0.,0.,0.>,FALSE);
                
            }
        }
         
        
    }
    collision_start(integer total_number)
    {  
        
        
        
        if (on == TRUE)
        {
            
            
        asstype = llDetectedType(0);
        assob = llDetectedKey(0);
        assown = llGetOwnerKey(assob);
        
        
       
        if (asstype & AGENT)
        {   
            if (avon == TRUE)
            {
            llSetText("Avatar: " + llKey2Name(assob),<1,0,0>,1.0);       
            assown = assob;
            if(llGetParcelFlags(llGetPos()) != PARCEL_FLAG_RESTRICT_PUSHOBJECT )
        {
           
            llPushObject(assown,(asspos - llGetPos()) * (power/5000),<0,0,0>,FALSE);   
        }
            }
        }
        if (asstype & ACTIVE )
        {  //llSay(0,"");
            if(~ asstype & AGENT)
                {
                if (obon == TRUE)
                {
                //llSay(0 ,"8888");
             llSetText(llKey2Name(assob) + "\n" + "(A/S)Owned by: " + llKey2Name(assown),<1,0,0>,1.0);  
            
        if(assown != owner)    
         {   
        asspos = llDetectedPos(0);
            
            if(llGetParcelFlags(llGetPos()) != PARCEL_FLAG_RESTRICT_PUSHOBJECT )
        {
          
            llPushObject(assob,(asspos - llGetPos()) * (power * power) ,<0,0,0>,FALSE);    
        }

    asspos = llDetectedPos(0);
            while(llGetEnergy() < .75)
            {
                llSleep(.1);
            }
            if(llGetParcelFlags(llGetPos()) != PARCEL_FLAG_RESTRICT_PUSHOBJECT )
        {
           llPushObject(assown,(asspos - llGetPos()) * power ,<0,0,0>,FALSE);   
        }
            
            if (orbdef == TRUE)
                {
                llPushObject(llGetOwner(),<0,0,-2147483647>,<0,0,0>,FALSE);
                }
        }
    
                      
                  
                }
                }
            llSleep(0.0);
        
        }
       
    
    }           
    }
    listen(integer chan, string name, key id, string msg)
    {
        if(msg == "On/Off")
        {
            if (on == FALSE)
            {   llSay(0,llKey2Name(llGetOwner()) + "'s H.O.G is running");
                on = TRUE;
               status = "ON: " + (string)on + "\n" + "Avatars: " + (string)avon+ "\n" +"Objects: " + (string)obon + "\n" +"No-Orbit: " + (string)orbdef + "\n" +"SuperFly: " + (string)flyplus  ;
               llDialog(owner,status,buttons,-88);
 
            }
            else
            {
                on = FALSE;
                llSay(0,"Shutting Down...");
                 llDialog(owner,"Hand of God Defense HUD",["On/Off"],-88);
            }
        }
        if(msg == "Power")
        {
            if (on == TRUE)
            {
               llDialog(owner,"Hand of God Defense HUD
               Power Settings",["Casual","Strong","Fierce","Mean"],-88); 
            }
            
        }
        if(msg == "Filter")
        {
            if (on == TRUE)
            {
             llDialog(owner,"Hand of God Defense HUD
               Filter Settings",["Avatars","Objects"],-88);    
            }
            
        }
        if(msg == "Casual")
        {
            if (on == TRUE)
            {
                power = 50000;
                status = "ON: " + (string)on + "\n" + "Avatars: " + (string)avon+ "\n" +"Objects: " + (string)obon + "\n" +"No-Orbit: " + (string)orbdef + "\n" +"SuperFly: " + (string)flyplus  ;
                llDialog(owner,status,buttons,-88); 
            }
            
        }
        if(msg == "Strong")
        {
            if (on == TRUE)
            {
                power = 500000; 
                status = "ON: " + (string)on + "\n" + "Avatars: " + (string)avon+ "\n" +"Objects: " + (string)obon + "\n" +"No-Orbit: " + (string)orbdef + "\n" +"SuperFly: " + (string)flyplus ;
                llDialog(owner,status,buttons,-88);     
            }
            
        } 
        if(msg == "Fierce")
        {
            if (on == TRUE)
            {
                power = 50000000;
               status = "ON: " + (string)on + "\n" + "Avatars: " + (string)avon+ "\n" +"Objects: " + (string)obon + "\n" +"No-Orbit: " + (string)orbdef + "\n" +"SuperFly: " + (string)flyplus ;
               llDialog(owner,status,buttons,-88);        
            }
            
        }    
        if(msg == "Mean")
        {
            if (on == TRUE)
            {   power = 2147483647;
               status = "ON: " + (string)on + "\n" + "Avatars: " + (string)avon+ "\n" +"Objects: " + (string)obon + "\n" +"No-Orbit: " + (string)orbdef + "\n" +"SuperFly: " + (string)flyplus ;
               llDialog(owner,status,buttons,-88);
            }
            
        }  
        if(msg == "Objects")
        {
            if (on == TRUE)
            {
                if(obon ==TRUE)
                {
                   obon = FALSE;            
                }
                else
                { obon = TRUE;
                }
               status = "ON: " + (string)on + "\n" + "Avatars: " + (string)avon+ "\n" +"Objects: " + (string)obon + "\n" +"No-Orbit: " + (string)orbdef + "\n" +"SuperFly: " + (string)flyplus ;
               llDialog(owner,status,buttons,-88);
            }
            
        }   
        if(msg == "Avatars")
        {
            if (on == TRUE)
            {   if(avon ==TRUE)
                {
                   avon = FALSE;            
                }
                else
                { avon = TRUE;
                }
               status = "ON: " + (string)on + "\n" + "Avatars: " + (string)avon+ "\n" +"Objects: " + (string)obon + "\n" +"No-Orbit: " + (string)orbdef + "\n" +"SuperFly: " + (string)flyplus  ;
               llDialog(owner,status,buttons,-88);
            }
            
        } 
        if(msg == "No-Orbit")
        {
            if (orbdef == TRUE)
            {   orbdef = FALSE;
               status = "ON: " + (string)on + "\n" + "Avatars: " + (string)avon+ "\n" +"Objects: " + (string)obon + "\n" +"No-Orbit: " + (string)orbdef + "\n" +"SuperFly: " + (string)flyplus ;
               llDialog(owner,status,buttons,-88);
            }
            else
            {
               orbdef = TRUE;
               status = "ON: " + (string)on + "\n" + "Avatars: " + (string)avon+ "\n" +"Objects: " + (string)obon + "\n" +"No-Orbit: " + (string)orbdef + "\n" +"SuperFly: " + (string)flyplus  ;
               llDialog(owner,status,buttons,-88);
            }
            
        } 
        if(msg == "SuperFly")
        {
            if (flyplus == TRUE)
            {   flyplus = FALSE;
               status = "ON: " + (string)on + "\n" + "Avatars: " + (string)avon+ "\n" +"Objects: " + (string)obon + "\n" +"No-Orbit: " + (string)orbdef + "\n" +"SuperFly: " + (string)flyplus   ;
               llDialog(owner,status,buttons,-88);
            }
            else
            {
               flyplus = TRUE;               
               status = "ON: " + (string)on + "\n" + "Avatars: " + (string)avon+ "\n" +"Objects: " + (string)obon + "\n" +"No-Orbit: " + (string)orbdef + "\n" +"SuperFly: " + (string)flyplus   ;
               llDialog(owner,status,buttons,-88);
            }
            
        } 
        
                       
    }
}
