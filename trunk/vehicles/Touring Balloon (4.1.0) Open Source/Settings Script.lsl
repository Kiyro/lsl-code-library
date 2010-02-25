integer Count;
string  Notecard = "Settings";
integer LineCount;
key     ReadKey;
vector  forces;    //Upforce, DownForce, Precision
vector  defs;      //TravelForce, ArriveForce, DefaultZ
integer altChatCH; //Alternative Chat Channel
string  home;
integer distRecv;  //distanceReceived
float   distance;
float   dockZ;
integer docking;
float   dispRate;
integer chatChannel;
string  TourName;

disp(string m)
{
    llMessageLinked(LINK_SET, 411, m, NULL_KEY);
}
loadSettings()
{
    disp("Loading " + Notecard + "...");
    Count = 0;
    LineCount = 0;
    ReadKey = llGetNotecardLine(Notecard, LineCount); 
}
checkC(string m, key id)
{
    integer Index;
    list    landmarkInfo; 
    string  tempString;
    
    m = llToLower(m);
    if (m == "help")
    {
        llGiveInventory(id, "Touring Balloon Instructions");
        return;
    }    
    if (m == "reset settings")
    {
        loadSettings();
        return;
    }
    if (m == "return home")
    {
        disp("Returning home...");
        docking = FALSE;
        landmarkInfo = llCSV2List(home);
        dockZ = llList2Float(landmarkInfo,3);
        tempString = "Home," + llList2String(landmarkInfo,0) + "," + llList2String(landmarkInfo,1) + "," + \
                     llList2String(landmarkInfo,2) + "," + llList2String(landmarkInfo,3) +"," + llList2String(landmarkInfo,4);
        llMessageLinked(LINK_SET, 210, tempString, NULL_KEY);
        llSetTimerEvent(10.0);
        return;
    }
    if (m == "say settings")
    {
        llWhisper(0, "Home        = " + home);
        llWhisper(0, "DefaultZ    = " + (string)defs.z);
        llWhisper(0, "Precision   = " + (string)forces.z);
        llWhisper(0, "UpForce     = " + (string)forces.x);
        llWhisper(0, "DownForce   = " + (string)forces.y);
        llWhisper(0, "TravelForce = " + (string)defs.x);
        llWhisper(0, "ArriveForce = " + (string)defs.y);
        llWhisper(0, "Alt Chat CH = " + (string)chatChannel);
        return;
    } 
    if (llSubStringIndex(m, "speed ") == 0)
    {
        defs.x = (float)llGetSubString(m,6,18);
        llMessageLinked(LINK_SET, 237, (string)defs, llGetOwner());
        disp("Speed Set to " + (string)defs.x);
        return;
    }
    if (llSubStringIndex(m, "precision ") == 0)
    {
        forces.z = (float)llGetSubString(m,10,18);
        llMessageLinked(LINK_SET, 238, (string)forces, llGetOwner());
        disp("Timer Precision Set to " + (string)((integer)(forces.z*1000)) + " ms");
        return;
    }
    if (llSubStringIndex(m, "upforce ") == 0)
    {
        forces.x = forces.x + ((float)llGetSubString(m,8,18))/1000;
        llMessageLinked(LINK_SET, 238, (string)forces, llGetOwner());
        disp("Up Force " + (string)((integer)(forces.x*1000)));
        return;
    }
    if (llSubStringIndex(m, "downforce ") == 0)
    {
        forces.y = forces.y + ((float)llGetSubString(m,10,18))/1000;
        llMessageLinked(LINK_SET, 238, (string)forces, llGetOwner());
        disp("Down Force " + (string)((integer)(forces.y*1000)));
        return;
    }
    if (llSubStringIndex(m, "display rate ") == 0)
    {
        dispRate = (float)llGetSubString(m,13,18);
        llMessageLinked(LINK_SET, 412, (string)dispRate, llGetOwner());
        disp("Display Rate Set to " + (string)dispRate + " seconds");
        return;
    }
    if (llSubStringIndex(m, "chat channel ") == 0)
    {
        chatChannel = (integer)llGetSubString(m,13,18);
        llMessageLinked(LINK_SET, 482, (string)chatChannel, llGetOwner());
        disp("Chat Channel Set to " + (string)chatChannel);
        return;
    }
}
default
{
    state_entry()
    {
        loadSettings();    
    }
    on_rez(integer startup_param)
    {
        llResetScript();
    }
    timer()
    {
        vector position = llGetPos();
        //Check to see if we have arrived, if so, dock and then shutdown
        if (docking)
        {
            disp("Waiting to finish docking...");
            if((position.z > (dockZ - 2)) && (position.z < (dockZ + 2)))
            {
                disp("Shutting Down...");
                llMessageLinked(LINK_SET, 240, "shutdown", llGetOwner());
                llSetTimerEvent(0);
            }
        }
        else if (distance < 5)
        {
            disp("Sending Docking Command...");
            llMessageLinked(LINK_SET, 240, "dock", llGetOwner());
            docking = TRUE;
        }

    }
    link_message(integer sn, integer n, string m, key id)
    {
        if (n == 555)
        {
            distance = (float)m;
            distRecv = TRUE;
            return;
        }
        //Process API Commands
        if (n == 240)
        {
            checkC(m, id);
            return;
        }
        if (n == 95562)
        {
            checkC(m, id);
            return;
        }
    }

    dataserver(key requested, string data)
    {
        //Process Settings
        if (requested == ReadKey) 
        {
            if (data != EOF)
            {
                if ((llSubStringIndex(data, "#") != 0) && (data != ""))
                {
                    if (Count == 0)
                    {
                         home = data;
                    }
                    if (Count == 1)
                    {
                        defs.z = (float)data;  //TravelForce, ArriveForce, DefaultZ
                    }
                    if (Count == 2)
                    {
                        forces.z = (float)data;  //Upforce, DownForce, Precision
                    }
                    if (Count == 3)
                    {
                        forces.x = ((float)data)/1000;  //Upforce, DownForce, Precision
                    }
                    if (Count == 4)
                    {
                        forces.y = ((float)data)/1000;  //Upforce, DownForce, Precision
                    }
                    if (Count == 5)
                    {
                        defs.x = (float)data;   //TravelForce, ArriveForce, DefaultZ
                    }
                    if (Count == 6)
                    {
                        defs.y = (float)data;   //TravelForce, ArriveForce, DefaultZ
                    }
                    if (Count == 7)
                    {
                        dispRate = (float)data;   //Display Rate
                    }
                    if (Count == 8)
                    {
                        chatChannel = (integer)data;   //Chat Channel
                    }
                    if (Count == 9)
                    {
                        TourName = (string)data; //Default Tour Notecard Name
                    }
                    Count += 1;
                }
                LineCount += 1;
                ReadKey = llGetNotecardLine(Notecard, LineCount);
            }
            else
            {
                disp("Settings are loaded");
                //Send settings
                llMessageLinked(LINK_SET, 238, (string)forces, llGetOwner());
                llMessageLinked(LINK_SET, 237, (string)defs,   llGetOwner());
                llMessageLinked(LINK_SET, 412, (string)dispRate,   llGetOwner());
                llMessageLinked(LINK_SET, 482, (string)chatChannel,   llGetOwner());
                llMessageLinked(LINK_SET, 487, TourName,   llGetOwner());
            }
        }    
    }
}
