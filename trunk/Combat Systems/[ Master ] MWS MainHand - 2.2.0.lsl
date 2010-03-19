//MELEE WEAPON SCRIPTSET - MAINHAND MASTER
//Aug 2009 - Nexus Industries
//
//*License Conditions*
//  All that is asked is this is not resold. Give it away for free or direct inquiries to Nexus Industries.
//
//*Begin Code*

// NOTE - Alpha/Color/Glow functions are not built-in to this script, use the included plugins if they are needed.

// NOTE - All Non-System entries are optional, the script checks for missing parts. ALL INVENTORY NAMES ARE CASE-SENSITIVE.
// NOTE - List-Based Options (Ones surrounded by [] Brackets) are in the ["Item1","Item2"] format, repeated as necessary.

// Reccomended: Animations be set No Mod, to prevent breakage by accidental renaming.
// NOTE - The Script relies on the following: Stance, Block and Walk - Looped | Draw, Sheath and Attacks - Non-Looped, higher priority than Looped: Else animations will not play correctly.
// NOTE - DSTA, RSTA, BLOC and WALK should NOT use duplicate Animations, just leave blanks as duplicates will cause errors where Stances don't play.

///BEGIN CONFIG///
//-System-//
string WEAPON_CODE = "";                                    // Code for your Weapon - Should be End-User Readable (For HUD Use) - MainHand/OffHand/Sheath must Match for Comms.
integer COMM_CHAN = 4;                                      // User Input Channel. 0 or Negative is forced to 1.
string MENU_COMM = "Menu";                                  // Menu Trigger Command.
string DRAW_COMM = "Blade";                                 // Draw/Sheath Toggle Command.
string ANIM_COMM = "Style";                                 // Prefix for selecting Animation Set.
string ATTK_COMM = "Atk";                                    // Prefix for Weapon Modes; Control Modes (LMO/LMD) or Attack Modes. (Medium/Light/Heavy)
string HITE_COMM = "HitEffects";                            // Hit Effects Toggle Command.
integer SHEATH_TOUCH_MENU = 0;                              // Open the Menu instead of Toggling Draw/Sheath when the Sheath Object is touched. (1 = On, 0 = Off)
integer WEAPON_TOUCH_MENU = 0;                              // Open the Menu instead of Toggling Draw/Sheath when a Weapon Object is touched. (1 = On, 0 = Off)
integer ATTACH_POINT = 0;                                   // Require an Attachment Point to be used. (0 = Off, Else = On) http://wiki.secondlife.com/wiki/LlGetAttached
//-Defaults-//
integer DEFAULT_CONTROL = 1;                                // Control Set to use as Default on Script Reset. (0 = LMO, 1 = LMD)
string DEFAULT_COMBAT = "Basic";                            // Combat Mode to use as Default on Script Reset. Invalid setting will not do any harm.
//-Delay Times-//
float SHOW_DELAY = 1.0;                                     // Delay (Seconds) between Draw Animation and sending SHOW Command
float HIDE_DELAY = 1.0;                                     // Delay (Seconds) between Sheath Animation and sending HIDE Command
//-Attacks-//
vector ATK_MED_DRA = <0.55, 2.50, 2.00>;                    // Medium * Up or W             | Delay (Seconds) after Attack, Sensor Range (Meters), Sensor Angle (360 / Angle)
vector ATK_LGT_DRA = <0.00, 0.00, 0.00>;                    // Light * Down or S            | Delay (Seconds) after Attack, Sensor Range (Meters), Sensor Angle (360 / Angle)
vector ATK_HVY_DRA = <0.00, 0.00, 0.00>;                    // Heavy * Left/Right or A/D    | Delay (Seconds) after Attack, Sensor Range (Meters), Sensor Angle (360 / Angle)
                                                            // Any 0 value in LGT or HVY is replaced with the equivalent MED value.
