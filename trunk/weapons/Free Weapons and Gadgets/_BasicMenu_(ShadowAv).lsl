//•/•/•/•/•/•/•/Ð/A/M/E/N/•/H/A/X/•/•/•/•/•/•/•/•/•//

//See bottom of this script for a list of common color vectors
//if you wish to change the floating text color.

key Owner;
integer myChannel;
integer Listen;
list MainMenu = ["Text On","<<|>>", "Text Off","|>>","Help/Info","<<|"];
StartListen()
{
    Listen = llListen(myChannel,"",Owner,"");
    llSetTimerEvent(25.0);
}
StopListen()
{
    llSetTimerEvent(0.0);//Dont want to keep stopping.. so we end the timer.
    llListenRemove(Listen);//& do what timer is for; remove listen/lag.
}
//Floating Text displayed
string FloatingText = "*The Shad0w Avatar II* \n(Push control, AO, High Speed!)";
float FloatingTextAlpha = 1.0;
vector FloatingTextColor = <0.32,0.32,0.32>;
SetFloatingText()
{
    llSetText(FloatingText,FloatingTextColor,FloatingTextAlpha);   
}
default 
{
    state_entry()
    {
        Owner = llGetOwner();
        myChannel = (integer)llFrand(DEBUG_CHANNEL) * -1;
    }

    on_rez(integer total_number)
    {
        //Do every on rez
        llOwnerSay("DO NOT SELL THIS. FREE ONLY.");
        if (Owner != llGetOwner()) 
        {//Do only once for new owner
            llOwnerSay("\me (Touch me for Options ;)");
            llResetScript();
            Owner = llGetOwner();
        }
    }
//
    touch_start(integer t)
    {
        if(llDetectedKey(0) == llGetOwner())
        {
            StartListen(); 
            llDialog(llDetectedKey(0), "\n    ((Help/Info for Help/Info ;))\n*Text On & Text Off will turn the foating text on & off.", MainMenu, myChannel); 
        }
        else
        {
            llTriggerSound("b565ed8d-e3ec-383d-d640-3ceeb9bf6957",1.0);
            llSay(0,"Greetings "+llDetectedName(0)+"~ (If you own D>HuD, you have this already ;) \nTo Own >> Right click this vendor & select \"Take Copy\" from the pie menu ;) \n >>What is it?.. Full body Avatar, 99% black 1% invisible, AO, flight & push HUD included; \n >> Can I sell it? NO! This is free for everyone.");
             llSleep(5.0);
             llResetScript();//Prevent touch events stacking up/spam
        }
    }
    
    timer() //Remove lag/listen after llSetTimerEvent
    {
        StopListen();
    }
// 
    listen(integer channel, string name, key id, string message)
    {
        if (llListFindList(MainMenu, [message]) != -1)
        {
            if (message == "Text On")
            {
                llTriggerSound("f27a7a96-b053-8fc9-ec6b-f0a99ec640ae",1.0);
                SetFloatingText(); 
            }
            else if (message == "Text Off")
            {
                llTriggerSound("e41d58ad-ce27-d205-4f79-f43459d5a7da",1.0);
                llSetText(" ",<212,222,242>,0.7); 
            }
            else if (message == "Help/Info")
            {
                llTriggerSound("e41d58ad-ce27-d205-4f79-f43459d5a7da",1.0);
                llOwnerSay(" <<< The Shad0w Avatar Info >>> \nInfo~\nFree product by Optikal Ink. We only ask you do not sell it =)\n Help~\nIt's a full body avatar, treat is like any other avatar, add it to the collection ;)\nGestures included will transform you into an odd looking creature~, speed is unreal, AO is fully customizable."); 
            }
        }
        else
        {
            //
        }
    }
}
// Common colors used
//vector red = <1,0,0>; 
//vector darkred  = <0.3,0,0>;
//vector crimson = <0.5,0,0>;
//vector green  = <0,1,0>; 
//vector darkgreen  = <0,0.5,0>;
//vector forest  = <0,0.4,0>;
//vector white  = <1,1,1>;
//vector black  = <0,0,0>;
//vector gray  = <0.5,0.5,0.5>;
//vector darkgray  = <0.12,0.12,0.12>;
//vector lightgray  = <0.8,0.8,0.8>;
//vector gold  = <0.5,0.5,0>;
//vector blue  = <0,0,1>;
//vector darkblue = <0,0.25,0.5>;
//vector navyblue  = <0,0.12,0.25>;
//vector babyblue  = <0.3,0.7,0.9>;
//vector lightblue = <0.5,0.7,1>;
//vector orange  = <1,0.5,0>;
//vector yellow  = <1,1,0>;
//vector brown  = <0.5,0.25,0>;
//vector darkbrown  = <0.4,0.2,0>;
//vector pink  = <1,0.5,0.5>;
//vector shockingpink  = <1,0,0.5>;
//vector purple  = <0.5,0,1>;
//vector darkpurple  = <0.2,0,0.4>;
//vector lime  = <0.5,1,0>;
//vector sky  = <0.5,1,1>;
//vector lavander  = <0.2,0.2,0.4>;