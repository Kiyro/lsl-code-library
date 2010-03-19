//MELEE WEAPON SCRIPTSET - COMBINED GOREAN METER/GOREAN LADDER METER PLUGIN//
//Aug 2009 - Nexus Industries
//
//*License Conditions*
//  All that is asked is this is not resold. Give it away for free or direct inquiries to Nexus Industries.
//
//*Begin Code*

// NOTE - Refer to the Weapon Guides. You are responsible for using Legal Configurations. //
// GOREAN METER: "GM Weapon Guide" Notecard included with the meter. //
// GOREAN LADDER METER: http://www.goodman-studios.biz/docs/gorean-ladder-meter/development-guide/attack-types //
// GLM PROTOCOL INFO: http://www.goodman-studios.biz/docs/gorean-ladder-meter/development-guide/weapons-systems-protocol //

// Script doesn't rely on the Main Script's Controls, Sensor or Throttle. //
// Closed-Source plugins that demand certain settings should do the same. //

///BEGIN CONFIG///

//-Gorean Meter-//
    integer USE_GM_MODE = 1;                    // Allow Gorean Meter Mode (1 = On, 0 = Off)
    string GM_MODE_COMM = "GM";                 // Command to switch to GM Mode
    //-Weapon Params-//
    string GM_ATTACK_PARAM1 = "sword";          // "old strike/attack type"
    string GM_ATTACK_PARAM4 = "sword";          // "new strike/attack type" or "enhancement1"
    string GM_ATTACK_PARAM5 = "";               // "enhancement2"
    //-Attacks-//
    vector GM_MED_DRA = <0.55, 2.50, 2.00>;     // Medium * Up or W             | Delay (Seconds) after Attack, Sensor Range (Meters), Sensor Angle (360 / Angle)
    vector GM_LGT_DRA = <0.00, 0.00, 0.00>;     // Light * Down or S            | Delay (Seconds) after Attack, Sensor Range (Meters), Sensor Angle (360 / Angle)
    vector GM_HVY_DRA = <0.00, 0.00, 0.00>;     // Heavy * Left/Right or A/D    | Delay (Seconds) after Attack, Sensor Range (Meters), Sensor Angle (360 / Angle)
                                                // Any 0 value in LGT or HVY is replaced with the equivalent MED value.
//-Gorean Ladder Meter-//
    integer USE_GLM_MODE = 1;                   // Allow Gorean Ladder Meter Mode (1 = On, 0 = Off)
    string GLM_MODE_COMM = "GLM";               // Command to switch to GLM Mode
    //-Weapon Params-//
    string GLM_ATTACK_PARAM1 = "sword";         // "szstrike"
    string GLM_ATTACK_PARAM4 = "sword";         // "bzstrike"
    string GLM_WEAPON_HAND = "1h";              // Protocol "hand" Parameter
    string GLM_DEFENSE_MODE = "parry";          // Protocol "mode" Parameter
    //-Attacks-//
    vector GLM_MED_DRA = <0.65, 2.00, 2.00>;    // Medium * Up or W             | Delay (Seconds) after Attack, Sensor Range (Meters), Sensor Angle (360 / Angle)
    vector GLM_LGT_DRA = <0.00, 0.00, 0.00>;    // Light * Down or S            | Delay (Seconds) after Attack, Sensor Range (Meters), Sensor Angle (360 / Angle)
    vector GLM_HVY_DRA = <0.00, 0.00, 0.00>;    // Heavy * Left/Right or A/D    | Delay (Seconds) after Attack, Sensor Range (Meters), Sensor Angle (360 / Angle)
                                                // Any 0 value in LGT or HVY is replaced with the equivalent MED value.
//*END CONFIG*//

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

//string COMM_PREFIX = "GM";                  // Command Prefix and Menu Button
integer CommandLength;

integer MeterMode;

integer Permissions;

integer StanceState;
float LastAttack;
float LastDelay;

integer ControlMode;
integer AttackMode;

vector ATKSettings;

string ATKParamsGM;
string ATKParamsGLM;

integer PROTOCOL_CHAN = -458238;
integer ProtocolListen;

StartUp()
{
    llListenRemove(ProtocolListen);
    ProtocolListen = 0;

    MeterMode = 0;
    StanceState = 0;
    Permissions = 0;
    
    OwnerName = llKey2Name(OwnerKey);
    OwnerKey = llGetOwner();
    
    AttackSettings();

    if( llGetAttached() )
    {
        llRequestPermissions(OwnerKey, PERMISSION_TAKE_CONTROLS);
    }
}

