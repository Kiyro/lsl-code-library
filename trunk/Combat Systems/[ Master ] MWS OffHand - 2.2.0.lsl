//MELEE WEAPON SCRIPTSET - OFFHAND MASTER
//Aug 2009 - Nexus Industries
//
//*License Conditions*
//  All that is asked is this is not resold. Give it away for free or direct inquiries to Nexus Industries.
//
//*Begin Code*

// NOTE - Alpha/Color/Glow functions are not built-in to this script, use the included plugins if they are needed.

///BEGIN CONFIG///
//-System-//
string WEAPON_CODE = "";                                    // Code for your Weapon - Should be End-User Readable (For HUD Use) - MainHand/OffHand/Sheath must Match for Comms.
integer USE_CONTROLS = 1;                                   // Take and Read Controls. Shields would want this Off unless WEAPONATTACK/HIT is needed. (1 = On, 0 = Off)
integer ATTACH_POINT = 0;                                   // Require an Attachment Point to be used. (0 = Off, Else = On) http://wiki.secondlife.com/wiki/LlGetAttached
//-Attacks-//
integer SYNC_OFFHAND = 1;                                   // Sync Delay/Range/Angle Settings from Weapon Script, some cases might need this turned Off (1 = On, 0 = Off)
vector ATTK_MED_DRA = <0.50, 2.50, 2.00>;                   // Medium * Up or W             | x = Delay (Seconds) between Attacks, y = Sensor Range (Meters), z = Sensor Angle (360 / Angle)
vector ATTK_LGT_DRA = <0.00, 0.00, 0.00>;                   // Light * Down or S            | x = Delay (Seconds) between Attacks, y = Sensor Range (Meters), z = Sensor Angle (360 / Angle)
vector ATTK_HVY_DRA = <0.00, 0.00, 0.00>;                   // Heavy * Left/Right or A/D    | x = Delay (Seconds) between Attacks, y = Sensor Range (Meters), z = Sensor Angle (360 / Angle)
                                                            // Any 0 value in LGT or HVY is replaced with the equivalent MED value.
///*END CONFIG*///

integer ALL_CONTROLS = 1342178111;      // All Controls - As of Server 1.27.2
integer CONTROL_LMB = 1342177280;       // CONTROL_LBUTTON | CONTROL_ML_LBUTTON
integer CONTROL_DIR = 783;              // CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT
integer CONTROL_WALK = 15;              // CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT
integer CONTROL_ANYLEFT = 260;          // CONTROL_LEFT | CONTROL_ROT_LEFT
integer CONTROL_ANYRIGHT = 520;         // CONTROL_RIGHT | CONTROL_ROT_RIGHT

integer AGENT_MIDAIR = 257;             // AGENT_FLYING|AGENT_IN_AIR

integer PERM_CONTROLANIM = 20;          // PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION

key OwnerKey;
string OwnerName;
integer SystemChannel;
integer SystemListen;

integer Permissions;

integer StanceState;
float LastAttack;
float LastDelay;

integer ControlMode;
integer AttackMode;

vector MEDSettings;
vector LGTSettings;
vector HVYSettings;

vector ATKSettings;

StartUp()
{
    llListenRemove(SystemListen);
    Permissions = 0;
    StanceState = 0;

    OwnerKey = llGetOwner();
    OwnerName = llKey2Name(OwnerKey);
    MakeChannel();
    SystemListen = llListen(SystemChannel, "", NULL_KEY, "");
    
    AttackSettings("DEFAULT");
        
    if( !llGetAttached() )
    {
        llMessageLinked(LINK_SET,0,"SHOW","WEAPONSTATE");
    }
}

MakeChannel()
{
    string Hash = llMD5String( WEAPON_CODE+"|"+(string)OwnerKey, 0 );
    integer I1 = (integer)("0x"+llGetSubString(Hash,0,7));
    integer I2 = (integer)("0x"+llGetSubString(Hash,8,15));
    integer I3 = (integer)("0x"+llGetSubString(Hash,16,23));
    integer I4 = (integer)("0x"+llGetSubString(Hash,24,31));
    integer I = ( (I1^I2^I3^I4) & 0x7FFFFFFF );
    
    SystemChannel = -851000000 - (I % 999999);
}