//-Animations-//
list STYLE_SETS = [""];                                     // Style Names. Can use a Blank ("") if only using 1 Style. Must be a Name or Blank in every Animation List for each Set.
list DRAW_ANIMS = [""];                                     // Draw Animation Names.
list SHEA_ANIMS = [""];                                     // Sheath Animation Names.
list DSTA_ANIMS = [""];                                     // Drawn Stance Animation Names. (Left Mouse NOT HELD while Drawn.)
list RSTA_ANIMS = [""];                                     // Ready Stance Animation Names. (Left Mouse HELD. Omit and use DSTA for only 1 Stance.)
list BLOC_ANIMS = [""];                                     // Blocking Animation Names. (C/PgDn HELD while Drawn.)
list WALK_ANIMS = [""];                                     // Walk/Run Animation Names.
list ATK_UP_ANIMS = [""];                                   // W/UP Attack Animation Names.
list ATK_DN_ANIMS = [""];                                   // S/DN Attack Animation Names.
list ATK_LF_ANIMS = [""];                                   // A/LF Attack Animation Names.
list ATK_RG_ANIMS = [""];                                   // D/RG Attack Animation Names.
//-Sounds-//
string DRAW_SOUND = "afd419e7-09c0-a459-3566-20b8ebb67a10"; // Draw Sound Name or UUID
float DRAW_SVOL = 1.0;                                      // Draw Sound Volume (0.0 to 1.0)
string SHEA_SOUND = "afd419e7-09c0-a459-3566-20b8ebb67a10"; // Sheath Sound Name or UUID
float SHEA_SVOL = 1.0;                                      // Sheath Sound Volume (0.0 to 1.0)
string LOOP_SOUND = "";                                     // Loop While Drawn Sound Name or UUID
float LOOP_SVOL = 1.0;                                      // Loop Sound Volume (0.0 to 1.0)
string ATK_SOUND = "9f7e791b-6358-c226-d5af-956bbfb1bff9";  // Attack Sound Name or UUID
float ATK_SVOL = 1.0;                                       // Attack Sound Volume (0.0 to 1.0)
string HIT_SOUND = "1ceda682-c3e4-9211-0757-13915de2aef4";  // Hit Sound Name or UUID
float HIT_SVOL = 1.0;                                       // Hit Sound Volume (0.0 to 1.0)
//-Rezzing-//
string HIT_EFFECT = "[ BloodBurst ]";                       // Hit Effects Object Name - Use a PHANTOM Object, as to not cause collisions and/or weapon bannings.
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
integer InputListen;

integer Permissions;

integer StanceState;
integer StyleSet;

integer WalkHeld;
integer BlocHeld;
integer RstaHeld;

float LastAttack;
float LastDelay;

integer ControlMode;
integer AttackMode;
integer HitEffect;
string CombatMode;

vector MEDSettings;
vector LGTSettings;
vector HVYSettings;

vector ATKSettings;

string A_DRAW; string A_SHEA;
string A_DSTA; string A_RSTA; string A_BLOC; string A_WALK;
string A_ATKU; string A_ATKD; string A_ATKL; string A_ATKR;

integer DRAW; integer SHEA; 
integer DSTA; integer RSTA; integer BLOC; integer WALK;
integer ATKU; integer ATKD; integer ATKL; integer ATKR;

integer DRAS; integer SHES; integer LOOS;
integer ATKS; integer HITS;

integer HITE;

StartUp(integer CheckAtt)
{
    llListenRemove(SystemListen);
    llListenRemove(InputListen);
    Permissions = 0;
    StanceState = 0;
    
    if( CheckAtt ) { CheckAttach(); }
    
    OwnerKey = llGetOwner();
    OwnerName = llKey2Name(OwnerKey);

    MakeChannel();
    SystemListen = llListen(SystemChannel, "", NULL_KEY, "");

    if( COMM_CHAN < 1 ) { COMM_CHAN = 1; }
    InputListen = llListen(COMM_CHAN, "", OwnerKey, "");

    StyleInvInit();

    llMessageLinked(LINK_SET,1,"Combat " + CombatMode,"USERINPUT");
    AttackSettings("DEFAULT");
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
            llRequestPermissions(OwnerKey, PERM_CONTROLANIM);
            llMessageLinked(LINK_SET,0,"HIDE","WEAPONSTATE");
        }
    }
    else
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

