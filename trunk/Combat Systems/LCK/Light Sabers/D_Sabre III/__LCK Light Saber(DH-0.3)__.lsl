//•/•/•/•/•/•/•/Ð/A/M/E/N/•/H/A/X/•/•/•/•/•/•/•/•/•//

//Do not sell this; Karma knowz where you live ☠

float D;

default{
//
    state_entry(){
        llSetTimerEvent(2.5);
        llSetStatus(PRIM_TEMP_ON_REZ,TRUE);
    }
//
    on_rez(integer Damage){
        D = (float)Damage;
        llSetDamage(D);
    }
//
    timer(){//timer to make sure the object dies
        llDie();
    }
//
    collision(integer num){
        if(llDetectedKey(0) == llGetOwner()){
            llDie();//delete object if touched by owner
        }
        else{//apply damage if touched by anyone else
            llSetDamage(D);
        }
    }
//
}
