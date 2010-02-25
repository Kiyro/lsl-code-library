float scanWeather = 0.1;
float scanTactical = 5;
integer notify = 1;
integer interval = 1; ///----how long (in seconds it takes to update the text)
integer range = 200; ////----how far it will scan (max i can get is 96M)
string radarID="";///--default detects no one, so DO NOT CHANGE
key id; ////--- duh


default
{
    on_rez(integer params){llResetScript();} //start fresh
    
    state_entry()
    {llOwnerSay("This hud only works on land you own. For GROUP LAND, deed the security system to group");
        llTargetOmega(<0,0,1>,5,0); //see everyone around me
        llSensorRepeat("","",AGENT,range,PI,interval); //Sensor is always active
    }

    sensor(integer n) {
        integer i; 
        string blazedman; 
        vector pos; 
        vector me = llGetPos(); 
        integer dist;
        string agent = " ";
        for(i=0; i<n; i++) {
            pos = llDetectedPos(i);
            dist = (integer)llVecDist(me, pos);
            agent += " ["+llDetectedName(i)+" @ "+(string)dist+"M]\n ";
        }
        if(radarID!="")
            blazedman="["+radarID+"] : ";
        else
            blazedman = "";
        llSetText(blazedman+agent, <1,1,1>, 1); //set your color here
    }

no_sensor( ){ llSetText("", <1,1,1>, 1); ; } //when no one is around, the text goes away.
 
    }

