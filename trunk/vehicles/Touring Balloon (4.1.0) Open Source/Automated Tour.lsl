//Automated Tour
//by Hank Ramos
//June 22, 2004

integer ListenAPI = 95562;
string  destName = "None";
string  region; //regionName
integer stop;
integer dests; //destionationsCount
integer regions;
integer wp = FALSE; //waypoint
integer pa; //pause
integer ar = TRUE; //arrived
vector  localP; //localPosition
float   distance;
integer distRecv; //distanceReceived
float   time;

disp(string m)
{
    llMessageLinked(LINK_SET, 411, m, NULL_KEY);
}

string cap(string v)
{
    v = llToUpper(llGetSubString(v, 0, 0)) + llGetSubString(v, 1, llStringLength(v) - 1);
    return v;
}

next()
{
    if (stop > 0)
    {
        disp("Continuing to Next Stop.");
        if(stop < dests)  
        {
            stop += 1;
        }
        else 
        {
            stop = 1;
        }
        llMessageLinked(LINK_SET, 110, (string)((integer)stop), NULL_KEY); //Process Landmark
        state idle;
    }
}

checkTC(string m, key id)
{
    integer newStop;
    
    m = llToLower(m);
    if (llSubStringIndex(m, "goto ") == 0)
    {
        newStop = (integer)llGetSubString(m, 5,8);
        if ((newStop <= dests) && (newStop > 0)) 
        { 
            stop = newStop;
            llMessageLinked(LINK_SET, 110, (string)((integer)stop), NULL_KEY); //Process Landmark
            state idle;
        }
        else 
        {
            disp("Stop #" +  (string)newStop + " is Invalid.");
        }
        return;
    }
    if (llSubStringIndex(m, "timeout ") == 0)
    {
        pa = (integer)llGetSubString(m, 8,12);
        return;
    }
    if (llSubStringIndex(m, "extend ") == 0)
    {
        pa += (integer)llGetSubString(m, 7,12);
        return;
    }
    if (m == "next")
    {
        next();
        return;
    }
    if (m == "shutdown")
    {
        stop = 0;
        state idle;
    }
}

checkM(integer n, string m, key id)
{
    if (n == 210)
    {
        string tempS;
        list L = llCSV2List(m);
        
        destName = llList2String (L, 0);
        region   = llList2String (L, 1);
        localP.x = llList2Float  (L, 2);
        localP.y = llList2Float  (L, 3);
        wp       = llList2Integer(L, 6); //Waypont
        pa       = llList2Integer(L, 7); //Pause
        
        //llMessageLinked(LINK_SET, 100, regionName, NULL_KEY); //This is done in the balloon script
        if (stop > 0)
        {
            tempS ="Destination set to Landmark #" + (string)stop + ", "; 
        }
        else
        {
            tempS ="Destination set to "; 
        }
        disp(tempS + destName + ", " + region +  \
                     "(" + (string)((integer)localP.x) + "," + (string)((integer)localP.y) + ").");
        state enroute;
    } 
    if (n == 555)
    {
        distance = (float)m;
        distRecv = TRUE;
        return;
    }
    if (n == 211)
    {
        dests = (integer)m;
        return;
    }
    if (n == 2658)
    {
        stop = 0;
        wp = FALSE;
        pa = 0;
        if (m == "reset")
        {
            state loading;
        }
        else
        {
            state idle;
        }
    }
}

//STATES
default
{
    state_entry()
    {
        disp("Initializing Automated Tour...");
        state loading;
    }
}

state loading
{
    link_message(integer sn, integer n, string m, key id)
    {
        if (n == 95562)
        {
            checkTC(m, id);
            return;
        }
        if (n == 211)
        {
            dests = (integer)m;
            state idle;
        }
        checkM(n, m, id);
    }
}

state enroute
{
    state_entry()
    {            
        distRecv = FALSE;
        distance = 999999999;
        disp("Enroute to Destination...");
    }

    on_rez(integer sp)
    {
        state idle;
    }

    link_message(integer sn, integer n, string m, key id)
    {
        if (n == 95562)
        {
            checkTC(m, id);
            return;
        }
        checkM(n, m, id);  
        if (distRecv)
        {
            if (distance < 20)
            {
                state arrive;
            }
        }
    }
}

state arrive
{
    state_entry()
    {            
        string tempS;
        
        if (stop > 0)
        {
            tempS = "Arrived at Landmark #" + (string)stop+ ", ";
        }
        else
        {
            tempS = "Arrived at ";
        }
        
        disp(tempS + destName + ", " + cap(region) +  \
                       "(" + (string)((integer)localP.x) + "," + (string)((integer)localP.y) + ").");
        if (pa > 0)
        {
            llGetAndResetTime();
            llSetTimerEvent(2.5);
        }
        if (wp)         
        {
            next();
        }   
    }

    on_rez(integer sp)
    {
        state idle;
    }

    link_message(integer sn, integer n, string m, key id)
    {
        if (n == 95562)
        {
            checkTC(m, id);
            return;
        }
        checkM(n, m, id);  
    }
    
    timer()
    {
        time = llGetTime();
        float calcTime = pa - time;
             
        if (pa > 0)
        {
            if (calcTime <= 0)       
            {
                next();
            }
            else if ((calcTime > 1) && (calcTime < 60))
            {
                disp("Leaving in " + (string)((integer)calcTime)  + " seconds.");
            }                           
            else if ((calcTime >= 60)&& (calcTime < 120))
            {
                disp("Leaving in approximately 1 minute.");
            }                           
            else if (calcTime >= 120)
            {
                disp("Leaving in " + (string)((integer)(calcTime / 60))  + " minutes.");
            }                           
        }
    }
}

state idle
{
    link_message(integer sn, integer n, string m, key id)
    {
        if (n == 95562)
        {
            checkTC(m, id);
            return;
        }
        checkM(n, m, id);
    }
}