CheckAttach()
{
    integer Attach = llGetAttached();
    if( Attach )
    {
        if( ATTACH_POINT && llGetAttached() != ATTACH_POINT )
        {
            llOwnerSay("Incorrect Attachment Point.");
            llRequestPermissions(OwnerKey, PERMISSION_ATTACH);
        }
        else
        {
            llRequestPermissions(OwnerKey, PERMISSION_TAKE_CONTROLS);
            llMessageLinked(LINK_SET,0,"HIDE","WEAPONSTATE");
        }
    }
}

AttackSettings(string Params)
{
    if( Params != "" )
    {
        list InputList = llParseString2List(Params,["||"],[]);
        string InMEDStr = llList2String(InputList,0);
        string InLGTStr = llList2String(InputList,1);
        string InHVYStr = llList2String(InputList,2);
            
        if( InMEDStr == "DEFAULT" ) { MEDSettings = ATTK_MED_DRA; }
        else if( InMEDStr != "NULL" )
        {
            vector Input = (vector)InMEDStr;
            if( Input.x ) { MEDSettings.x = Input.x; }
            if( Input.y ) { MEDSettings.y = Input.y; }
            if( Input.z ) { MEDSettings.z = Input.z; }
        }
        
        if( InLGTStr == "MED" ) { InLGTStr = InMEDStr; }
        if( InLGTStr == "DEFAULT" ) { LGTSettings = ATTK_LGT_DRA; }
        else if( InLGTStr != "NULL" )
        {
            vector Input = (vector)InLGTStr;
            if( Input.x ) { LGTSettings.x = Input.x; }
            if( Input.y ) { LGTSettings.y = Input.y; }
            if( Input.z ) { LGTSettings.z = Input.z; }
        }
        
        if( InHVYStr == "MED" ) { InHVYStr = InMEDStr; }
        if( InHVYStr == "DEFAULT" ) { HVYSettings = ATTK_HVY_DRA; }
        else if( InHVYStr != "NULL" )
        {
            vector Input = (vector)InHVYStr;
            if( Input.x ) { HVYSettings.x = Input.x; }
            if( Input.y ) { HVYSettings.y = Input.y; }
            if( Input.z ) { HVYSettings.z = Input.z; }
        }

        if( LGTSettings.x == 0.0 ) { LGTSettings.x = MEDSettings.x; }
        if( LGTSettings.y == 0.0 ) { LGTSettings.y = MEDSettings.y; }
        if( LGTSettings.z == 0.0 ) { LGTSettings.z = MEDSettings.z; }
        if( HVYSettings.x == 0.0 ) { HVYSettings.x = MEDSettings.x; }
        if( HVYSettings.y == 0.0 ) { HVYSettings.y = MEDSettings.y; }
        if( HVYSettings.z == 0.0 ) { HVYSettings.z = MEDSettings.z; }
    }
                    
    if( AttackMode == 0 ) { ATKSettings = MEDSettings; }
    else if( AttackMode == 1 ) { ATKSettings = LGTSettings; }
    else if( AttackMode == 2 ) { ATKSettings = HVYSettings; }

    string ATKParams = (string)ControlMode+"|"+(string)AttackMode+"||"+(string)MEDSettings+"||"+(string)LGTSettings+"||"+(string)HVYSettings;
    //llWhisper(SystemChannel,"WEAPONPAR!"+ATKParams); //Would cause an infinite loop if OffHand Synced to MainHand. If Syncing both ways is requested, I'll fix this.
    llMessageLinked(LINK_SET,0,ATKParams,"WEAPONPARAMS");
}

