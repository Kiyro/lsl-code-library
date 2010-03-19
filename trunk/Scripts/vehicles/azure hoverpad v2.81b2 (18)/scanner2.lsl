//Sable Till - Radar/scannar script.
//You can get a copy of the license this script is under at http://www.gnu.org/copyleft/gpl.html
//Copyright (C) 2006 Sable Till

//This program is free software; you can redistribute it and/or
//modify it under the terms of the GNU General Public License
//as published by the Free Software Foundation; either version 2
//of the License, or (at your option) any later version.

//This program is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.

//You should have received a copy of the GNU General Public License
//along with this program; if not, write to the Free Software
//Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

string status="none";
list people;
integer maxScanDistance;
vector color = <0,1,1>;
integer maxPeople = 20;
integer scanType = AGENT;
integer scanFreq=1;

integer count(string name) {
    integer i = llListFindList(people, [name]);
    if(i ==-1){
        people+=[name, 0];
        return 0;
    } else {
        integer count = llList2Integer(people, i+1);
        people=llListReplaceList(people, [count+scanFreq], i+1, i+1);
        return count;
    }
}

//calculate time strings with proper units that are sensibly rounded
string time(integer cnt) {
    if(cnt>3600) {
        return (string)(cnt/3600)+"hr " + (string)((cnt%3600)/60) +"min";        
    }else {
       if(cnt>60) {
            return (string)(cnt/60)+"min";
        } else {
            return (string)cnt+"s";
        }
    }
}

//I'm pretty sure there's a better way to do this but I'm trying to calculate the angle between
//North and the target so I can work out which direction it is in.
float getAngle(vector me, vector target) {
    float hyp = llVecDist(me, target);
    float yDiff = target.y-me.y;
    float xDiff = target.x-me.x;
    float angle = llSin(yDiff/hyp);
    if(xDiff>0 && yDiff>0) {
        return angle*RAD_TO_DEG;
    }
    if(xDiff>0 && yDiff<0) {
        return 90-angle*RAD_TO_DEG;
    }
    if(xDiff<0 && yDiff>0) {
        return angle*RAD_TO_DEG+270;
    }
    if(xDiff<0 && yDiff<0) {
        return angle*RAD_TO_DEG + 270;
    }
    return angle*RAD_TO_DEG;
}

default
{
    state_entry()
    {
        llSetText("", <1,0,0>, 1.0);
     
    }
    link_message(integer sender_num, integer num, string str, key id)
    {
        if (str == "scanner_on")
        {
            state defaulto;
        }
    }
}

state defaulto
{
    state_entry()
    {
        llOwnerSay("type '/77 scanner off' to stop");
        llSensorRepeat("", "",scanType, 96, PI, scanFreq);
        llSetTimerEvent(6);
    }

    sensor(integer num_detected) {
        people=[];
        string result;
        integer n=-1;
        integer distance=0;
        integer detDist;
        string name;
        
        vector pos = llGetPos();
        //get the dist, name and direction of everyone we just scanned.
        for(n=0;n<num_detected && n<maxPeople;++n) {
            vector detPos = llDetectedPos(n);
            detDist = (integer)llVecDist(pos, detPos);
            float angle = getAngle(llGetPos(), detPos);
            name = llKey2Name(llDetectedKey(n));
            if(detDist<96) {
               people+=detDist;
               people+=name;
               people+=angle;
            }
        }
        //sort the strided list
        people = llListSort(people, 3, TRUE);
        //construct settext
        num_detected = llGetListLength(people)/3;
        for(n=0;n<num_detected;++n) {
            detDist=llList2Integer(people, n*3);
            name = llList2String(people, n*3+1);
            float dir = llList2Float(people, n*3+2);
            if(detDist>20 && distance<=20) {
                result+="<- Chat Range Limit ->\n";
            }
            result+=name;
            if(detDist<20) {
                integer cnt = count(name);
                result+=" ["+time(cnt)+"]";
            }
            result+=" ["+(string)detDist+"m]";
            
            if(dir < 0 || dir > 360) {
                llOwnerSay("Error:"+(string)dir+":"+name);
            }
            //determine which compass direction they are in.
            if(dir <= 22.5) {
                result+=" N\n";    
            } else {
            if(dir > 22.5 && dir <= 67.5) {
                result+=" NE\n";    
            } else {
            if(dir > 67.5 && dir <= 112.5) {
                result+=" E\n";    
            } else {
            if(dir > 112.5 && dir <= 157.5) {
                result+=" SE\n";    
            } else {
            if(dir > 157.5 && dir <= 202.5) {
                result+=" S\n";    
            } else {
            if(dir > 202.5 && dir <= 247.5) {
                result+=" SW\n";    
            } else {
            if(dir > 247.5 && dir <= 292.5) {
                result+=" W\n";    
            } else {
            if(dir > 292.5 && dir <= 337.5) {
                result+=" NW\n";    
            } else {
            if(dir > 337.5 && dir < 360) {
                result+=" N\n";
            }
            }                
            }
            
            }}}}}}
             
             distance=detDist;
        }
                

        //If we detected more (or the same number of) people as maxPeople then shrink down the scan distance to just
        //the distance to the furthest one. Otherwise increment it a bit in case there are people further out.
        if(num_detected>=maxPeople) {
            maxScanDistance=distance+10;
        } else {
            maxScanDistance+=10;
        }
        
        result+="\nStatus:"+status;
        //adjust max people based on the length of result
        if(llStringLength(result)>254) {
            maxPeople--;
            llOwnerSay("Length is "+(string)llStringLength(result) + 
                " Decrementing maxPeople to "+(string)maxPeople);
        } else {
            if(llStringLength(result)<200 && num_detected>maxPeople) {
                maxPeople++;
                llOwnerSay("Length is "+(string)llStringLength(result) +
                " Incrementing maxPeople to "+(string)maxPeople);
            }
        }
        llSetText(result, color, 1);
    }
    
    no_sensor() {
        llSetText("Status:"+status, color, 1);
        maxScanDistance+=10;        
        llSensorRepeat("", "", scanType, maxScanDistance, PI, scanFreq);         
    }
    
    
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        if (str == "scanner_off")
        {
            llResetScript();
        }
    }
    
    
    //all we do here is check the sims fps and dilation and tone down our scanning if necessary.
    timer() {
        float fps = llGetRegionFPS();
        float timeDilation = llGetRegionTimeDilation();
        
        integer scanDistance;
        if(fps<35 || timeDilation <0.9) {
            if(maxScanDistance>30) {
                scanDistance=30;
            }
            scanFreq=240;
            status = "poor";
            llSetTimerEvent(240);
            color=<1,0,0>;
        } else 
        {
        if(fps<40 || timeDilation<0.95) {
            if(maxScanDistance>64) {
                scanDistance=64;
            } else {
                scanDistance=maxScanDistance;
            }
            scanFreq=30;
            status = "ok";
            llSetTimerEvent(120);
            color=<1,1,0>;
        } else 
        {
            if(maxScanDistance>96) {
                scanDistance=96;
            } else {
                scanDistance=maxScanDistance;
            }
            scanFreq=1;
            llSetTimerEvent(60);                
            status = "good";
            color=<0,1,1>;
        }}
        llSensorRepeat("", "", scanType, scanDistance, PI, scanFreq); 
    }

}