// Haifeng's Elevator by Haifeng Chu 12/03/2006
// based off of Nyoko'sElevator by Nyoko Salome, which was further based off of the SN_Elevator by Seagal Neville
// SN_Elevator was made by Seagel Neville as public domain, Dec 2005
// therefore, this script is also public domain, simply my own further modified version.

// \\\\\\\\\\\\\\\
// \\\\\\\\\\\\\\\

// THE QUICK NITTYGRITTY
// EDIT YOUR OWN FLOOR VALUES HERE!!:) heights are in -absolute- height values, not relative (as in sn's original script). the menulist is a matching set for the dialogbox popup. BE SURE both lists match in length exactly!!

vector rotateavatar = <-90, -90, 90>; 

list LSTheights = [4000       // you will need to comment out
               // the comma if you comment out either
           // the first or second entry in both lists...
          // You have to put down the height of each floor in ABSOLUTE VALUE here.
//    ,301      // (just look in your menubar - it's the third number :)
//    ,701      // BEWARE!! these are my own 'laboratory settings'!! ;)
    ];          

list LSTmenu = [
    "Launch"   ///  The floor indicaor work whit  channel_floor_indicator that trasfer on a SL channel the                     word you write here to set the floor. You need to writ the floor name on the receiver                         script that show the floor.
   
    
//    ,"Cloudeck"
//    ,"Madlab"
//    ,"Rooftop"
    ];    // Dialog box's list. Go along with heightList.
    
integer INTdefaultIndex = 2; // 1 (first entry) to however many are in your floorlists.
//remember to skip any commented entries!!
//(if entries 1 and 2 are commented out, then INTdefaultIndex = 2 would equal the FOURTH entry!)
//after ten minutes, this floor will be reselected. set 0 to disable (the last selected floor
//will remain until someone changes it). you can adjust the timing with FLTseconds below.
 
// \\\\\\\\\\\\\\\
// \\\\\\\\\\\\\\\

// EXTENDED DEVNOTES:
// changes from SN's elevator:

// 1) rider may sit and ride to the currently selected floor right away, as opposed to previously having to select a floor first. to allow this, sn's version of a 'standing elevator' doesn't work correctly (avi will stand halfway thru the elevator floor instead); i had to cancel that routine and revert to a sitting position. (well-known LSL limitation - once the rider has sat down, their position can't be changed. sn's script forced the rider to select a floor first, which allowed the script to preset the rider's position before they sit.)

// 2) heightList interpretation changed to -absolute- height values (as opposed to values relative to the elevator starting position). i feel more comfortable with absolutes, in this case.
// p.s. (gee, what does that say about me??;)
// p.p.s. (lol - 'slow at substraction.';)

// 3) floating text displays the last selected floor + altitude in meters. a handy cue to newcomers that helps identify the elevator's purpose. updates when rider changes the floor selection; hides itself appropriately when a rider sits down; reappears when elevator has returned to starting point.

// 4) some additional extras: look further in the code for informational llWhispers at the start and end of the ride. make your own personalized messages!:) currently commented out for my own land... testing to see whether the floating text feedback will be enough to cue the visitor without all the extra 'noise'.:)

// 5) smooth acceleration from starting point to 'cruising speed', then smooth deceleration to ending position!!:) (short trips within 30m may produce a bit of 'bounciness' pulling into the ending position. some tweaking of FLTslowThreshold and INTdistanceSlow may help.)
// NOTE: might be interesting/useful to set up a maximum speed for the elevator, for shorter, slower trips too.

// 6) INTdefaultIndex defines the default selected floor for the elevator, to be reset every FLTseconds. set to 0 to disable (last selected floor will remain until someone changes it).

// \\\\\\\\\\\\\\\
// \\\\\\\\\\\\\\\

// SHOULDN'T HAVE TO MOD ANYTHING BELOW THIS LINE for standard use... but feel free to!:) (just make a backup first!!:)

integer BLNtesting = FALSE; // for easy toggling of llOwnerSay feedback messages while making scriptmods (use testMessage("messageHere")' instead of llOwnerSay).
float FLTmaxSpeed = 5; // 10 maximum cruising speed.
float FLTaccelStart = .01; // .01 starting value to accelerate from.
float FLTdecelMin = .1; // .1 minimum speed while coming to a stop.
vector POSITION=<-0.7,0.54,-.1>; // used to sit rider correctly. adjust x/y/z in small increments if you move the script to a different chair.
//The vectors used in this version seem to work well with a 1m X 1m square
float FLTseconds = 600; // 600 seconds (10 minutes) until default floor gets reselected. setting to 0 seconds will turn off default selection entirely; however, IT WILL ALSO DISABLE timed llListenRemoves, if the response
//to a dialog box is 'ignored'. disable only at the certainty of using up extra processor time on your sim...:(
//BE A GOOD NEIGHBOR!!:)
//float FLTseconds = 6; // i commonly use 6 seconds for testing purposes...
string STRfloor;
float FLTheight;
key KEYavi;
integer BLNreturningToStart = FALSE;
integer INTchannel;
integer INThandle;
string STRlastMessage; //to prevent certain looping testMessages from jamming the chat... helpful to debug the movement routines...




