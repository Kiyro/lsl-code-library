//JOETHECATBOY FREELUNCH'S EASY GUN SCRIPT, v1.0
//CHANGE GLOBAL VARIABLES TO CUSTOMIZE GUN
//
//Please do not redistribute stand-alone scripts, however distribution of scripted guns/items with these scripts IS ENCOURAGED, as long as the scripts are NOMOD, COPY, NOTRANSFER when vended
//Thanks for complying, good luck!
//
//
//*******************************************************

integer FIRE = 1; //Rezzer num.  If there are more than 1 rezzer scripts (for SMG's or automatics) each script should have a unique number (1, 2, 3 ...)

vector OFFSET = <3.0,-0.12,0.92>; //Distance from gun to rez the bullet at.  To prevent the bullet from rezzing INSIDE the shooter, use an offset of more than HALF of the bullets Z size

float BULLET_VELOCITY = 100.0; //Meters/sec to rez the bullet at. Faster bullets need to be LONGER for maximum hit-detection

default
{
    link_message(integer sendernum, integer num, string str, key id)
    {
        if (num == FIRE)
            llRezObject(str,llGetPos() + OFFSET*llGetRot(),llRot2Fwd(llGetRot()) * BULLET_VELOCITY,llGetRot(),1);
    }
}