default
{
    state_entry() { StartUp(); }
    on_rez(integer Start) { StartUp(); CheckAttach(); }
    attach(key ID)
    {
        if( ID ) { CheckAttach(); }
    }
    
    run_time_permissions(integer Perms)
    {
        if(Perms & PERMISSION_TAKE_CONTROLS)
        {
            Permissions = 1;
        }
        else if(Perms & PERMISSION_ATTACH)
        {
            llDetachFromAvatar();
        }
    }
    touch_start(integer num)
    {
        if( llDetectedKey(0) == OwnerKey && llGetAttached() )
        {
            llWhisper(SystemChannel, "TOUCHDUMM!");
        }
    }
    listen(integer Channel, string Name, key ID, string Message) 
    {
        if( llGetOwnerKey(ID) == OwnerKey && llGetAttached() )
        {
            if( llSubStringIndex(Message,"USERINPUT!") == 0 )
            {
                llMessageLinked(LINK_SET,0,llGetSubString(Message,10,-1),"USERINPUT");
            }
            else if( llSubStringIndex(Message,"SHEA!") == 0 )
            {
                if(StanceState)
                {
                    float Delay = (float)llGetSubString(Message,5,-1);
                    llMessageLinked(LINK_SET,0,"SHEA","WEAPONSTATE");
                    if(Delay > 0.0) { llSleep(Delay); }
                    llMessageLinked(LINK_SET,0,"HIDE","WEAPONSTATE");
                    StanceState = 0;
                    
                    if( USE_CONTROLS ) { llReleaseControls(); Permissions = 0; }
                    llRequestPermissions(OwnerKey, PERMISSION_TAKE_CONTROLS);
                }
            }
            else if( llSubStringIndex(Message,"DRAW!") == 0 )
            {
                if(!StanceState)
                {
                    float Delay = (float)llGetSubString(Message,5,-1);
                    llMessageLinked(LINK_SET,0,"DRAW","WEAPONSTATE");
                    if(Delay > 0.0) { llSleep(Delay); }
                    llMessageLinked(LINK_SET,0,"SHOW","WEAPONSTATE");
                    StanceState = 1;
                    
                    if( Permissions && USE_CONTROLS )
                    {
                        llTakeControls(ALL_CONTROLS, 1, 1);
                    }
                }
            }
            else if( llSubStringIndex(Message,"WEAPONPAR!") == 0 )
            {
                list Input = llParseString2List(llGetSubString(Message,10,-1),["||"],[]);
                string Modes = llList2String(Input,0);
                string Dump = llDumpList2String(llDeleteSubList(Input,0,0),"||");
                Input = llParseString2List(Modes,["|"],[]);
                
                ControlMode = llList2Integer(Input,0);
                AttackMode = llList2Integer(Input,1);
                
                if( SYNC_OFFHAND ) { AttackSettings(Dump); }
            }
        }
    }
    link_message(integer Sender, integer Num, string Str, key ID)
    {
        if(ID == "USERINPUT")
        {
            if(Num) { llWhisper(SystemChannel,"USERINPUT!"+Str); }
        }
        else if(ID == "FORCESHEA")
        {
            llWhisper(SystemChannel,"FORCESHEA!");
        }
        else if(ID == "WEAPONSETPAR")
        {
            AttackSettings(Str);
        }
    }
    control(key ID, integer Held, integer Change)
    {
        if( !StanceState ) { return; }
        else if( !Change ) { return; }
        
        if( ControlMode == 0 && (Change & Held & CONTROL_LMB) )
        {
            float Time = llGetTime();
            if(Time - LastAttack > LastDelay)
            {
                LastAttack = Time;
                    
                llMessageLinked(LINK_SET,0,"","WEAPONATTACK");
                    
                LastDelay = ATKSettings.x;
                llSensor("", "", AGENT, ATKSettings.y, PI / ATKSettings.z);
            }
        }
        else if( ControlMode == 1 && (Held & CONTROL_LMB) && (Change & Held & CONTROL_DIR) )
        {
            float Time = llGetTime();
            if(Time - LastAttack > LastDelay)
            {
                LastAttack = Time;
                        
                llMessageLinked(LINK_SET,0,"","WEAPONATTACK");
    
                LastDelay = ATKSettings.x;
                llSensor("", "", AGENT, ATKSettings.y, PI / ATKSettings.z);
            }
        }
    }
    sensor(integer Num)
    {
        llMessageLinked(LINK_SET,0,(string)llDetectedKey(0),"WEAPONHIT");
    }
}