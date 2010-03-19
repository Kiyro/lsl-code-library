// Second Life Offline Builder Importer
// Copyright (C) 2006 Thraxis Epsilon

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
//
// NOTE:  Code is horrible, messy, and pretty much undocumented and probably less efficient then it could be.
// NOTE2: Physics flag is disabled as items tend to fall out of the sky when it is enabled.

integer baseID;
integer baseCount;
string baseName;
integer channel;
integer gCurrentLine = 1;
key gQueryID;
string notecard = "";
list holes = [0,32,16,48];


integer primVersion = 9;
vector primPos;
integer primType;
vector primCut;
vector primDimple;
vector primProfCut;
float primHollow;
vector primTwist;
vector primTop;
vector primHoleSize;
vector primShear;
vector primTaper;
float primRevolutions;
float primRadiusOffset;
float primSkew;
integer primHollowShape;

string List2TypeCSV(list input) { // converts a list to a CSV string with type information prepended to each item
    integer     i;
    list        output;
    integer     len;

    len=llGetListLength(input); //this can shave seconds off long lists
    for (i = 0; i < len; i++) {
        output += [llGetListEntryType(input, i)] + llList2List(input, i, i);
    }
    
    return llDumpList2String(output,"~");
}

rezCounter()
{
    integer index = llGetInventoryNumber(INVENTORY_SCRIPT);
    integer i;

    for (i = 0; i < index; i++)
    {
        if (llList2String(llParseString2List(llGetInventoryName(INVENTORY_SCRIPT,i),[" "],[]),0) == baseName)
            baseCount++;
    }
    llMessageLinked(LINK_SET, baseCount,"baseCount",NULL_KEY);
}

genShape()
{
    list temp;
  if(3 == primType)//PRIM_TYPE_SPHERE
      temp = [primVersion, primType, primHollowShape, primCut, primHollow, primTwist, primDimple]; 
  else if(primType >= 0 && primType <= 2)//PRIM_TYPE_BOX,PRIM_TYPE_CYLINDER,PRIM_TYPE_PRISM
      temp = [primVersion, primType, primHollowShape, primCut, primHollow, primTwist, primTop, primShear];
  else if(primType >= 4 && primType <= 6)//PRIM_TYPE_TORUS,PRIM_TYPE_TUBE,PRIM_TYPE_RING
      temp = [primVersion, primType, primHollowShape, primCut, primHollow, primTwist, primHoleSize, primShear, primProfCut, primTaper, primRevolutions, primRadiusOffset, primSkew];
  llSay(channel,"prim=" + List2TypeCSV(temp));  
}

