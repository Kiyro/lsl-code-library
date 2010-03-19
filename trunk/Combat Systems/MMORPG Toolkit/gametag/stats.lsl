// The Stats module is responsible for storing stats for the Avatar, such as life, mana, and so on
// Copyright (c) Hugh Perkins 2003
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
//  more details.
//
// You should have received a copy of the GNU General Public License along
// with this program in the file licence.txt; if not, write to the
// Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-
1307 USA
// You can find the licence also on the web at:
// http://www.opensource.org/licenses/gpl-license.php
//
// You will need the SecondLife runtime to use this module www.secondlife.com
//
// It forms part of the CombatSystems GRI (CS GRI) and should be combined with the other CombatSystems GRI modules
// into something like a bracelet that all game participants will wear
//
//  You will need in addition:
//    - a weapon object / magical stave / wand - make this using the Weapons module
//    - other players to attack, or monsters
//
// The CombatSystems GRI modules are:
//   - ReceiveDmg
//   - SendDmg
//   - SecureComms
//   - Stats
//
// Roles and responsibilities:
//   Stats is responsible for:
//     - Storing current avatar stats
//     - responding to stat update messages ("SETSTAT", "RAISESTAT")
//     - Letting other CS GRI modules know when a stat has changed
//     - Displaying stats to user
//
// Parameters:
//   - no parameters, it learns everything from other modules
//   - you can set initial values for avatar statistics here if you want
//
// Public interface:
//
//   Methods:
//
//       Modify statistics:
//          llLinkedMessage( "RAISESTAT-=-<Stat Name>-=-<Amount to add to statistic>" );  // can be negative
//          llLinkedMessage( "SETSTAT-=-<Stat Name>-=-<New value for stat>" );  // negative numbers will be floored to zero
//          llLinkedMessage( "PINGSTATS" );  // asks stats module to send all known stats (in statupdate messages)
//
//   Events:
//
//     Stats update:
//        llLinkedMessage( "STATUPDATE-=-<Stat Name>-=-<New value for stat>" );  // let other CS GRI modules know a stat
//                                                       has changed
//
//  (note <param> means "the value of parameter param")
//

integer Life = 100;
integer AttackSpeed = 100; // percent of norm
integer MoveSpeed = 100; // percent of norm
integer Mana = 100;
integer AttackRange = 100; // percent of norm
integer AttackPower = 100; // percent of norm

integer LifeCap = 100; // hardcoded

integer bIsAvatar = FALSE;

vector GREEN = <0,4,0>;
vector RED = <4,0,0>;
vector ORANGE = <4,0.5,0>;
vector YELLOW = <4,4,0>;
vector BLUE = <0,0,4>;

Debug( string message )
{
    llWhisper( 0, llGetScriptName() + ": " + message );
}

CheckIfAvatar()
{
    if( llGetAttached() == 0 )
    {
        bIsAvatar = FALSE;
    }
    else
    {
        bIsAvatar = TRUE;
    }
}

SetText( string text, vector color )
{
    llSetText( text, color,1.0 );
}

ShowLife()
{
    string MessagePrefix = "";
    if( bIsAvatar )
    {
        MessagePrefix = "";
    }
    else
    {
        MessagePrefix = llGetObjectName() + "\n";
    }
    
    if( Life > 50 )
    {
       SetText( MessagePrefix + "Life: " + (string)Life, GREEN );
    }
    else if( Life > 10 )
    {
       SetText( MessagePrefix + "Life: " + (string)Life, ORANGE );
    }
    else if( Life > 0 )
    {
       SetText( MessagePrefix + "Life: " + (string)Life, RED );
    }
    else
    {
        if( bIsAvatar )
        {
           SetText("-- " + llKey2Name(llGetOwner() ) + "'s Corpse --", RED );
    }
    else
    {
           SetText( "-- " + llGetObjectName() + "'s Corpse --", RED );
        
    }
    }
}