integer channel_floor_indicator =-2940;



// \\\\\\\\\\\\\\\
// \\\\\\\\\\\\\\\

testMessage(string STRmessage, string STRmessage2) {
    if ((BLNtesting == TRUE) && (STRmessage != STRlastMessage)) { //if it's not the exact same message as last time, go ahead
        llOwnerSay(STRmessage+" "+STRmessage2);
        STRlastMessage = STRmessage;
    } else {
        //
    }    
}

// \\\\\\\\\\\\\\\
// \\\\\\\\\\\\\\\
 
resetElevator() {
    BLNreturningToStart = FALSE;
    llSitTarget(POSITION, llEuler2Rot(rotateavatar * DEG_TO_RAD)); //needed to allow changed event to 'grab onto' the avi right
    setTheText();
    llSetSitText("Get on");
}

setTheText() {                        //floating text          //Line code that emit message for the FLOOR change
    integer INTheight = (integer)FLTheight;
    string STRmessage = STRfloor; //+ " | " + (string)INTheight + "m"; //EDIT THE FLOATING TEXT HERE!!:)
    //llSetText(STRmessage,<1,1,1>,1); 
      llSay(channel_floor_indicator,STRmessage); 
}

ElevatorMove() {
    testMessage("ElevatorMove","");
    
    llSetTimerEvent(0);
    llSetText("",<1,1,1>,1); //set floating text invisible for the ride...
    //llWhisper(0, "Starting your trip to the " + STRfloor + "... click the elevator to select a different floor to visit.");
     
        
        
        

     llSay(7720,"on");
    llSleep(50); //pause to allow rider to sit down...
     llSay(7732,"on");
                  llSay(7731,"on");
    // \\\\\\\\\\\\\\\ RIDE TO DESTINATION
    vector VECstartPos = llGetPos(); // platform position...
    testMessage("VECstartPos",(string)VECstartPos);
    
    vector VECtargetPos = <VECstartPos.x, VECstartPos.y, FLTheight>;
    testMessage("VECtargetPos",(string)VECtargetPos);

    float FLTtotalDistance = llVecDist(VECstartPos, VECtargetPos);
    testMessage("FLTtotalDistance",(string)FLTtotalDistance);

    float FLThalfway = FLTtotalDistance / 2;
    testMessage("FLThalfway",(string)FLThalfway);
    
    vector VECcurrentPos = llGetPos(); //setup now so we don't have to do it in a loop...
    vector VECdeltaPos = VECcurrentPos;
    
    float FLTcurrentDistance = llVecDist(VECcurrentPos, VECtargetPos); // = FLTtotalDistance;
    float FLTdelta = FLTaccelStart / 2; //.01; //!!!!!!!!!!!!!!!!!
    
    float FLTdeltaTemp = 0;
    float FLTdeltaTotal = 0;
    
    vector VECcheck;
    
    //probably plenty more optimization to be had in the following 'while' loop...:\

    while (llVecDist(VECdeltaPos, VECtargetPos) > FLTdecelMin) { // see if this'll be quicker/more responsive...
        VECcurrentPos = VECdeltaPos; //llGetPos(); //setup now so we don't have to do it in a loop...
        FLTcurrentDistance = llVecDist(VECcurrentPos, VECtargetPos); // = FLTtotalDistance;
        //testMessage("distance=",(string)FLTcurrentDistance);
        if (FLTcurrentDistance <= FLThalfway) {
            if (FLTcurrentDistance <= FLTdeltaTotal) {
                FLTdelta = FLTcurrentDistance / 2;
                if (FLTdelta < FLTdecelMin) {
                    //testMessage("DECEL|","");
                    FLTdelta = FLTdecelMin; 
                        
                      
                }
            }
        } else { //else speeding up
            if (FLTdelta < FLTmaxSpeed) { //throttle up to cruising speed...
                FLTdelta = FLTdelta * 2;
                 
                             
               
               
                
                  if (FLTdelta > FLTmaxSpeed) {
                    FLTdelta = FLTmaxSpeed;   
                    
                    
                  
                    //testMessage("MAXCRUISE",(string)FLTdeltaTotal); 
                }
                FLTdeltaTotal = FLTdeltaTotal + FLTdelta; //TOTALLING UP ACCEL DISTANCE FOR DECEL...
            }          
        }
        if (VECcurrentPos.z < VECtargetPos.z) {
            FLTdeltaTemp = FLTdelta;
        } else {
            FLTdeltaTemp = -FLTdelta;
        }
        VECdeltaPos = <VECdeltaPos.x,VECdeltaPos.y,VECdeltaPos.z + FLTdeltaTemp>;  
        llSetPos(VECdeltaPos);
    }
    llSetPos(VECtargetPos);
    testMessage("PARKED",(string)FLTdeltaTotal);
    
    
        

    
    llSay(7732,"off");
    llMessageLinked(LINK_SET,24,"stop",NULL_KEY);
    // \\\\\\\\\\\\\\\ UNBOARD AT DESTINATION
    llWhisper(0, "Enjoy your space visit! ㋡");
    llSay(7720 ,"off");
    
    llSleep(15);
  
    
  
    
    // \\\\\\\\\\\\\\\ RETURN TO STARTING FLOOR
     BLNreturningToStart = TRUE;
    while(llVecDist(llGetPos(), VECstartPos) != 0) {
        llSetPos(VECstartPos);
    }
    // \\\\\\\\\\\\\\\ BACK, NOW RESET
    resetElevator();
    llSetTimerEvent(FLTseconds);
}

