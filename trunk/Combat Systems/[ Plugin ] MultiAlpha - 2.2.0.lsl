//MELEE/RANGE WEAPON SCRIPTSET - MULTIALPHA PLUGIN
//Aug 2009 - Nexus Industries
//
//*License Conditions*
//  All that is asked is this is not resold. Give it away for free or direct inquiries to Nexus Industries.
//
//*Begin Code*

// For the Weapon/Dummy Master Scripts; SHOW triggers when Drawn, HIDE when Sheathed. //
// For the Sheath Master Script; HIDE triggers when Drawn, SHOW when Sheathed. //

// TIP - Alpha = 1.0 - (Texture Tab Transparency / 100) //
// TIP - Prim Names do not need to match the Tag exactly, only CONTAIN the Tag. (Example "Object *A1") //

///BEGIN CONFIG///
//-Alpha-//
integer LINK_ALPHA_MODE = 2;            // 0 = Diabled.
                                        // 1 = Set All Prims. Tags are not involved, this Mode always uses Entry 1.
                                        // 2 = Set Prims where Name contains the *A Tag and a Entry Number. [Format: *A#]
                                        // 3 = Set Prims where Name does NOT contain the *A Tag, this Mode always uses Entry 1.

list ALPHA_LIST = [                     // ["SHOW", Entry 1 ShowAlpha, Entry 2 ShowAlpha, ... , "HIDE", Entry 1 HideAlpha, Entry 2 HideAlpha, ... ];    
"SHOW",         1.0,            0.5,    // MODE 2 NOTE: Referencing a higher Entry than there are in the List will have unexpected results.
"HIDE",         0.0,            0.0
]; 
///*END CONFIG*///

string BASE_TAG = "*A";

MultiAlpha(string Input)
{
    integer NumberOfPrims = llGetNumberOfPrims();
    integer StartIndex = llListFindList(ALPHA_LIST,[Input]);

    if( ~StartIndex )
    {
        if( LINK_ALPHA_MODE == 1 ) { llSetLinkAlpha(LINK_SET,llList2Float(ALPHA_LIST,StartIndex +1),ALL_SIDES); }
        else if( LINK_ALPHA_MODE == 2 )
        {
            integer CurrLink = 1;
            if( NumberOfPrims == 1 )
            {
                CurrLink = 0;
                NumberOfPrims = 0;
            }
            do
            {
                string LinkName = llGetLinkName(CurrLink);
                integer Index = llSubStringIndex(LinkName,BASE_TAG);
                if( ~Index )
                {
                    integer Entry = (integer)llGetSubString(LinkName,Index+2,-1);
                    if( Entry > 0 )
                    {
                        llSetLinkAlpha(CurrLink,llList2Float(ALPHA_LIST,StartIndex+Entry),ALL_SIDES);
                    }
                }
            }
            while( ++CurrLink <= NumberOfPrims );
        }
        else if( LINK_ALPHA_MODE == 3 )
        {
            float Alpha = llList2Float(ALPHA_LIST,StartIndex+1);

            integer CurrLink = 1;
            if( NumberOfPrims == 1 )
            {
                CurrLink = 0;
                NumberOfPrims = 0;
            }
            do
            {
                if( !~llSubStringIndex(llGetLinkName(CurrLink),BASE_TAG) )
                {
                    llSetLinkAlpha(CurrLink,Alpha,ALL_SIDES);
                }
            }
            while( ++CurrLink <= NumberOfPrims );
        }
    }
}

default
{
    link_message(integer Sender, integer Num, string Str, key ID)
    {
        if(ID == "WEAPONSTATE")
        {
            if(LINK_ALPHA_MODE) { MultiAlpha(Str); }
        }
    }
}