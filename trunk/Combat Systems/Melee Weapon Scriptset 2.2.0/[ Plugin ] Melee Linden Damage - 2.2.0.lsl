//MELEE WEAPON SCRIPTSET - LINDEN DAMAGE
//Aug 2009 - Nexus Industries
//
//*License Conditions*
//  All that is asked is this is not resold. Give it away for free or direct inquiries to Nexus Industries.
//
//*Begin Code*

///BEGIN CONFIG///
//-System-//
string LINDEN_COMM = "LindenDmg";                           // Settings Prefix and Combat Modes Entry.
//-Hit Effects-//
string HIT_DAMAGER = "[ Linden Damage ]";                   // Damager Object Name.
string DAMAGE_OPTIONS = "2|4|5|10|20|25|50|100";            // Damage Amounts to set in the Menu. Arbitraty manual inputs are recognised.
///*END CONFIG*///

key OwnerKey;

integer CommandLength;

integer UseDamage;
integer DamageVal;

integer HITD;

StartUp()
{
    UseDamage = 0;
    CommandLength = llStringLength(LINDEN_COMM);
    InventoryInit();
}

DefaultSettings()
{
    DamageVal = 10;
}

InventoryInit()
{
    HITD = llGetInventoryType(HIT_DAMAGER) == INVENTORY_OBJECT;
}

MenuRegister()
{
    llMessageLinked(LINK_SET,0,LINDEN_COMM,"MENUREGCOMBAT");
    llMessageLinked(LINK_SET,0,llGetScriptName()+"||"+LINDEN_COMM+"||"+DAMAGE_OPTIONS+"||[ Select Damage Amount. ]||"+LINDEN_COMM,"MENUREG");
}

default
{
    on_rez(integer Start) { StartUp(); }
    state_entry() { StartUp(); DefaultSettings(); }

    link_message(integer Sender, integer Num, string Str, key ID)
    {
        if(ID == "USERINPUT")
        {
            Str = llToLower(Str);
            
            if( llSubStringIndex(Str, "combat") == 0 )
            {
                if( llSubStringIndex( Str, llToLower(LINDEN_COMM) ) == 7 )
                {
                    llOwnerSay("Linden Damage Enabled.");
                    UseDamage = 1;
                }
                else
                {
                    UseDamage = 0;
                }
            }
            else if( llSubStringIndex( Str, llToLower(LINDEN_COMM) ) == 0 )
            {
                integer Input = (integer)llGetSubString(Str,CommandLength+1,-1);
                if( Input )
                {
                    llOwnerSay("Linden Damage Set to "+(string)Input+".");
                    DamageVal = Input;
                }
            }
        }
        else if(ID == "WEAPONHIT")
        {
            if( UseDamage ) { llRezObject(HIT_DAMAGER, llList2Vector(llGetObjectDetails((key)Str,[OBJECT_POS]),0), ZERO_VECTOR, ZERO_ROTATION, DamageVal); }
        }
        else if(ID == "MENUGET")
        {
            MenuRegister();
        }
    }
}