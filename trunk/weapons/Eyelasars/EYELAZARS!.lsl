//JOETHECATBOY FREELUNCH'S EASY GUN SCRIPT, v1.0 EXCLUSIVELY FOR AMC
//CHANGE GLOBAL VARIABLES TO CUSTOMIZE GUN
//
//Please keep distribution of these scripts to AMC group members ONLY!  Please set as NOMOD, COPY, NOTRANSFER when vended INSIDE A WEAPON
//Thanks for complying, good luck!
//
//
//*******************************************************


//**ANIMATIONS**
string RELOAD_ANIM = ""; //Animation for reloading.
string HOLD_ANIM = "";  //Anim for holding,  Possible default anims are hold_R_handgun, hold_R_rifle, and hold_R_bazooka
//**SOUNDS**
string RELOAD_SOUND = ""; //Sound for reloading
string FIRE_SOUND = "13cb033d-90ea-455b-7e55-a2f11efc5bcf"; //Sound to use when firing
//**BULLET**
string BULLET_NAME = "lasershot"; //Bullet name here
//**MECHANICS**
float DELAY = 0.1; //Sec delay between firing
float RELOAD_DELAY = 0.5; //Sec delay between reloading
integer AUTO = FALSE; //Is the gun automatic or not?  Auto guns with SMALL FIRING DELAYS need more than 1 BULLET REZZER SCRIPT
integer NUMBER_OF_FIRE_SCRIPTS = 1; //However many scripts we have that rez bullets.  If AUTO = FALSE, we should only need 1
//**CLIP**
integer MAG_SIZE = 7; //This is how big your magazine/clip is


//DO NOT CHANGE
integer FIRETYPE;
integer FIRE = 1; //Link message num
integer RELOAD = -1; //Link message num
integer usedBullets; //counter for number of bullets shot
//*******************************************************


//DO NOT EDIT BELOW HERE, UNLESS YOU KNOW WHAT YOU'RE DOING
default //default...
{
    state_entry() //When reset...
    {
        llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS); //Ask to get permissions for control and animations
    }
    attach(key id) //When attached
    {
        if (id == NULL_KEY) //When detached
        {
            llStopAnimation(HOLD_ANIM); //Stop our animation
            llReleaseControls(); //Release controls
            return; //Exit event
        }
        llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS); //Ask to get permissions...
    }
    run_time_permissions(integer perm) //When permissions event is triggered
    {
        if (perm & PERMISSION_TAKE_CONTROLS|PERMISSION_TRIGGER_ANIMATION) //If they said yes
        {
            llTakeControls(CONTROL_ML_LBUTTON,TRUE,FALSE); //Take their mouse-click for firing
        }
    }
    control(key id, integer held, integer change) //When a control is triggered
    {
        if (FIRE > NUMBER_OF_FIRE_SCRIPTS) //If our counter is greater than however many rezzers we have
            FIRE = 1; //Reset to 1
        if (AUTO) //If we're in AUTO mode
            FIRETYPE = held & CONTROL_ML_LBUTTON; //Change control to register when the button is HELD
        else //Otherwise we're not in AUTO mode
            FIRETYPE = held & change & CONTROL_ML_LBUTTON; //Change control to register when the button is clicked DOWN
        if (FIRETYPE && usedBullets < MAG_SIZE) //If they clicked down on the mouse, and if they have bullets in the magazine still
        {
            llMessageLinked(LINK_SET,0,"charge","");
            llPlaySound("fb49e6bd-7c01-24f4-f6f9-11098539aeee",0.3);
        }
        else if (~held & change & CONTROL_ML_LBUTTON)
        {
            llPlaySound(FIRE_SOUND,0.3);
            llMessageLinked(LINK_SET,FIRE,BULLET_NAME,NULL_KEY); //Tell our FIRE script to FIRE with BULLETNAME
            FIRE++; //Add 1 to our fire counter (to trigger specific scripts, and circumvent the .2 sec delay between rezzing :)
            //usedBullets++;
            llSleep(DELAY); //Sleep our script for a delay
        }
    }
}
