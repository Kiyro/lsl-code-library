//END-USER LICENSE AGREEMENT

//I. Terms and Conditions:
//Per the terms and conditions under the GNU General Public License, you may:

//1) Freely modify the source code of this script, so long as those modifications are properly documented within the body of the source code up to and including derivative works based upon this script under the understanding that such works fall under the GPL license. Stand-alone works (animations, sounds, textures, prims, or precompiled modules) designed to operate in conjunction with this script do not fall under this agreement and are not subject to the GPL.

//2) Freely distribute this script to any third party as deemed appropriate for public or private use so long as this notice and a copy of the GNU GPL are included.

//Per the agreement, you may NOT:

//1) Sell modified versions of this script without the express written permission of the original author unless the derivative work uses less than 20% of the original source code.


//II. Warranty Information
//This product comes "as-is" with no express or implied warranty. You may not hold the original author or any authors of derived work accountable for damages associated with the use or modification of this script unless those authors provide a statement of warranty in writing.

//III. Retroactive License.
///The terms and conditions of this script, upon entering into public domain, affect all prior versions of this script that carry the same name. All previous versions of this script, whether written by the original author or others who claim association with said author, now fall under the jurisdiction of the GPL and are subject to the terms and conditions contained therein.

//Please refer to the included GNU GPL license notecard for additional information.

/////////////////////////////////////////////////////////////////////////////////////////////////////////


// Default values
string style1;
string style2;
string style3;
string style4;
string style5;
string style6;
string style7;
string style8;


// Globals
integer iNotecardIndex;
integer iNotecardCount;
integer iNoteCardLine;
key kCurrentDataRequest;
string sSettingsNotecard = "STYLES";


integer StringLeftICompare( string sLeftMatch, string sLongString )
{
    integer iLength;

    iLength = llStringLength( sLeftMatch ) - 1;
    if( llToLower(llGetSubString( sLongString, 0, iLength ) ) == llToLower(sLeftMatch) )
        return( TRUE );
    return( FALSE );
}


string GetValue( string sString )
{
    integer iStart;
    string sValue = "";
    string sbValue = "";

    iStart = llSubStringIndex( sString, "=" ) + 1;
    if( iStart )
    {
        sValue = llGetSubString( sString, iStart, llStringLength(sString) - 1 );
        if( sValue )
        {
            sbValue = llToLower( sValue );
            if( sbValue == "true" )
                sValue = "1";
            if( sbValue == "false" )
                sValue = "0";
            return( sValue );
        }
    }
    return( NULL_KEY );
}


default
{
    on_rez( integer param )
    {
        llResetScript();
    }

    state_entry()
    {
        integer iii;
    
        //llSetText( "Initializing...", <0,0.5,0>, 1.0 );

        iNotecardCount = llGetInventoryNumber( INVENTORY_NOTECARD );
        iNotecardIndex = 0;
        if( iNotecardCount > iNotecardIndex )
        {
            sSettingsNotecard = llGetInventoryName( INVENTORY_NOTECARD, iNotecardIndex );
            iNoteCardLine = 0;
            kCurrentDataRequest = llGetNotecardLine( sSettingsNotecard, iNoteCardLine );
            iNotecardIndex++;
        }
        if( iNotecardIndex == 0 )
        {
            llWhisper( 0, "Using Default Values." );
            state run_object;
        }
    }
    changed(integer kind)
    {
        if(kind & CHANGED_INVENTORY)
        {
            llResetScript();
        }
    }

    dataserver( key kQuery, string sData )
    {
        list lSetting;

        kCurrentDataRequest = "";
        if( sData != EOF )
        {
            // you can string several of these tests for whatever values you may want.

            if( StringLeftICompare( "style1=", sData ) )
                style1 = (string)GetValue( sData );
                
            else if( StringLeftICompare( "style2=", sData ) )
                style2 = (string)GetValue( sData );
                
            else if( StringLeftICompare( "style3=", sData ) )
                style3 = (string)GetValue( sData );
                
            else if( StringLeftICompare( "style4=", sData ) )
                style4 = (string)GetValue( sData );
                
            else if( StringLeftICompare( "style5=", sData ) )
                style5 = (string)GetValue( sData );
                
            else if( StringLeftICompare( "style6=", sData ) )
                style6 = (string)GetValue( sData );

            else if( StringLeftICompare( "style7=", sData ) )
                style7 = (string)GetValue( sData );
                
            else if( StringLeftICompare( "style8=", sData ) )
                style8 = (string)GetValue( sData );
                

            kCurrentDataRequest = llGetNotecardLine( sSettingsNotecard, ++iNoteCardLine );
        }
        else
        {
            iNotecardIndex++;
            if( iNotecardIndex < llGetInventoryNumber( INVENTORY_NOTECARD ) )
            {
                sSettingsNotecard = llGetInventoryName( INVENTORY_NOTECARD, iNotecardIndex );

                iNoteCardLine = 0;
                llGetNotecardLine( sSettingsNotecard, iNoteCardLine );
            }
            else
            {
                state run_object;
            }
        }
    }
}


// This is where your actual code would go
state run_object
{
    state_entry()
    {
        llMessageLinked(LINK_SET,1,"STYLE1 " + style1,NULL_KEY);
        llMessageLinked(LINK_SET,1,"STYLE2 " + style2,NULL_KEY);
        llMessageLinked(LINK_SET,1,"STYLE3 " + style3,NULL_KEY);
        llMessageLinked(LINK_SET,1,"STYLE4 " + style4,NULL_KEY);
        llMessageLinked(LINK_SET,1,"STYLE5 " + style5,NULL_KEY);
        llMessageLinked(LINK_SET,1,"STYLE6 " + style6,NULL_KEY);
        llMessageLinked(LINK_SET,1,"STYLE7 " + style6,NULL_KEY);
        llMessageLinked(LINK_SET,1,"STYLE8 " + style8,NULL_KEY);
        
        
        llOwnerSay("Done loading.");
    }
    changed(integer kind)
    {
        if(kind & CHANGED_INVENTORY)
        {
            llResetScript();
        }
    }
}