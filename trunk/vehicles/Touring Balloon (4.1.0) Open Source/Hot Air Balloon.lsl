//Hot Air Touring Balloon
//by Hank Ramos

//=========
//Overview
//=========
//The Hot air balloon consists of a large number of scripts, working together.  The balloon will not function properly without all of the scripts.  The scripts are broken up by function, mainly for convenience but also because of the limitations of the LSL scripting memory.

//============================
//Scripts and their Function
//============================
//Hot Air Balloon: 
//The main script and "engine" of the entire balloon.  All major functions are done here

//Automated Tour: 
//Handles automatic tours given by a pre-set Tour notecard.  The script reads and follows the directions given in the script, and sends commands to the Hot Air Balloon script.

//Destination Script: 
//Handles the file i/o of the tour notecards.  It converts the notecard information to a list of destinations for the Automated Tour script to handle.

//Finder Script:
//Handles notification of the owner of the balloon in case the balloon is lost.

//ILS Navigation: 
//Handles reception of communications from ILS beacons. The owner manually activates the ILS beacon, which then communicates docking or nav info to this script.

//Landmark Script: 
//Handles drag-and-dropped landmarks. Reads the landmark information, then passes it along to the Hot Air Balloon Script  

//Region Script:
//Used to be a separate script along with another script that read world coordinates of various sims from a notecard.  Very slow, and required updating.
//Now, this script simply provides world coordinates from the llRequestSimulatorData function.  

//Settings Script:
//Reads from the settings notecard and informs various scripts of their default settings.

//Voice Control:
//Provides centralized listen event to distribute voice commands to all of the scripts in the balloon.

//Air Bag Script (found in the invisible air bags and the bain air bag at the top):
//This script receives buoyancy values from the Hot Air Balloon script, and help make the balloon float and sink

//Display Script (found in the overhead display prim, invisible prim but visible text):
//Handles the display and timed request of information from the Hot Air Balloon Script.  When not receiving text to display, it automatically triggers the Hot Air Balloon script to send distance, destination, and altitude info back to this script.

//MasterFlameScript
//Receives Flame 911 info, and controls all other flames and sound.

//FlameScript
//Works in conjunction with the MasterFlameScript to show coordinated flames.

//==================================
//Constants Used with Link Messages
//==================================
//100   : Request Region World Coordinates
//102   : >>>Deprecated<<<
//110   : Request Landmark Information for a particular Tour Stop #.  
//200   : Receive Region World Coordinates sent by the 100 command
//203   : >>>Deprecated<<<
//210   : Send Landmark Information to the Hot Air Balloon.
//211   : Send number of destinations in the loaded tour to the Automated Tour Script.
//237   : Broadcast current TravelForce, ArriveForce, DefaultZ settings from Settings Script.
//238   : Broadcast current Upforce, DownForce, Precision settings from Settings Script.
//240   : Send "API" command to all script.  Same as a voice command.
//411   : Text to display on the overhead display
//412   : Broadcast current Display Rate setting from Settings Script.
//482   : Broadcast current ChatChannel setting from Settings Script.
//487   : Send tour notecard name to the Destination Script.  Triggers automatic loading of that card as well.
//501   : Air Bag Buoyancy Information.
//555   : Send the current "Distance to Destination" to the Automated Tour script
//850   : Instructs Hot Air Balloon to send "Destination Name" info to the overhead display.
//851   : Instructs Hot Air Balloon to send "Distance to Destination" info to the overhead display.
//852   : Instructs Hot Air Balloon to send "Altitude" info to the overhead display.
//911   : Flame control
//999   : Broadcast reset to all scripts
//2658  : Manual Mode.  Informs the Automated Tour that we are currently in manual mode, and not following a tour notecard.
//95562 : Voice Command string broadcast by Voice Control Script. Each script processes their own particular commands.

vector  LPos;
vector  RPos;
vector  hovL;
vector  hovR;
string  dest;
string  region;
vector  destV;   //dock, undock, distance
integer hovering;
vector  forces;  //Upforce, DownForce, Precision
vector  defs;    //TravelForce, ArriveForce, DefaultZ
float   comp = 0;
float   mass;
vector  pos;
integer broadcastCounter;

string cap(string v)
{
    v = llToUpper(llGetSubString(v, 0, 0)) + llGetSubString(v, 1, llStringLength(v) - 1);
    return v;
}

disp(string message)
{
    llMessageLinked(LINK_ALL_CHILDREN, 411, message, NULL_KEY);
}

vector totarget(float gx, float gy, float lx, float ly)
{ 
    vector target;
    vector dir;
    vector corner = llGetRegionCorner();
    
    pos.x = pos.x + corner.x;
    pos.y = pos.y + corner.y; 
    
    target.x = gx + lx; 
    target.y = gy + ly;
    target.z = pos.z; 
    
    dir = target - pos;
    destV.z = llVecMag(dir);
     
    dir = llVecNorm(dir);   
    return dir;
}

