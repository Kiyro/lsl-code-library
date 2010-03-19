//•/•/•/•/•/•/•/Ð/A/M/E/N/•/H/A/X/•/•/•/•/•/•/•/•/•//

vector size;
vector v;
key own;
integer locked; 
integer MenuChannel;
menu(key user,string title,list buttons)
{
    llListen(MenuChannel,"","",own);
    llDialog(user,title,buttons,MenuChannel);
    llSetTimerEvent(20.0);   
}
Listen()
{
    menu(llGetOwner(),"Select your desired level of Gravity ~\n- SkyDive will send you about 1000m up.",["*Moon*","**Normal**","*Heavy*","-Crush-","-Feather-","-Space-","<<LOCK>>","^-SkyDive-^","<<UNLOCK>>"]);
    llSetTimerEvent(20.0);
}
default
{
    state_entry()
    {
        if ( llGetAttached() )
        {
            llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
            locked = FALSE; 
            own = llGetOwner();
            key uuid = llGetOwner();
            string name = llKey2Name(uuid); 
            MenuChannel = (integer)(llFrand(92229.0) * -1);
        }
    }
//
    on_rez(integer total_number)
    {
        if (own != llGetOwner()) 
        {
            llResetScript();
            own = llGetOwner();
        }
    }
//
    timer()
    {
        llSetTimerEvent(0.0);
        llListenRemove(MenuChannel);
        llResetScript(); 
    }
    run_time_permissions(integer perm)
    {
        if(perm & (PERMISSION_TAKE_CONTROLS))
        {
            llTakeControls(CONTROL_FWD|
               CONTROL_BACK|
               CONTROL_RIGHT|
               CONTROL_LEFT|
               CONTROL_ROT_RIGHT|
               CONTROL_ROT_LEFT|
               CONTROL_UP|
               CONTROL_DOWN,
               TRUE, TRUE);
        }
    }
//
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "GRAVITY") 
        {
        Listen();
        }
    }
//
    listen(integer channel,string name,key id,string message)
    {
        if (channel == MenuChannel) //in case you have others listeners
        {
             if(message == "*Moon*")
            {
llTriggerSound("be0cd87b-ae95-2fb5-6250-dcdd4d2ce732",9.99);
llSetForce(<0,0,12.5>, TRUE);
llOwnerSay("Gravity; Moon");
llListenRemove(MenuChannel);
            }
            else if(message == "**Normal**")
            {
llTriggerSound("be0cd87b-ae95-2fb5-6250-dcdd4d2ce732",9.99);
llSetForce(<0,0,0>, TRUE);
llOwnerSay("Gravity; Normal");
llListenRemove(MenuChannel);
            }
            else if(message == "*Heavy*") 
            {
llTriggerSound("be0cd87b-ae95-2fb5-6250-dcdd4d2ce732",9.99);
llSetForce(<0,0,-50>, TRUE);
llOwnerSay("Gravity; Heavy");
llListenRemove(MenuChannel);
            }
            else if(message == "G-5")
            {
llTriggerSound("be0cd87b-ae95-2fb5-6250-dcdd4d2ce732",9.99);
llSetForce(<0,0,5>, TRUE);
llOwnerSay("Gravity; -5");
llListenRemove(MenuChannel);
            }
            else if(message == "G-15")
            {
llTriggerSound("be0cd87b-ae95-2fb5-6250-dcdd4d2ce732",9.99);
llSetForce(<0,0,15>, TRUE);
llOwnerSay("Gravity; -15");
llListenRemove(MenuChannel);
            }
            else if(message == "-Feather-")
            {
llTriggerSound("be0cd87b-ae95-2fb5-6250-dcdd4d2ce732",9.99);
llSetForce(<0,0,17.5>, TRUE);
llOwnerSay("Gravity; Feather");
llListenRemove(MenuChannel);
            } 
            else if(message == "-Crush-")
            {
llTriggerSound("be0cd87b-ae95-2fb5-6250-dcdd4d2ce732",9.99);
llSetForce(<0,0,-210000000>, TRUE);
llOwnerSay("Gravity; Crush");
llListenRemove(MenuChannel);
            }
            else if(message == "-Space-")
            {
llTriggerSound("be0cd87b-ae95-2fb5-6250-dcdd4d2ce732",9.99);
llSetForce(<0,0,19>, TRUE);
llOwnerSay("Gravity; Space");
llListenRemove(MenuChannel);
            }                                                               
            else if(message == "^-SkyDive-^")
            {
llTriggerSound("be0cd87b-ae95-2fb5-6250-dcdd4d2ce732",9.99);
llSetForce(<0,0,520000>, TRUE);
llOwnerSay("Gravity; SkyDive");
llSleep(4);
llTriggerSound("be0cd87b-ae95-2fb5-6250-dcdd4d2ce732",9.99);
llSetForce(<0,0,0>, TRUE);
llOwnerSay("Gravity; Restored \n       (Parachute on?..)");
llListenRemove(MenuChannel);
            }
            else if(message == "<<LOCK>>")
            {
size = llGetAgentSize(llGetOwner());
v = <0,0,0.2>;
llMoveToTarget(llGetPos()-size/2+v, 0.2);
llSetForce(<0,0,0>, FALSE);
llPlaySound("cc385f87-8248-df57-ad04-40813444d540", 0.05);
llOwnerSay("Lockdown Activated;");
llListenRemove(MenuChannel);
            }                                                                               
            else if(message == "<<UNLOCK>>")
            {
llMoveToTarget(llGetPos(), 0);
llPlaySound("cc385f87-8248-df57-ad04-40813444d540", 0.05);
llOwnerSay("Lockdown De-Activated;");
llListenRemove(MenuChannel);
            }          
        }
    }
//
}