StyleInvInit()
{
    if( StyleSet >= llGetListLength(STYLE_SETS) || StyleSet < 0 ) { StyleSet = 0; }

    A_DRAW = llList2String(DRAW_ANIMS,StyleSet);
    A_SHEA = llList2String(SHEA_ANIMS,StyleSet);
    A_DSTA = llList2String(DSTA_ANIMS,StyleSet);
    A_RSTA = llList2String(RSTA_ANIMS,StyleSet);
    A_BLOC = llList2String(BLOC_ANIMS,StyleSet);
    A_WALK = llList2String(WALK_ANIMS,StyleSet);
    A_ATKU = llList2String(ATK_UP_ANIMS,StyleSet);
    A_ATKD = llList2String(ATK_DN_ANIMS,StyleSet);
    A_ATKL = llList2String(ATK_LF_ANIMS,StyleSet);
    A_ATKR = llList2String(ATK_RG_ANIMS,StyleSet);
    
    DRAW = llGetInventoryType(A_DRAW) == INVENTORY_ANIMATION;
    SHEA = llGetInventoryType(A_SHEA) == INVENTORY_ANIMATION;
    DSTA = llGetInventoryType(A_DSTA) == INVENTORY_ANIMATION;
    RSTA = llGetInventoryType(A_RSTA) == INVENTORY_ANIMATION;
    BLOC = llGetInventoryType(A_BLOC) == INVENTORY_ANIMATION;
    WALK = llGetInventoryType(A_WALK) == INVENTORY_ANIMATION;
    ATKU = llGetInventoryType(A_ATKU) == INVENTORY_ANIMATION;
    ATKD = llGetInventoryType(A_ATKD) == INVENTORY_ANIMATION;
    ATKL = llGetInventoryType(A_ATKL) == INVENTORY_ANIMATION;
    ATKR = llGetInventoryType(A_ATKR) == INVENTORY_ANIMATION;
    DRAS = SoundCheck(DRAW_SOUND);
    SHES = SoundCheck(SHEA_SOUND);
    LOOS = SoundCheck(LOOP_SOUND);
    ATKS = SoundCheck(ATK_SOUND);
    HITS = SoundCheck(HIT_SOUND);
    HITE = llGetInventoryType(HIT_EFFECT) == INVENTORY_OBJECT;
    HitEffect = (HitEffect && (HITS || HITE));
}

integer SoundCheck(string NAME)
{
    if( (key)NAME ) {}
    else if( llGetInventoryType(NAME) == INVENTORY_SOUND ) {}
    else { return 0; }
    return 1;
}

PreInitDefaults()
{
    if( DEFAULT_CONTROL < 0 ) { DEFAULT_CONTROL = 0; }
    if( DEFAULT_CONTROL > 1 ) { DEFAULT_CONTROL = 1; }
    ControlMode = DEFAULT_CONTROL;
    CombatMode = DEFAULT_COMBAT;
}

PostInitDefaults()
{
    HitEffect = (HITS || HITE);
}

MenuRegister()
{
    llMessageLinked(LINK_SET,0,DRAW_COMM,"MENUREGDRAW");
    
    if( llGetListLength(STYLE_SETS) > 1 ) { llMessageLinked(LINK_SET,0," A||"+ANIM_COMM+"||"+llDumpList2String(STYLE_SETS,"|")+"||Select Animation Set.||"+ANIM_COMM,"MENUREG"); }
    llMessageLinked(LINK_SET,0," B||AtkModes||LMO|LMD|Medium|Light|Heavy||LMO = Left Mouse Only Attacks.\nLMD = Left Mouse Direction Attacks.\nM/L/H = Attack Stats.||"+ATTK_COMM,"MENUREG");
    if(HITS || HITE) { llMessageLinked(LINK_SET,0," C||HitEffect||NULL||NULL||"+HITE_COMM,"MENUREG"); }
}