SendStat( string StatName )
{
    if( StatName == "Life" )
    {
        llMessageLinked( LINK_SET, 0, "STATUPDATE-=-Life-=-" + (string)Life, "" );
    }
    else if( StatName == "AttackSpeed" )
    {
        llMessageLinked( LINK_SET, 0, "STATUPDATE-=-AttackSpeed-=-" + (string)AttackSpeed, "" );
    }
    else if( StatName == "MoveSpeed" )
    {
        llMessageLinked( LINK_SET, 0, "STATUPDATE-=-MoveSpeed-=-" + (string)MoveSpeed, "" );
    }
    else if( StatName == "Mana" )
    {
        llMessageLinked( LINK_SET, 0, "STATUPDATE-=-Mana-=-" + (string)Mana, "" );
    }
    else if( StatName == "AttackRange" )
    {
        llMessageLinked( LINK_SET, 0, "STATUPDATE-=-AttackRange-=-" + (string)AttackRange, "" );
    }    
    else if( StatName == "AttackPower" )
    {
        llMessageLinked( LINK_SET, 0, "STATUPDATE-=-AttackPower-=-" + (string)AttackPower, "" );
    }    
}

BroadcastStats()
{
    SendStat( "Life" );
    SendStat( "AttackSpeed" );
    SendStat( "MoveSpeed" );
    SendStat( "Mana" );
    SendStat( "AttackRange" );
}

integer GetStat( string StatName )
{
    if( StatName == "Life" )
    {
        return Life;
    }
    else if( StatName == "AttackSpeed" )
    {
        return AttackSpeed;
    }
    else if( StatName == "MoveSpeed" )
    {
        return MoveSpeed;
    }
    else if( StatName == "Mana" )
    {
        return Mana;
    }
    else if( StatName == "AttackRange" )
    {
        return AttackRange;
    }
    else if( StatName == "AttackPower" )
    {
        return AttackRange;
    }
    return 0;
}

SetStat( string StatName, integer StatValue )
{
    if( StatValue < 0 )
    {
        StatValue = 0;
    }
    
    if( StatName == "Life" )
    {
        if( StatValue > LifeCap )
        {
            StatValue = LifeCap;
        }
        Life = StatValue;
        ShowLife();
    }
    else if( StatName == "AttackSpeed" )
    {
        AttackSpeed = StatValue;
    }
    else if( StatName == "MoveSpeed" )
    {
        MoveSpeed = StatValue;
    }
    else if( StatName == "Mana" )
    {
        Mana = StatValue;
    }
    else if( StatName == "AttackRange" )
    {
        AttackRange = StatValue;
    }
    else if( StatName == "AttackPower" )
    {
        AttackPower = StatValue;
    }
    SendStat( StatName );
}

default
{
    state_entry()
    {
        Debug( "Compile completed" );
        CheckIfAvatar();
       ShowLife();
   }
   on_rez( integer param )
   {
        CheckIfAvatar();
       ShowLife();
    }
    link_message( integer sendernum, integer num, string message, key id )
    {
        list Arguments;
        Arguments = llParseString2List( message, ["-=-"], [] );
        
        string Command;
        Command = llList2String( Arguments, 0 );
        
        string StatName;
        StatName = llList2String( Arguments, 1 );
        
        integer StatValue;
        StatValue = (integer)llList2String( Arguments, 2 );
        
        integer CurrentStat;
        
        if( Command == "SETSTAT" )
        {
            SetStat( StatName, StatValue );
        }
        else if( Command == "RAISESTAT" )
        {
            CurrentStat = GetStat( StatName );
            SetStat( StatName, CurrentStat + StatValue );
        }
        else if( Command == "MINSTAT" )
        {
            // MinStat( StatName, StatValue );
        }
        else if( Command == "MAXSTAT" )
        {
            // MaxStat( StatName, StatValue );
        }
        else if( Command == "PINGSTATS" )
        {
            BroadcastStats();
        }
    }
}

