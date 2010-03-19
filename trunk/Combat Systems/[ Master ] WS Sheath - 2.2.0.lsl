//MELEE/RANGE WEAPON SCRIPTSET - SHEATH MASTER
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
string SYNC_SUFFIX = "";                                    // [ RANGE WEAPON ONLY ] Multi-Weapon/Sheath Pair Suffix. Must Match respective Weapon. Leave Blank to turn off.
///*END CONFIG*///

key OwnerKey;
string OwnerName;
integer SystemChannel;
integer SystemListen;

integer StanceState;

StartUp()
{
    llListenRemove(SystemListen);
    StanceState = 0;
    
    OwnerKey = llGetOwner();
    OwnerName = llKey2Name(OwnerKey);
    MakeChannel();
    SystemListen = llListen(SystemChannel, "", NULL_KEY, "");
    
    llMessageLinked(LINK_SET,0,"SHOW","WEAPONSTATE");
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

default
{
    on_rez(integer Start) { StartUp(); }
    state_entry() { StartUp(); }
    
    touch_start(integer num)
    {
        if( llDetectedKey(0) == OwnerKey && llGetAttached() )
        {
            llWhisper(SystemChannel, "TOUCHSHEA!"+SYNC_SUFFIX);
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
            else if( llSubStringIndex(Message,SYNC_SUFFIX+"SHEA!") == 0 )
            {
                if(StanceState)
                {
                    float Delay = (float)llGetSubString(Message,5,-1);
                    llMessageLinked(LINK_SET,0,"SHEA","WEAPONSTATE");
                    if(Delay > 0.0) { llSleep(Delay); }
                    llMessageLinked(LINK_SET,0,"SHOW","WEAPONSTATE");
                    StanceState = 0;
                }
            }
            else if( llSubStringIndex(Message,SYNC_SUFFIX+"DRAW!") == 0 )
            {
                if(!StanceState)
                {
                    float Delay = (float)llGetSubString(Message,5,-1);
                    llMessageLinked(LINK_SET,0,"DRAW","WEAPONSTATE");
                    if(Delay > 0.0) { llSleep(Delay); }
                    llMessageLinked(LINK_SET,0,"HIDE","WEAPONSTATE");
                    StanceState = 1;
                }
            }
        }
    }
    link_message(integer Sender, integer Num, string Str, key ID)
    {
        if(ID == "USERINPUT")
        {
            if(Num) { llWhisper(SystemChannel,"USERINPUT!"+Str); }
        }
    }
}