turn(integer dock, float tau)
{
    vector vel;

    if(dock)
    {
        vel = <-0.00163, -0.00020, -1.00000>;
    }
    else
    {
        vel = llVecNorm(llGetVel());
    }
    vel.z = 0.0;
    vector fwd = llRot2Up(llGetRot());
    vector imp = fwd % vel;
    imp = (1/tau) * imp;
    vector omega = llGetOmega();
    imp = (mass * (imp - omega));
    llApplyRotationalImpulse(imp, FALSE);
}

push(vector direction, float speed) 
{
    vector ivel = llGetVel();
    vector fvel = direction * speed;
    vector imp = (mass * (fvel - ivel))/10; 
    llApplyImpulse(imp, FALSE);
}

alt(float tarz)
{
    float  zdiff = llFabs(pos.z - tarz);
    
    if (zdiff > 25)
    {
        comp = 0.01 * ((zdiff - 25)/75);
    }
    else
    {
        comp = 0;
    }
    if(pos.z < tarz)
    {
        llMessageLinked(LINK_ALL_CHILDREN, 501, (string)(forces.x + comp), "");            
        llMessageLinked(LINK_ALL_CHILDREN, 911, (string)TRUE, NULL_KEY);
    }
    else
    {
        llMessageLinked(LINK_ALL_CHILDREN, 501, (string)(forces.y - comp), "");            
        llMessageLinked(LINK_ALL_CHILDREN, 911, (string)FALSE, NULL_KEY);
    }
}

vect(integer hovering)
{
    //Update Global Info
    mass = llGetMass();
    pos = llGetPos();
    
    //The "engine" of the balloon...
    vector dir = totarget(RPos.x, RPos.y, LPos.x, LPos.y); 
    if(destV.z > 15)
    {
        push(dir, defs.x);
    }
    else
    {
        push(dir, defs.y);
    }
    turn(0, 3.0);
    alt(LPos.z);
    broadcastCounter++;
    if (broadcastCounter == 10)
    {
        if (!hovering){llMessageLinked(llGetLinkNumber(), 555, (string)destV.z, NULL_KEY);};
        broadcastCounter = 0;
    }
}

checkC(string m, key id)
{
    m = llToLower(m);
    if (m == "reset scripts")
    {
        disp("Resetting Scripts...");
        llResetScript();
    }   
    if (m == "startup")
    {
        state startup;
    }   
    if (m == "shutdown")
    {
        state shutdown;
    }   
    if (m == "hover")
    {
        state hover;
    }   
    if ((m == "resume") && (hovering)) 
    {
        LPos = hovL;
        RPos = hovR;
        state travel;
    }  
}

checkTC(string m, key id)
{
    float checkN;
    
    m = llToLower(m);
    if (llSubStringIndex(m, "landmark ") == 0) 
    {
        llMessageLinked(LINK_SET, 2658, "", NULL_KEY);//Manual Mode
        
        list L = llCSV2List(llGetSubString(m,9,llStringLength(m)));
        region = llList2String(L, 0);
        dest   = "Manual Landmark";
        if (llGetListLength(L) >= 1)
        {
            if (defs.z >= 1)
            {
                LPos = <128,128,defs.z>;
            }
            else
            {
                LPos = <128,128,LPos.z>;
            }
        }
        if (llGetListLength(L) == 4)
        {
            LPos.z = llList2Float(L, 3);
        }
        if ((llGetListLength(L) == 4) || (llGetListLength(L) == 3))
        {
            LPos.x = llList2Float(L, 1);
            LPos.y = llList2Float(L, 2);
        }
        llMessageLinked(LINK_SET, 100, region, NULL_KEY);
        return;
    }
    if (llSubStringIndex(m, "altitude ") == 0)
    {
        checkN = (float)llGetSubString(m,9,18);
        if (checkN > 0.001)
        {
            LPos.z = checkN;
            disp("Altitude Set to " + (string)((integer)LPos.z) + " meters");
        }
        return;
    }
    if (llSubStringIndex(m, "bump ") == 0)
    {
        checkN = (float)llGetSubString(m,5,18);
        LPos.z += checkN;
        disp("Altitude bumped by " + (string)((integer)checkN) + " meters to " + (string)((integer)LPos.z) + " meters");
        return;
    }
    if (m == "dock")
    {
        LPos.z = destV.x;
        disp("Docking at " + (string)((integer)LPos.z) +  " meters");
        return;
    }   
    if (m == "undock")
    {
        LPos.z = destV.y;
        disp("Heading for " + (string)((integer)LPos.z) +  " meters");
        return;
    }   
}

