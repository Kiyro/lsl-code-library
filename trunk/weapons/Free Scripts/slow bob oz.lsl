// how far up
float up = 0.3;

// distance for each jump
float distance = 0.005;


//--------------------------------------------------
vector startPos;
vector curPos;
default
{
    state_entry(){
        startPos = llGetPos();
        curPos = startPos;
        while (curPos.z < startPos.z + up){
            llSetPos(curPos + <0,0,distance>);
            curPos = llGetPos();
        }
        state down;
    }
}

state down
{
    state_entry(){
        while (curPos.z > startPos.z){
            llSetPos(curPos - <0,0,distance>);
            curPos = llGetPos();
        }
        state default;
    }
}