AttackSettings()
{
    if( GM_LGT_DRA.x == 0.0 ) { GM_LGT_DRA.x = GM_MED_DRA.x; }
    if( GM_LGT_DRA.y == 0.0 ) { GM_LGT_DRA.y = GM_MED_DRA.y; }
    if( GM_LGT_DRA.z == 0.0 ) { GM_LGT_DRA.z = GM_MED_DRA.z; }
    if( GM_HVY_DRA.x == 0.0 ) { GM_HVY_DRA.x = GM_MED_DRA.x; }
    if( GM_HVY_DRA.y == 0.0 ) { GM_HVY_DRA.y = GM_MED_DRA.y; }
    if( GM_HVY_DRA.z == 0.0 ) { GM_HVY_DRA.z = GM_MED_DRA.z; }

    ATKParamsGM = (string)GM_MED_DRA+"||"+(string)GM_LGT_DRA+"||"+(string)GM_HVY_DRA;
                        
    if( GLM_LGT_DRA.x == 0.0 ) { GLM_LGT_DRA.x = GLM_MED_DRA.x; }
    if( GLM_LGT_DRA.y == 0.0 ) { GLM_LGT_DRA.y = GLM_MED_DRA.y; }
    if( GLM_LGT_DRA.z == 0.0 ) { GLM_LGT_DRA.z = GLM_MED_DRA.z; }
    if( GLM_HVY_DRA.x == 0.0 ) { GLM_HVY_DRA.x = GLM_MED_DRA.x; }
    if( GLM_HVY_DRA.y == 0.0 ) { GLM_HVY_DRA.y = GLM_MED_DRA.y; }
    if( GLM_HVY_DRA.z == 0.0 ) { GLM_HVY_DRA.z = GLM_MED_DRA.z; }

    ATKParamsGLM = (string)GLM_MED_DRA+"||"+(string)GLM_LGT_DRA+"||"+(string)GLM_HVY_DRA;
}

WeaponParams()
{
    if( MeterMode == 1 )
    {
        if( AttackMode == 0 ) { ATKSettings = GM_MED_DRA; }
        else if( AttackMode == 1 ) { ATKSettings = GM_LGT_DRA; }
        else if( AttackMode == 2 ) { ATKSettings = GM_HVY_DRA; }
    }
    else if( MeterMode == 2 )
    {
        if( AttackMode == 0 ) { ATKSettings = GLM_MED_DRA; }
        else if( AttackMode == 1 ) { ATKSettings = GLM_LGT_DRA; }
        else if( AttackMode == 2 ) { ATKSettings = GLM_HVY_DRA; }
    }
}

MenuRegister()
{
    if( USE_GM_MODE ) { llMessageLinked(LINK_SET,0,"GM","MENUREGCOMBAT"); }
    if( USE_GLM_MODE ) { llMessageLinked(LINK_SET,0,"GLM","MENUREGCOMBAT"); }
    //if( USE_GM_MODE || USE_GLM_MODE)
    //{
        //llMessageLinked(LINK_SET,0,llGetScriptName()+"||"+COMM_PREFIX+"||"+CHANNEL_COMM+"||Choose a Command||"+COMM_PREFIX,"MENUREG");
    //}
}

OwnerSayModes()
{
    string SayString;
    if(MeterMode)
    {
        if( MeterMode == 1 ) { SayString += "GM"; }
        else if( MeterMode == 2 ) { SayString += "GLM"; }
        SayString += " Mode Enabled.";
    }
    llOwnerSay(SayString);
}

SetWeaponStats()
{
    if(MeterMode == 1) { llMessageLinked(LINK_SET,0,ATKParamsGM,"WEAPONSETPAR"); }
    else if(MeterMode == 2) { llMessageLinked(LINK_SET,0,ATKParamsGLM,"WEAPONSETPAR"); }
}

GLMProtocolRegister(integer Inv)
{
    if(MeterMode == 2)
    {
        string SayString;
        if(Inv) { SayString += "inv "; }
        if(StanceState) { SayString += "drawn "; }
        else { SayString += "sheathed "; }
        SayString += GLM_WEAPON_HAND+" "+GLM_DEFENSE_MODE+" "+(string)llGetAttached();
        llWhisper(PROTOCOL_CHAN,SayString);
    }
}