checkM(integer n, string m, key id)
{
    vector position = llGetPos();
    list   L;

    //Destination Name = 850
    if ((n == 850) && (dest != "None"))
    {
        disp("Destination: " + cap(dest) + ", " + cap(region) + "(" + (string)((integer)LPos.x) + "," + (string)((integer)LPos.y)  + ")");
        return;
    }

    //Distance To Destination = 851
    if ((n == 851) && (dest != "None"))
    {
        disp("Distance To Destination: " + (string)((integer)destV.z) + " meters");
        return;
    }
    
    //Altitude = 852
    if (n == 852)
    {
        disp("Altitude: " + (string)((integer)position.z) + " meters");
        return;
    }
    
    //Process Return of Landmark Info Retrieval
    if (n == 210)
    {
        L = llCSV2List(m);
        
        dest    = llList2String(L, 0);
        region  = llList2String(L, 1);
        LPos.x  = llList2Float (L, 2);
        LPos.y  = llList2Float (L, 3);
        destV.x = llList2Float (L, 4);
        destV.y = llList2Float (L, 5);
        LPos.z  = destV.y;
                
        if (region != "")
        {
            llMessageLinked(LINK_SET, 100, region, NULL_KEY);
        }
        return;
    }
    //Process API Commands
    if (n == 240)
    {
        checkC(m, id);
        checkTC(m, id);
        return;
    }
    //Process API Forces Commands
    if (n == 238)
    {
        forces = (vector)m;
        return;
    }
    //Process API Other Commands
    if (n == 237)
    {
        defs = (vector)m;
        return;
    }

    //Process Return of Region Vector Determination
    if (n == 200)
    {
        RPos = (vector)m;
        state travel;
    }
}

reset()
{
    llResetOtherScript("Voice Control");
    llResetOtherScript("Automated Tour");
    llResetOtherScript("Finder Script");
    llResetOtherScript("Region Script");
    llResetOtherScript("Destination Script");
    llResetOtherScript("Settings Script");
}

init()
{
    dest  = "None";
    llMessageLinked(LINK_SET, 102, "", "");
    llSetStatus(STATUS_PHYSICS, FALSE);
    llSetStatus(STATUS_PHANTOM, FALSE);
    llMessageLinked(LINK_ALL_CHILDREN, 911, (string)FALSE, NULL_KEY); //Turn off Flames
}
//STATES
default
{
    state_entry()
    {
        reset();
        init();
    }

    on_rez(integer s)
    {
        state shutdown;
    }

    link_message(integer sn, integer n, string m, key id)
    {
        //Process Listen Commands
        if (n == 95562)
        {
            checkC(m, id);
            return;
        }
        checkM(n, m, id);
    }
}
state startup
{
    state_entry()
    {
        vector cpos = llGetPos();
        
        disp("Starting up...");
        dest = "None";
        llSetBuoyancy(1.0);
        llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y, FALSE);
        llSetStatus(STATUS_ROTATE_Z | STATUS_PHYSICS | STATUS_BLOCK_GRAB, TRUE);
        llSetStatus(STATUS_PHYSICS, TRUE);
        llMessageLinked(LINK_ALL_CHILDREN, 501, (string)forces.y, "");
        state hover;
    }
}
state shutdown
{
    state_entry()
    {
        disp("Shutting Down...");
        llMessageLinked(LINK_ALL_CHILDREN, 911, (string)FALSE, NULL_KEY); 
        llSetStatus(STATUS_PHYSICS, FALSE);
        llSetTimerEvent(1);
    }

    link_message(integer sn, integer n, string m, key id)
    {
        //Process Listen Commands
        if (n == 95562)
        {
            checkC(m, id);
            return;
        }
        checkM(n, m, id);
    }
    
    timer()
    {
        if (llGetStatus(STATUS_PHYSICS))
        {
            llSetStatus(STATUS_PHYSICS, FALSE);
        }
        else
        {
            llSetTimerEvent(0);        
            disp("Successfully Shut Down");  
        };
    }
}
state hover
{
    state_entry()
    {            
        hovering = TRUE;
        hovL     = LPos;
        hovR     = RPos;
        LPos     = llGetPos();
        RPos     = llGetRegionCorner();
        disp("Hovering at " + (string)((integer)LPos.z) + " meters"); 
        llSetTimerEvent(forces.z);
    }

    on_rez(integer startparam)
    {
        state shutdown;
    }

    link_message(integer sn, integer n, string m, key id)
    {
        //Process Listen Commands
        if (n == 95562)
        {
            checkTC(m, id);
            checkC(m, id);
            return;
        }
        checkM(n, m, id);  
    }
    
    timer()
    {
        vect(TRUE);
    }
    
    state_exit()
    {
        hovering = FALSE;
    }
}
state travel
{
    state_entry()
    {
        disp("Heading for " + (string)((integer)LPos.z) + " meters");
        llSetTimerEvent(forces.z);
    }

    on_rez(integer startparam)
    {
        state shutdown;
    }

    link_message(integer sender_number, integer number, string message, key id)
    {
        //Process Listen Commands
        if (number == 95562)
        {
            checkTC(message, id);
            checkC(message, id);
            return;
        }
        checkM(number, message, id);
    }
    
    timer()
    {
        vect(FALSE);
    }
}