ToggleDrawShea()
{
    if( Permissions )
    {
        if(StanceState)
        {
            if(SHEA) { llStartAnimation(A_SHEA); }
            if(SHES) { llTriggerSound(SHEA_SOUND,SHEA_SVOL); }
        
            if( StanceState == 1 && DSTA ) { llStopAnimation(A_DSTA); }
            else if( StanceState == 2 && RSTA ) { llStopAnimation(A_RSTA); }
            else if( StanceState == 3 && BLOC ) { llStopAnimation(A_BLOC); }
            else if( StanceState == 4 && WALK ) { llStopAnimation(A_WALK); }
                        
            llWhisper(SystemChannel,"SHEA!"+(string)(HIDE_DELAY-0.1));
            llMessageLinked(LINK_SET,0,"SHEA","WEAPONSTATE");
    
            if(HIDE_DELAY) { llSleep(HIDE_DELAY); }
    
            llMessageLinked(LINK_SET,0,"HIDE","WEAPONSTATE");
            StanceState = 0;
            
            llReleaseControls(); Permissions = 0;
            llRequestPermissions(OwnerKey, PERM_CONTROLANIM);
        }
        else
        {
            if(DRAW) { llStartAnimation(A_DRAW); }
            if(DRAS) { llTriggerSound(DRAW_SOUND,DRAW_SVOL); }
                        
            llWhisper(SystemChannel,"DRAW!"+(string)(SHOW_DELAY-0.1));
            llMessageLinked(LINK_SET,0,"DRAW","WEAPONSTATE");
    
            if(SHOW_DELAY) { llSleep(SHOW_DELAY); }
    
            llMessageLinked(LINK_SET,0,"SHOW","WEAPONSTATE");
            if(DSTA) { llStartAnimation(A_DSTA); }
            StanceState = 1;
            
            llTakeControls(ALL_CONTROLS, 1, 1);
        }
    }
}

OpenMenu()
{
    llMessageLinked(LINK_SET,0,"","MENUOPN");
}

