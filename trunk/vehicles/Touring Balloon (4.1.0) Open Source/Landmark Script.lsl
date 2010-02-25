//Landmark Inventory Script
//supports reading of drag and dropped landmarks on this vehicle

string landmarkName;
key    reqID;

default
{
    changed(integer change)
    {
        if (change == CHANGED_INVENTORY)
        {
            if (llGetInventoryNumber(INVENTORY_LANDMARK) > 0)
            {             
                landmarkName = llGetInventoryName(INVENTORY_LANDMARK, 0);
                if (llGetInventoryKey(landmarkName) != NULL_KEY)
                  reqID = llRequestInventoryData(landmarkName);
            }
        }
    }
    dataserver(key queryid, string data)
    {
        //vector localPos;
        vector regionPos;
        list   tempList;
        integer x;
        integer test;
        list navinfo;
        vector targetPos;
        vector targetRegionPos;

        if (queryid == reqID)
        {
            llRemoveInventory(landmarkName);
            
            test = llSubStringIndex(landmarkName, ",");
            if (test >= 0)
            {
                tempList = llCSV2List(landmarkName);
                landmarkName = llList2String(tempList, 0);
            }

            targetPos = (vector)data; //Get Offset to Local Position
            
            regionPos = llGetRegionCorner();
            
            targetPos = targetPos + regionPos;  //Convert targetPos to absolute world coordinates
            
            targetRegionPos = targetPos;
            targetRegionPos.x = ((integer)((targetRegionPos.x) / 256)) * 256;
            targetRegionPos.y = ((integer)((targetRegionPos.y) / 256)) * 256;
            
            vector localPos = llGetPos();
            navinfo += landmarkName;
            navinfo += ""; 
            navinfo += targetPos.x - targetRegionPos.x;
            navinfo += targetPos.y - targetRegionPos.y;
            navinfo += localPos.z; 
            navinfo += localPos.z;
            
            llMessageLinked(llGetLinkNumber(), 210, llList2CSV(navinfo), NULL_KEY); 
            llMessageLinked(llGetLinkNumber(), 200, (string)targetRegionPos, NULL_KEY);
        }
     }
}
