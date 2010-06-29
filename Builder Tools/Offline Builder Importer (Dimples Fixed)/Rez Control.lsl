// Second Life Offline Builder Importer
// Copyright (C) 2006  Thraxis Epsilon

// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.



string notecard;
integer statusMax;
list rezzers = [];
integer working = 0;
key gQueryID;
integer gCurrentLine = 0;

default
{
    on_rez(integer num)
    {
        llResetScript();
    }
    
    link_message(integer link, integer num, string str, key id)
    {
        if(str == "complete")
        {
            rezzers = rezzers + [num];
            if (gQueryID == NULL_KEY)
            {
                gQueryID = llGetNotecardLine(notecard,gCurrentLine);
            }
        }
        if(str == "baseCount")
        {
            statusMax = num;
            integer i;
            rezzers = [];
            for(i=0; i < num; i++)
            {
                rezzers = rezzers + [i];
            }
        }   
    }
  
        
    changed(integer change)
    {
        if ((change & CHANGED_INVENTORY) && (working == 0))
        {
            notecard = llGetInventoryName(INVENTORY_NOTECARD,2);
            working = 1;
            llOwnerSay("Offline Build Import:  STARTING");
            gCurrentLine=0;
            gQueryID = llGetNotecardLine(notecard, gCurrentLine);
        }
    }    
    
    timer()
    {
        if ( llGetListLength(rezzers) == statusMax)
        {
            llSetTimerEvent(0);
            working = 0;
            llRemoveInventory(notecard);
            llOwnerSay("Offline Build Import:  Completed");
        }
    }
    
    dataserver(key query_id, string data) {        
        // Make sure this is the line we requested.
        if (query_id != gQueryID)
            return;
            
        if (data != EOF)
        {
            list param = llParseString2List(data,[" "],[]);        
            if (llList2String(param,0) == "<primitive")
            {
                llMessageLinked(LINK_SET,999000 + llList2Integer(rezzers,0),notecard + "|" + (string)gCurrentLine,NULL_KEY);
                if (llGetListLength(rezzers) == 1)
                {
                    rezzers = [];
                    gQueryID = NULL_KEY;
                }
                else
                {
                    rezzers = llList2List(rezzers,1,-1);
                }
                gCurrentLine= gCurrentLine + 37;           
            }       
            if (llList2String(param,0) == "</primitives>")
            {
                llOwnerSay("Offline Build Import:  Last Prim Sent");
                llSetTimerEvent(5);                 
            }          
          gCurrentLine++;
          if (llGetListLength(rezzers) > 0) 
          {
              gQueryID = llGetNotecardLine(notecard, gCurrentLine);
          }
        }
        else
        {
            llOwnerSay("Offline Build Import:  FINISHING");
            llSetTimerEvent(5);                                
        }  
    }
}
