integer count;
list    dests;
string  notecard;
integer lineCount;
key     readKey;

displayMessage(string m)
{
    llMessageLinked(LINK_SET, 411, m, NULL_KEY);
}
loadLandmarks()
{
    displayMessage("Loading " + notecard + "...");
    dests = [];
    count = 0;
    lineCount = 0;
    readKey = llGetNotecardLine(notecard, lineCount); 
}

checkC(string m, key id)
{
    integer index;
    list    landmarkInfo;
    string  testM;

    testM = llToLower(m);

    if (llSubStringIndex(testM, "destination notecard ") == 0)
    {
        notecard =llGetSubString(m, 21, 100);
        displayMessage("Destination Notecard Changed To: " + notecard + ".");
        llMessageLinked(LINK_SET, 2658, "reset", NULL_KEY);
        loadLandmarks();
        return;
    }
    if (llSubStringIndex(testM, "notecard ") == 0)
    {
        notecard =llGetSubString(m, 9, 100);
        displayMessage("Destination Notecard Changed To: " + notecard + ".");
        llMessageLinked(LINK_SET, 2658, m, NULL_KEY);
        loadLandmarks();
        return;
    }
    if ((testM == "reset destinations") || (testM == "reset notecards"))
    {
        loadLandmarks();
        return;
    }
    if (testM == "say destinations")
    {
        //Get Landmark Info
        for (index = 0;index < count;index += 1)
        {
            landmarkInfo = llCSV2List(llList2String(dests, index));
            
            llWhisper(0, "Destination #" + (string)(index +1) + ": " + llList2String(landmarkInfo,0));
        }
        return;      
    } 
}

string getLandmark(integer index)
{    
    index -= 1;
    return llList2String(dests, index);
}

default
{
    state_entry()
    {
    }
    link_message(integer sn, integer n, string m, key id)
    {
        if (n == 95562)
        {
            checkC(m, id);
            return;
        }
        if (n == 487)
        {
            notecard = m;
            loadLandmarks();
            return;
        }
        if (n == 110) 
        { 
            //Get Landmark Info
            llMessageLinked(LINK_SET, 210, getLandmark((integer)m), NULL_KEY);
        }
    }

    dataserver(key requested, string data)
    {
        list L;
        
        //Process Landmarks
        if (requested == readKey) 
        {
            L = llCSV2List(data); 
            if (data != EOF)
            {
                if ((llSubStringIndex(data, "#") != 0) && (llGetListLength(L) == 8))
                {
                    dests += data;
                    count += 1;
                }
                lineCount += 1;
                readKey = llGetNotecardLine(notecard, lineCount);
            }
            else
            {
                displayMessage("There are " + (string)(count) + " destinations loaded.");
                llMessageLinked(LINK_SET, 211, (string)count, NULL_KEY);
            }
        }    
    }
}