setTheFloor(string STRsetTo) {
    STRfloor = STRsetTo;
    FLTheight = llList2Float(LSTheights, llListFindList(LSTmenu, [STRfloor]));
    testMessage("STRfloor = " + STRfloor ," FLTheight = " + (string)FLTheight);
}

setDefaultFloor() {
    llSetTimerEvent(0);
    llListenRemove(INThandle);
    if (INTdefaultIndex > 0) {
        setTheFloor(llList2String(LSTmenu, (INTdefaultIndex - 1)));
        testMessage("initial height set to ",(string)FLTheight);
    }
    llUnSit(KEYavi);
    resetElevator();
}

// \\\\\\\\\\\\\\\
// \\\\\\\\\\\\\\\

default {
    
    on_rez(integer start_param) { // \\\\\\\\\\\\\\\
        testMessage("","");
        testMessage("on_rez","");
        
        llResetScript();
    }
    
    state_entry() {
      
        testMessage("","");
        testMessage("state_entry","");
        
        setDefaultFloor();
    }
    
    timer() {
        testMessage("timer","");
        
        setDefaultFloor();
    }
    
    // \\\\\\\\\\\\\\\
    // \\\\\\\\\\\\\\\
    
    touch_start(integer change) {
        testMessage("touch_start","");
        
        KEYavi = llDetectedKey(0);
        INTchannel= llRound(llFrand(1000000) - 10000000);
        INThandle = llListen(INTchannel, "", "", "");
        llDialog(KEYavi, "Select launch to lauch the space shuttle", LSTmenu, INTchannel);
       
    }
    
    listen(integer channel, string name, key id, string message) {
        testMessage("listen","");
        
        llListenRemove(INThandle);
        setTheFloor(message);
        setTheText();
        llSetTimerEvent(FLTseconds);
        //llWhisper(0, message + " selected... now right-click and 'get on' to go!! :)"); //additional llWhisper feedback for floor selection - i've uncommented it 'cuz for me, the floating text change is enough. uncomment and modify if you like!:)
    }

    changed(integer change) {
        testMessage("changed","");
        
        if (change && CHANGED_LINK) {
            KEYavi = llAvatarOnSitTarget();
            if(KEYavi != NULL_KEY) {
                llRequestPermissions(KEYavi, PERMISSION_TRIGGER_ANIMATION);
                
            } else {
                if (BLNreturningToStart == FALSE) { // \\\\\\\\\\\\\\\\\
                    testMessage("changed 1 FAILED:(","");
                    testMessage("","");
                    //llUnSit(KEYavi);
                    //llWhisper(0, "Touch first to select floor...");
                } else if (BLNreturningToStart == TRUE) { // \\\\\\\\\\\
                    testMessage("changed 3 BLNreturningToStart = TRUE","");
                    
                } else { //would be a VERY weird error, as BLNreturningToStart <> true -or- false...
                    testMessage("changed 4 FAILED:(","");
                    testMessage("","");
                    
                }
                llUnSit(KEYavi);
            }
        } else {
            testMessage("changed 2 FAILED:(","");
            testMessage("","");
            
        }
    }
    
    run_time_permissions(integer perm) {
        testMessage("run_time_permissions","");
        
        ElevatorMove(); // \\\\\\\\\\\\\ ELEVATORMOVE() \\\\\\\\\\\\\\\\\
    
    }
}