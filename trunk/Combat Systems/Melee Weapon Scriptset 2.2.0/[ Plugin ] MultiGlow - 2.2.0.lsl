//MELEE/RANGE WEAPON SCRIPTSET - MULTIGLOW PLUGIN
//Aug 2009 - Nexus Industries
//
//*License Conditions*
//  All that is asked is this is not resold. Give it away for free or direct inquiries to Nexus Industries.
//
//*Begin Code*

// NOTE - The Forced Sleep of llSetLinkPrimitiveParams heavily slows down MultiGlow. //
// Vote on the JIRA entry: llSet(Link)Glow - http://jira.secondlife.com/browse/SVC-4011 //

// For the Weapon/Dummy Master Scripts; SHOW triggers when Drawn, HIDE when Sheathed. //
// For the Sheath Master Script; HIDE triggers when Drawn, SHOW when Sheathed. //

// TIP - Prims that Glow should be Full Bright (Texture Tab) for precise control over the Glow appearance. //
// TIP - Prim Names do not need to match the TAG exactly, only CONTAIN the Tag. (Example "Object *G1") //

///BEGIN CONFIG///
//-Glow-//
integer LINK_GLOW_MODE = 2;             // 0 = Diabled.
                                        // 1 = Set All Prims. Tags are not involved, this Mode always uses Entry 1.
                                        // 2 = Set Prims where Name contains the *G Tag and a Entry Number. [Format: *G#]
                                        // 3 = Set Prims where Name does NOT contain the *G Tag, this Mode always uses Entry 1.

list GLOW_LIST = [                      // ["SHOW", Entry 1 ShowAlpha, Entry 2 ShowAlpha, ... , "HIDE", Entry 1 HideAlpha, Entry 2 HideAlpha, ... ];    
"SHOW",         0.1,            .05,    // MODE 2 NOTE: Referencing a higher Entry than there are in the List will have unexpected results.
"HIDE",         0.0,            0.0
]; 
///*END CONFIG*///

string BASE_TAG = "*G";

MultiGlow(string Input)
{
    integer NumberOfPrims = llGetNumberOfPrims();
    integer StartIndex = llListFindList(GLOW_LIST,[Input]);

    if( ~StartIndex )
    {
        if( LINK_GLOW_MODE == 1 ) { llSetLinkPrimitiveParams(LINK_SET, [PRIM_GLOW,ALL_SIDES,llList2Float(GLOW_LIST,StartIndex+1)]); }
        else if( LINK_GLOW_MODE == 2 )
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
                        llSetLinkPrimitiveParams(CurrLink, [PRIM_GLOW,ALL_SIDES,llList2Float(GLOW_LIST,StartIndex+Entry)]);
                    }
                }
            }
            while( ++CurrLink <= NumberOfPrims );
        }
        else if( LINK_GLOW_MODE == 3 )
        {
            float Glow = llList2Float(GLOW_LIST,StartIndex+1);

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
                    llSetLinkPrimitiveParams(CurrLink, [PRIM_GLOW,ALL_SIDES,Glow]);
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
            if(LINK_GLOW_MODE) { MultiGlow(Str); }
        }
    }
}