default
{
    on_rez(integer Start) { StartUp(); }
    state_entry() { StartUp(); } //CommandLength = llStringLength(COMM_PREFIX);
    
    run_time_permissions(integer Perms)
    {
        if(Perms & PERMISSION_TAKE_CONTROLS)
        {
            Permissions = 1;
        }
    }
    
    link_message(integer Sender, integer Num, string Str, key ID)
    {
        if( ID == "WEAPONSTATE" && llGetAttached() )
        {
            if(Str == "DRAW")
            {
                StanceState = 1;
                GLMProtocolRegister(0);
                
                if( MeterMode && Permissions )
                {
                    llTakeControls(1342178111, 1, 1);
                }
            }
            else if(Str == "SHEA")
            {
                StanceState = 0;
                GLMProtocolRegister(0);
                
                if( MeterMode && Permissions )
                {
                    llReleaseControls(); Permissions = 0;
                    llRequestPermissions(OwnerKey, PERMISSION_TAKE_CONTROLS);
                }
            }
        }
        else if( ID == "WEAPONPARAMS" )
        {
            list Data = llParseString2List(llList2String(llParseString2List(Str,["||"],[]),0),["|"],[]);
            ControlMode = llList2Integer(Data,0);
            AttackMode = llList2Integer(Data,1);
            
            WeaponParams();
        }
        else if( ID == "USERINPUT" )
        {
            Str = llToLower(Str);
            
            if( llSubStringIndex(Str,"combat") == 0 )
            {
                if( llSubStringIndex(Str,"gm") == 7 && USE_GM_MODE )
                {
                    if(!ProtocolListen) { ProtocolListen = llListen(PROTOCOL_CHAN, "", NULL_KEY, ""); }

                    MeterMode = 1;
                    
                    OwnerSayModes();
                    SetWeaponStats();
                }
                else if( llSubStringIndex(Str,"glm") == 7 && USE_GLM_MODE )
                {
                    if(!ProtocolListen) { ProtocolListen = llListen(PROTOCOL_CHAN, "", NULL_KEY, ""); }
                    
                    MeterMode = 2;
                    if(StanceState) { GLMProtocolRegister(0); }
                    
                    OwnerSayModes();
                    SetWeaponStats();
                }
                else
                {
                    if(ProtocolListen) { llListenRemove(ProtocolListen); ProtocolListen = 0; }
                    MeterMode = 0;
                }
                
                if( Permissions && StanceState )
                {
                    if( MeterMode )
                    {
                        llTakeControls(1342178111, 1, 1);
                    }
                    else
                    {
                        llReleaseControls(); Permissions = 0;
                        llRequestPermissions(OwnerKey, PERMISSION_TAKE_CONTROLS);
                    }
                }
                WeaponParams();
            }
            //else if(llSubStringIndex(Str,llToLower(COMM_PREFIX)) == 0)
            //{
            //    string Input = llGetSubString(Str,CommandLength+1,-1);
            //}
        }
        else if(ID == "MENUGET")
        {
            MenuRegister();
        }
    }
    
    listen(integer Channel, string Name, key ID, string Message) 
    {
        if( llGetOwnerKey(ID) == OwnerKey )
        {
            if( Message == "fallen" && StanceState )
            {
                StanceState = 0;
                llMessageLinked(LINK_SET,0,"","FORCESHEA");
            }
            else if( Message == "inventory" && llGetAttached() )
            {
                GLMProtocolRegister(1);
            }
        }
    }
    
    control(key ID, integer Held, integer Change)
    {
        if( !StanceState ) { return; }
        else if( !MeterMode ) { return; }
        else if( !Change ) { return; }
        
        if( ControlMode == 0 && (Change & Held & CONTROL_LMB) )
        {
            float Time = llGetTime();
            if(Time - LastAttack > LastDelay)
            {
                LastAttack = Time;

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

                LastDelay = ATKSettings.x;
                llSensor("", "", AGENT, ATKSettings.y, PI / ATKSettings.z);
            }
        }
    }

    sensor(integer Num)
    {
        key TargetKey = llDetectedKey(0);
        string TargetName = llDetectedName(0);
        
        integer SayChan = (integer)("0x"+llGetSubString((string)TargetKey,0,7));
        
        string SayString;
        if(MeterMode == 1)
        {
            SayString = GM_ATTACK_PARAM1+","+OwnerName+","+TargetName;
            if(GM_ATTACK_PARAM4) { SayString += ","+GM_ATTACK_PARAM4; }
            if(GM_ATTACK_PARAM5) { SayString += ","+GM_ATTACK_PARAM5; }
        }
        else if(MeterMode == 2)
        {
            SayString = GLM_ATTACK_PARAM1+","+OwnerName+","+TargetName;
            if(GLM_ATTACK_PARAM4) { SayString += ","+GLM_ATTACK_PARAM4; }
        }
        
        llWhisper(SayChan, SayString);
    }
}