//Region Database Script
//by Hank Ramos

key     RegionReadKey;

default
{
    state_entry()
    {
    }
    
    link_message(integer sn, integer n, string m, key id)
    {
        string tempString;
        vector tempVector;
        list   tempList;
        
        m = llToLower(m);
        if (n == 100)
        {
            //Convert Name to Vector
            RegionReadKey = llRequestSimulatorData(m, DATA_SIM_POS);
            return;
        }
        
        if (n == 999) 
        {
            llResetScript();
        }        
    }

    dataserver(key requested, string data)
    {
        if (requested == RegionReadKey)
        {
            llMessageLinked(llGetLinkNumber(), 200, data, NULL_KEY);
        }
    }
}
