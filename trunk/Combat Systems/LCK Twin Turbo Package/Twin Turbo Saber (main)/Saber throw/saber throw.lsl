//Saber throw by Salene Lusch

integer num;

vector setparam(integer color) {
    integer b = color % 16;
    color = (color -b)/16;
    integer g = color % 16;
    color = (color -g)/16;
    integer r = color % 16;
    vector vcolor = <r+1,g+1,b+1>/16;
    llSetColor(vcolor, ALL_SIDES);
    llSetLinkColor(2, vcolor, ALL_SIDES);
    return vcolor;
}

default {
    state_entry() {
        setparam(0x1888);
        llLoopSound("e876e58d-f328-2202-5835-631dd647148f",1.0);
        llStopMoveToTarget();
        llSetBuoyancy(1.0);
        llTargetOmega(<0.0,0.0,1.0>,4.0,1.0);
        llSetStatus(STATUS_PHANTOM| STATUS_ROTATE_X | STATUS_ROTATE_Y ,FALSE);
        llSetStatus(STATUS_PHYSICS | STATUS_ROTATE_Z | STATUS_DIE_AT_EDGE, TRUE);
    }
    
    on_rez(integer param) {
         //llOwnerSay((string)param);
        if (param) {
            llSetTimerEvent(0.0);
            vector c = setparam(param);
            //llOwnerSay((string)c);
            llSetPrimitiveParams([PRIM_POINT_LIGHT, TRUE, 
                                     c,0.7, 4.0, 0.5, 
                                     PRIM_PHYSICS, TRUE]);
            llSetTimerEvent(2.0);
            llCollisionFilter("", llGetOwner(), FALSE);
        }
    }
    collision_start(integer n) {
        //llOwnerSay("collide + " +(string)llGetStartParameter());
        if ( llGetStartParameter()) {
          //  llOwnerSay("collide");
            llCollisionFilter("", llGetOwner(), TRUE);
            state back;
        }
    }
    
    land_collision(vector pos) {
        if ( llGetStartParameter()) {
            llCollisionFilter("", llGetOwner(), TRUE);
            state back;
        }
    }
    timer() {
        if ( llGetStartParameter()) {
            llCollisionFilter("", llGetOwner(), TRUE);
            state back;
        }
    }
}

state back 
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry() 
    {
        llSetTimerEvent(0.0);
        llMoveToTarget(llGetPos(),.1);
        llSleep(.1);
        llStopMoveToTarget();
        llSetTimerEvent(0.1);
        num = 60;
    }
    timer() 
    {
        vector pos = llList2Vector(llGetObjectDetails(llGetOwner(), [OBJECT_POS]), 0);
        if (pos == ZERO_VECTOR)
            llDie();
        vector mypos = llGetPos();
        float distance = llVecDist(mypos, pos);
        if (distance >= 60)
            pos = mypos + llVecNorm(pos - mypos) * 30.0;
        llMoveToTarget(pos,.2);
        //llOwnerSay((string)pos);
        if(distance <= 3.0 || --num<0) {
            //llWhisper(99,"saberback");
            //llSleep(0.1);
            llDie();
        }
    }
    collision_start(integer n) {
        llDie();
    }
}
    