default
{
    
    state_entry()
    {
        baseName = llList2String(llParseString2List(llGetScriptName(),[" "],[]),0);
        baseID = llList2Integer(llParseString2List(llGetScriptName(),[" "],[]),1);
        llOwnerSay("Rezzer Engine Number " + (string)baseID + " is online."); 
        rezCounter();        
    }

    on_rez(integer num)
    {
        llResetScript();
    }                

    link_message(integer sender, integer num, string str, key id)
    {
        if (num == (999000 + baseID))
        {
            notecard = llList2String(llParseString2List(str,["|"],[]),0);        
            gCurrentLine=llList2Integer(llParseString2List(str,["|"],[]),1);
            gQueryID = llGetNotecardLine(notecard, gCurrentLine);
        }
    }

    dataserver(key query_id, string data) {        
        // Make sure this is the line we requested.
        if (query_id != gQueryID)
            return;
            
        // Convert EOFs to blank lines.
        if (data != EOF)
        {
            list param = llParseString2List(data,[" "],[]);        
            if (llList2String(param,0) == "<primitive")
            {
                channel= 0 - llFloor(llFrand(100000.0)) + 1000;
                llRezObject("block",llGetPos()+<0,0,2>,ZERO_VECTOR,ZERO_ROTATION,channel);
                string name = llGetSubString(data,(llSubStringIndex(data,"name=")),(llSubStringIndex(data,"description=") - 3));
                string description = llGetSubString(data,(llSubStringIndex(data,"description=")),(llSubStringIndex(data,"key=") - 3));
                llSay(channel,name);
                llSay(channel,description);                
            }
           if (llList2String(param,0) == "<physics")
            {
                integer val;
                if (llGetSubString(data,(llSubStringIndex(data,">") + 1),(llSubStringIndex(data,"</") - 1)) == "FALSE")
                    val = 0;
                else
                    val = 1;
                //llSay(channel,"temporary=" + (string)val);                    
            }
           if (llList2String(param,0) == "<temporary")
            {
                integer val;
                if (llGetSubString(data,(llSubStringIndex(data,">") + 1),(llSubStringIndex(data,"</") - 1)) == "FALSE")
                    val = 0;
                else
                    val = 1;                
                llSay(channel,"temporary=" + (string)val);
            }
           if (llList2String(param,0) == "<phantom")
            {
                integer val;
                if (llGetSubString(data,(llSubStringIndex(data,">") + 1),(llSubStringIndex(data,"</") - 1)) == "FALSE")
                    val = 0;
                else
                    val = 1;                
                llSay(channel,"phantom=" + (string)val);
            }
           if (llList2String(param,0) == "<material")
            {
                llSay(channel,"material=" + llGetSubString(data,(llSubStringIndex(data,"val=") + 5),(llSubStringIndex(data,">") - 2)));
            }            
           if (llList2String(param,0) == "<position")
            {
                vector temp;
                temp.x = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
                temp.y = (float)llGetSubString(llList2String(param,2),(llSubStringIndex(llList2String(param,2),"=") + 2),llStringLength(llList2String(param,2)) - 1);                
                temp.z = (float)llGetSubString(llList2String(param,3),(llSubStringIndex(llList2String(param,3),"=") + 2),llStringLength(llList2String(param,3)) - 1);
                primPos = llGetPos() + temp;
//                llSay(channel,"position="+(string)temp);
            }
           if (llList2String(param,0) == "<rotation")
            {
                rotation temp;
                temp.x = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
                temp.y = (float)llGetSubString(llList2String(param,2),(llSubStringIndex(llList2String(param,2),"=") + 2),llStringLength(llList2String(param,2)) - 1);                
                temp.z = (float)llGetSubString(llList2String(param,3),(llSubStringIndex(llList2String(param,3),"=") + 2),llStringLength(llList2String(param,3)) - 1);
                temp.s = (float)llGetSubString(llList2String(param,4),(llSubStringIndex(llList2String(param,4),"=") + 2),llStringLength(llList2String(param,4)) - 1);
                llSay(channel,"rotation="+(string)temp);
            }            
           if (llList2String(param,0) == "<size")
            {
                vector temp;
                temp.x = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
                temp.y = (float)llGetSubString(llList2String(param,2),(llSubStringIndex(llList2String(param,2),"=") + 2),llStringLength(llList2String(param,2)) - 1);                
                temp.z = (float)llGetSubString(llList2String(param,3),(llSubStringIndex(llList2String(param,3),"=") + 2),llStringLength(llList2String(param,3)) - 1);
                llSay(channel,"size="+(string)temp);
            }
           if (llList2String(param,0) == "<type")
           {
                   primType = (integer)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
           }                            
           if (llList2String(param,0) == "<cut")
            {
                primCut.x = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
                primCut.y = (float)llGetSubString(llList2String(param,2),(llSubStringIndex(llList2String(param,2),"=") + 2),llStringLength(llList2String(param,2)) - 1);                
                primCut.z = 0;
            }            
           if (llList2String(param,0) == "<dimple")
            {
                primDimple.x = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
                primDimple.y = (float)llGetSubString(llList2String(param,2),(llSubStringIndex(llList2String(param,2),"=") + 2),llStringLength(llList2String(param,2)) - 1);                
                primDimple.z = 0;
            }  
           if (llList2String(param,0) == "<advancedcut")
            {
                primProfCut.x = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
                primProfCut.y = (float)llGetSubString(llList2String(param,2),(llSubStringIndex(llList2String(param,2),"=") + 2),llStringLength(llList2String(param,2)) - 1);                
                primProfCut.z = 0;
            }
           if (llList2String(param,0) == "<hollow")
           {
                   primHollow = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
                   primHollow = primHollow / 100;
           }    
           if (llList2String(param,0) == "<twist")
            {
                primTwist.x = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
                primTwist.y = (float)llGetSubString(llList2String(param,2),(llSubStringIndex(llList2String(param,2),"=") + 2),llStringLength(llList2String(param,2)) - 1);                
                primTwist.z = 0;
            }
           if (llList2String(param,0) == "<topsize")
            {
                primTop.x = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
                primTop.y = (float)llGetSubString(llList2String(param,2),(llSubStringIndex(llList2String(param,2),"=") + 2),llStringLength(llList2String(param,2)) - 1);                
                primTop.z = 0;
            }
           if (llList2String(param,0) == "<holesize")
            {
                primHoleSize.x = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
                primHoleSize.y = (float)llGetSubString(llList2String(param,2),(llSubStringIndex(llList2String(param,2),"=") + 2),llStringLength(llList2String(param,2)) - 1);                
                primHoleSize.z = 0;
            }
           if (llList2String(param,0) == "<topshear")
            {
                primShear.x = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
                primShear.y = (float)llGetSubString(llList2String(param,2),(llSubStringIndex(llList2String(param,2),"=") + 2),llStringLength(llList2String(param,2)) - 1);                
                primShear.z = 0;
            }
           if (llList2String(param,0) == "<taper")
            {
                primTaper.x = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
                primTaper.y = (float)llGetSubString(llList2String(param,2),(llSubStringIndex(llList2String(param,2),"=") + 2),llStringLength(llList2String(param,2)) - 1);                
                primTaper.z = 0;
            }                                                 
           if (llList2String(param,0) == "<revolutions")
           {
                   primRevolutions = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
           }
           if (llList2String(param,0) == "<radiusoffset")
           {
                   primRadiusOffset = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
           }
           if (llList2String(param,0) == "<skew")
           {
                   primSkew = (float)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1);
           }
           if (llList2String(param,0) == "<hollowshape")
           {
                   primHollowShape = llList2Integer(holes,(integer)llGetSubString(llList2String(param,1),(llSubStringIndex(llList2String(param,1),"=") + 2),llStringLength(llList2String(param,1)) - 1));
           }                                 
           if (llList2String(param,0) == "</properties>")
           {
                   genShape();
                   llSay(channel,"position=" + (string)primPos);                   
                   llSay(channel,"done");                
           } 
           if (llList2String(param,0) == "</primitive>")
           {
                   llMessageLinked(LINK_SET, baseID,"complete",NULL_KEY);
                   notecard = "";
           }            
          
          gCurrentLine++;
          if ( notecard != "")
              gQueryID = llGetNotecardLine(notecard, gCurrentLine); 
        }
    }

}