AttackSettings(string Params)
{
    if( Params != "" )
    {
        list InputList = llParseString2List(Params,["||"],[]);
        string InMEDStr = llList2String(InputList,0);
        string InLGTStr = llList2String(InputList,1);
        string InHVYStr = llList2String(InputList,2);
            
        if( InMEDStr == "DEFAULT" ) { MEDSettings = ATK_MED_DRA; }
        else if( InMEDStr != "NULL" )
        {
            vector Input = (vector)InMEDStr;
            if( Input.x ) { MEDSettings.x = Input.x; }
            if( Input.y ) { MEDSettings.y = Input.y; }
            if( Input.z ) { MEDSettings.z = Input.z; }
        }
        
        if( InLGTStr == "MED" ) { InLGTStr = InMEDStr; }
        if( InLGTStr == "DEFAULT" ) { LGTSettings = ATK_LGT_DRA; }
        else if( InLGTStr != "NULL" )
        {
            vector Input = (vector)InLGTStr;
            if( Input.x ) { LGTSettings.x = Input.x; }
            if( Input.y ) { LGTSettings.y = Input.y; }
            if( Input.z ) { LGTSettings.z = Input.z; }
        }
        
        if( InHVYStr == "MED" ) { InHVYStr = InMEDStr; }
        if( InHVYStr == "DEFAULT" ) { HVYSettings = ATK_HVY_DRA; }
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
    llWhisper(SystemChannel,"WEAPONPAR!"+ATKParams);
    llMessageLinked(LINK_SET,0,ATKParams,"WEAPONPARAMS");
}

default
{
    on_rez(integer Start) { StartUp(!llGetAttached()); }
    state_entry() { PreInitDefaults(); StartUp(1); PostInitDefaults(); }
    attach(key ID)
    {
        CheckAttach();
    }

    changed(integer Change) { if(Change & CHANGED_INVENTORY) { StyleInvInit(); } }
    
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
            if(WEAPON_TOUCH_MENU) { OpenMenu(); }
            else { ToggleDrawShea(); }
        }
    }
    listen(integer Channel, string Name, key ID, string Message) 
    {
        if( llGetOwnerKey(ID) == OwnerKey && llGetAttached() )
        {
            if( Channel == SystemChannel )
            {
                if( llSubStringIndex(Message,"USERINPUT!") == 0 )
                {
                    llMessageLinked(LINK_SET,0,llGetSubString(Message,10,-1),"USERINPUT");
                }
                else if( Message == "FORCESHEA!" )
                {
                    if( StanceState ) { ToggleDrawShea(); }
                }
                else if( Message == "TOUCHSHEA!" )
                {
                    if(SHEATH_TOUCH_MENU) { OpenMenu(); }
                    else { ToggleDrawShea(); }
                }
                else if( Message == "TOUCHDUMM!" )
                {
                    if(WEAPON_TOUCH_MENU) { OpenMenu(); }
                    else { ToggleDrawShea(); }
                }
                else if( Message == "HUDDRAW!" )
                {
                    ToggleDrawShea();
                }
                else if( Message == "HUDMENU!" )
                {
                    OpenMenu();
                }
            }
            else if( Channel = COMM_CHAN )
            {
                llMessageLinked(LINK_SET,1,Message,"USERINPUT");
            }
        }
    }
    link_message(integer Sender, integer Num, string Str, key ID)
    {
        if(ID == "USERINPUT")
        {
            if(Num) { llWhisper(SystemChannel,"USERINPUT!"+Str); }

            string StrLower = llToLower(Str);
            
            if( StrLower == llToLower(MENU_COMM) )
            {
                OpenMenu();
            }
            else if( StrLower == llToLower(DRAW_COMM) )
            {
                ToggleDrawShea();
            }
            else if( llSubStringIndex(StrLower, llToLower(ANIM_COMM)) == 0 && llGetListLength(STYLE_SETS) > 1 )
            {
                string Input = llGetSubString(StrLower,llStringLength(ANIM_COMM)+1,-1);
                
                integer Index = -1;
                integer Count = llGetListLength(STYLE_SETS);
                integer Read;
                for( ; Read < Count && !~Index ; ++Read )
                {
                    if( llToLower(llList2String(STYLE_SETS,Read)) == Input )
                    {
                        Index = Read;
                    }
                }
                
                if( ~Index && Index != StyleSet )
                {
                    StyleSet = Index;
                    llOwnerSay("Animation Set: "+llList2String(STYLE_SETS,StyleSet));

                    string OldAnim;
                    if( StanceState = 1 && DSTA ) { OldAnim = A_DSTA; }
                    else if( StanceState = 2 && RSTA ) { OldAnim = A_RSTA; }
                    else if( StanceState = 3 && BLOC ) { OldAnim = A_BLOC; }
                    else if( StanceState = 4 && WALK ) { OldAnim = A_WALK; }
                    
                    StyleInvInit();
                    
                    string NewAnim;
                    if( StanceState = 1 && DSTA ) { NewAnim = A_DSTA; }
                    else if( StanceState = 2 && RSTA ) { NewAnim = A_RSTA; }
                    else if( StanceState = 3 && BLOC ) { NewAnim = A_BLOC; }
                    else if( StanceState = 4 && WALK ) { NewAnim = A_WALK; }
                    
                    if( NewAnim ) { llStartAnimation(NewAnim); }
                    if( OldAnim ) { llStopAnimation(OldAnim); }
                }
            }
            else if( llSubStringIndex(StrLower, llToLower(ATTK_COMM)) == 0 )
            {
                string Input = llGetSubString(StrLower,llStringLength(ATTK_COMM)+1,-1);
                
                string Message;
                if( Input == "lmo" )
                {
                    ControlMode = 0;
                    Message = "Attack Keys: Left Mouse Only.";
                }
                else if( Input == "lmd" )
                {
                    ControlMode = 1;
                    Message = "Attack Keys: Left Mouse + Direction.";
                }
                else if( Input == "medium" )
                {
                    AttackMode = 0;
                    Message = "Attack Mode: Medium.";
                }
                else if( Input == "light" )
                {
                    AttackMode = 1;
                    Message = "Attack Mode: Light.";
                }
                else if( Input == "heavy" )
                {
                    AttackMode = 2;
                    Message = "Attack Mode: Heavy.";
                }
                
                if( Message )
                {
                    llOwnerSay(Message);
                    AttackSettings("");
                }
            }
            else if( llSubStringIndex(StrLower, "combat") == 0 )
            {
                CombatMode = llGetSubString(Str, 7, -1);
            }
            else if( StrLower == llToLower(HITE_COMM) && (HITS || HITE) )
            {
                if(HitEffect)
                {
                    HitEffect = 0;
                    llOwnerSay("Hit Effects OFF.");
                }
                else
                {
                    HitEffect = 1;
                    llOwnerSay("Hit Effects ON.");
                }
            }
        }
        else if(ID == "FORCESHEA")
        {
            if( StanceState ) { ToggleDrawShea(); }
        }
        else if(ID == "WEAPONSETPAR")
        {
            AttackSettings(Str);
        }
        else if(ID == "MENUGET")
        {
            MenuRegister();
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
                if( ATKS ) { llTriggerSound(ATK_SOUND,ATK_SVOL); }

                string Animation;
                integer Roll = llFloor(llFrand(4.0));
                if( Roll == 0 && ATKU ) { Animation = A_ATKU; }
                else if( Roll == 1 && ATKD ) { Animation = A_ATKD; }
                else if( Roll == 2 && ATKL ) { Animation = A_ATKL; }
                else if( Roll == 3 && ATKR ) { Animation = A_ATKR; }
                if( Animation ) { llStartAnimation(Animation); }
                    
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
                if( ATKS ) { llTriggerSound(ATK_SOUND,ATK_SVOL); }
                    
                string Animation;
                if( Change & Held & CONTROL_FWD && ATKU ) { Animation = A_ATKU; }
                else if( Change & Held & CONTROL_BACK && ATKD ) { Animation = A_ATKD; }
                else if( Change & Held & CONTROL_ANYLEFT && ATKL ) { Animation = A_ATKL; }
                else if( Change & Held & CONTROL_ANYRIGHT && ATKR ) { Animation = A_ATKR; }
                if( Animation ) { llStartAnimation(Animation); }

                LastDelay = ATKSettings.x;
                llSensor("", "", AGENT, ATKSettings.y, PI / ATKSettings.z);
            }
        }

        if( StanceState != 5 && !(llGetAgentInfo(OwnerKey) & AGENT_MIDAIR) )
        {
            if( Change & Held & CONTROL_UP )
            {
                if(StanceState == 1 && DSTA) { llStopAnimation(A_DSTA); }
                else if(StanceState == 2 && RSTA) { llStopAnimation(A_RSTA); }
                else if(StanceState == 3 && BLOC) { llStopAnimation(A_BLOC); }
                else if(StanceState == 4 && WALK) { llStopAnimation(A_WALK); }
                llSetTimerEvent(0.5);
                StanceState = 5;
            }
            else if( Change & CONTROL_WALK )
            {
                if( Held & CONTROL_WALK )
                {
                    WalkHeld = 1;
                    if(WALK)
                    {
                        llStartAnimation(A_WALK);
                        llStopAnimation("walk");
                        llStopAnimation("female_walk");
                    }
                    if(StanceState == 1 && DSTA) { llStopAnimation(A_DSTA); }
                    else if(StanceState == 2 && RSTA) { llStopAnimation(A_RSTA); }
                    else if(StanceState == 3 && BLOC) { llStopAnimation(A_BLOC); }
                    StanceState = 4;
                }
                else
                {
                    WalkHeld = 0;
                    if(WALK) { llStopAnimation(A_WALK); }

                    if( (Held & CONTROL_DOWN) && BLOC )
                    {
                        if(BLOC) { llStartAnimation(A_BLOC); }
                        if(StanceState == 1 && DSTA) { llStopAnimation(A_DSTA); }
                        else if(StanceState == 2 && RSTA) { llStopAnimation(A_RSTA); }
                        StanceState = 3;
                    }
                    else if( (Held & CONTROL_LMB) && RSTA )
                    {
                        if(RSTA) { llStartAnimation(A_RSTA); }
                        if(DSTA) { llStopAnimation(A_DSTA); }
                        StanceState = 2;
                    }
                    else
                    {
                        if(DSTA) { llStartAnimation(A_DSTA); }
                        if(RSTA) { llStopAnimation(A_RSTA); }
                        StanceState = 1;
                    }
                }
            }
            else if( StanceState <= 3 && (Change & CONTROL_DOWN) && BLOC )
            {
                if( Held & CONTROL_DOWN )
                {
                    BlocHeld = 1;
                    if(BLOC) { llStartAnimation(A_BLOC); }
                    if(StanceState == 1 && DSTA) { llStopAnimation(A_DSTA); }
                    else if(StanceState == 2 && RSTA) { llStopAnimation(A_RSTA); }
                    StanceState = 3;
                }
                else
                {
                    BlocHeld = 0;
                    if(BLOC) { llStopAnimation(A_BLOC); }

                    if( (Held & CONTROL_LMB) && RSTA )
                    {
                        if(RSTA) { llStartAnimation(A_RSTA); }
                        if(DSTA) { llStopAnimation(A_DSTA); }
                        StanceState = 2;
                    }
                    else
                    {
                        if(DSTA) { llStartAnimation(A_DSTA); }
                        if(RSTA) { llStopAnimation(A_RSTA); }
                        StanceState = 1;
                    }
                }
            }
            else if( StanceState <= 2 && (Change & CONTROL_LMB) && RSTA )
            {
                if( Held & CONTROL_LMB )
                {
                    RstaHeld = 1;
                    if(RSTA) { llStartAnimation(A_RSTA); }
                    if(DSTA) { llStopAnimation(A_DSTA); }
                    StanceState = 2;
                }
                else
                {
                    RstaHeld = 0;
                    if(DSTA) { llStartAnimation(A_DSTA); }
                    if(RSTA) { llStopAnimation(A_RSTA); }
                    StanceState = 1;
                }
            }
        }
        else
        {
            WalkHeld = (Held & CONTROL_WALK);
            BlocHeld = ((Held & CONTROL_DOWN) && BLOC);
            RstaHeld = ((Held & CONTROL_LMB) && RSTA);
        }
    }
    sensor(integer Num)
    {
        key TargetKey = llDetectedKey(0);
        llMessageLinked(LINK_SET,0,(string)TargetKey,"WEAPONHIT");
        
        if(HitEffect)
        {
            vector TargetPos = llList2Vector(llGetObjectDetails(TargetKey,[OBJECT_POS]),0);
                
            if( HITS ) { llTriggerSound(HIT_SOUND,HIT_SVOL); }
            if( HITE )
            {
                vector TargSize = llGetAgentSize(TargetKey);
                llRezObject(HIT_EFFECT, TargetPos + <0,0,TargSize.z / 4>, ZERO_VECTOR, ZERO_ROTATION, 1);
            }
        }
    }
    timer()
    {
        if( StanceState != 5 ) { return; }

        if( !(llGetAgentInfo(OwnerKey) & AGENT_MIDAIR) )
        {
            llSetTimerEvent(0.0);
            if( WalkHeld )
            {
                if(WALK)
                {
                    llStartAnimation(A_WALK);
                    llStopAnimation("walk");
                    llStopAnimation("female_walk");
                }
                StanceState = 4;
            }
            else if( BlocHeld && BLOC )
            {
                if(BLOC) { llStartAnimation(A_BLOC); }
                StanceState = 3;
            }
            else if( RstaHeld && RSTA )
            {
                if(RSTA) { llStartAnimation(A_RSTA); }
                StanceState = 2;
            }
            else
            {
                if(DSTA) { llStartAnimation(A_DSTA); }
                StanceState = 1;
            }
        }
    }
}