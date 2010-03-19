// The SendDmg module is responsible for sending damage to monsters or other players
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
// It forms part of the CombatSystems GRI and should be combined with the other CombatSystems GRI modules
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
//   SendDmg is responsible for:
//     - receiving and validating weapon commands
//     - modulation of attacks for current stats (eg attackRange, AttackSpeed )
//     - enforcement of death condition wrt attacking
//
// Parameters:
//   ChannelWpn   - make sure this is the same as what is on your weapon modules
//
// Public interface:
//
//   Methods:
//
//     DeathCondition:
//        llLinkedMessage( "DEATHCONDITIONON" )  // tell it attacking no longer allowed, player is dead
//        llLinkedMessage( "DEATHCONDITIONOFF" )  // tell it attacking allowed again, player is alive
//
//     Attack:
//        llShout( ChannelWpn, "ATTACK-=-<Target key>-=-<AttackType>-=-<AttackVector>-=-<Power>-=-<CoolDown>"
//            Swords send this to the SendDmg module when player has told them to attack someone
//
//     Stats update:
//        llLinkedMessage( "STATUPDATE-=-<StatName>-=-<Stat Value>" );  // to receive stats updates
//            This module caches AttackPower, AttackRange and AttackSpeed
//
//  Events:
// 
//      Attack:
//         llLinkedMessage( "SENDSECURECOM-=-ATTACK-=-<Target key>-=-<AttackType>-=-<AttackVector>-=-<Power>" );
//            SendDmg module sends this to other avatars/monsters, via the SecureComms module, to attack them
//
//  (note <param> means "the value of parameter param")
//
//
//  Detail on attacks
//  =================
//
//  Mostly, stuff is just passed through for now
//  We will enforce here CoolDown and modulate attacks for AttackSpeed, AttackRange and AttackPower
//

integer ChannelWpn = 4;

integer AttackPower = 100;
integer AttackSpeed = 100;
integer AttackRange = 100;

integer DeathConditionOn = FALSE;

key OurKey = "";

Debug( string message )
{
    llWhisper( 0, llGetScriptName() + ": " + message );
}

TellPlayer( string message )
{
    llWhisper( 0, message );
}

GetKey()
{
    if( llGetAttached() == 0 )
    {
        OurKey = llGetKey();
    }
    else
    {
        OurKey = llGetOwner();
    }
}

default
{
    state_entry()
    {
        GetKey();
        llWhisper( 0, llGetScriptName() + " Compile complete" );
        llListen( ChannelWpn, "", "", "" );
    }
    on_rez( integer param )
    {
        GetKey();
    }
    listen( integer channel, string name, key id, string message )
    {
        list Arguments;
        Arguments = llParseString2List( message, ["-=-"],[] );
        
        string SourceOwnerKey;
        SourceOwnerKey = llList2String( Arguments, 1 );        
        
        if( SourceOwnerKey == OurKey )
        {
        //TellPlayer( (string)SourceOwnerKey + " " + (string)PlayerKey );
        
        string Command;
        Command = llList2String( Arguments, 0 );
        //TellPlayer( Command );
        
        if( Command == "ATTACK" )
        {
            //TellPlayer( (string)DeathConditionOn );
            if( !DeathConditionOn )
            {
            //    Debug( "Checking for flying..." );
                if( (llGetAgentInfo( OurKey ) & AGENT_FLYING )== 0 )
                {
                Debug( "Attacking..." );
            key Target;
            string AttackType;
            string AttackVector;
            integer Power;
            float CoolDown;
            
            Target = llList2String( Arguments, 2 );
            AttackType = llList2String( Arguments, 3 );
            AttackVector = llList2String( Arguments, 4 );
            Power = (integer)llList2String( Arguments, 5 );
            CoolDown = (float)llList2String( Arguments, 6 );
            
            // Need to add stuff to handle AttackRange here...
            // Maybe Send Weapon range from weapon to SendDmg module over ChannelWpn?
            
            Power = ( Power * AttackPower )/ 100;
            CoolDown = ( CoolDown * 100 ) / AttackSpeed;
            llMessageLinked( LINK_SET, 0, "SENDSECURECOM-=-ATTACK-=-" + (string)Target + "-=-" + AttackType + "-=-" + AttackVector + "-=-" + (string)Power, "" );
             llShout( ChannelWpn, "HITSUCCESS-=-" + (string)id );
                }
                else
                {
                    llWhisper( 0, "You cannot attack while flying" );
                }
            }
        }
    }
    }
    link_message( integer sendernum, integer num, string message, key id )
    {
        list Arguments;
        Arguments = llParseString2List( message, ["-=-"],[] );
        
        string Command;
        Command = llList2String( Arguments, 0 );
        
        if( Command == "STATUPDATE" )
        {
            string StatName;
            integer StatValue;
            StatName = llList2String( Arguments, 1 );
            StatValue = (integer)llList2String( Arguments, 2 );
    if( StatName == "AttackSpeed" )
    {
        AttackSpeed = StatValue;
    }
    else if( StatName == "AttackRange" )
    {
        AttackRange = StatValue;
    }
    else if( StatName == "AttackPower" )
    {
        AttackPower = StatValue;
    }
            
        }
        else if( Command == "DEATHCONDITIONON" )
        {
            DeathConditionOn = TRUE;
        }
        else if( Command == "DEATHCONDITIONOFF" )
        {
            DeathConditionOn = FALSE;
        }
        else if( Command == "SENDDMG" )
        {
        if( llList2String( Arguments, 1 ) == "ATTACK" )
        {
            //TellPlayer( (string)DeathConditionOn );
            if( !DeathConditionOn )
            {
            //    Debug( message );
            key Target;
            string AttackType;
            string AttackVector;
            integer Power;
            float CoolDown;
            
            Target = llList2String( Arguments, 3 );
            AttackType = llList2String( Arguments, 4 );
            AttackVector = llList2String( Arguments, 5 );
            Power = (integer)llList2String( Arguments, 6 );
            CoolDown = (float)llList2String( Arguments, 7 );
            
            // Need to add stuff to handle AttackRange here...
            // Maybe Send Weapon range from weapon to SendDmg module over ChannelWpn?
            
            Power = ( Power * AttackPower )/ 100;
            CoolDown = ( CoolDown * 100 ) / AttackSpeed;
            llMessageLinked( LINK_SET, 0, "SENDSECURECOM-=-ATTACK-=-" + (string)Target + "-=-" + AttackType + "-=-" + AttackVector + "-=-" + (string)Power, "" );
            }
        }
        }
    }
}

