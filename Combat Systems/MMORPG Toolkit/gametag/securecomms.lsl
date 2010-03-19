// The SecureComms module is responsible for communications between the CombatSystems GRI and other avatars/monsters
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
// This module forms part of the CombatSystems GRI and should be combined with the other CombatSystems GRI modules
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
//   SecureComms is responsible for:
//      - Receiving messages from GRI modules and passing them to other avatars/monsters
//      - Receivng messags from other avatars/monsters and passing them to GRI modules
//      - communications security and encryption (for now, we just use Channel number for this)
//
// Parameters:
//   ChannelInterActor   - channel number for communication with other GRIs / monsters
//
// Public interface:
//
//   Methods:
//
//       llLinkedMessage( "SENDSECURECOM-=-<message>" );
//          GRI modules send this to send <message> to other GRIs/monsters.
//       llShout( "<message>" );
//          Other GRI modules send this to send <message> to this GRI
//
//   Events:
//
//       llLinkedMessage( "RECEIVEDSECURECOM-=-<message>" );
//          Tell GRI modules about a message received from outside world
//       llShout( "<message>" );
//          Communicate an internally-sourced GRI message to the outside world
//
//  (note <param> means "the value of parameter param")
//

integer ChannelInterActor = 1;

Debug( string message )
{
    llWhisper( 0, llGetScriptName() + ": " + message );
}

default
{
    state_entry()
    {
        llWhisper(0, llGetScriptName() + " Compile complete");
        llListen( ChannelInterActor, "","","" );
    }
    
    listen( integer channel, string name, key id, string message )
    {
        llMessageLinked( LINK_SET, 0, "RECEIVEDSECURECOM-=-" + message, "" );
    }
    link_message( integer sendernum, integer num, string message, key id )
    {
        list Arguments;
        Arguments = llParseString2List( message, ["-=-"],[] );
     
        //Debug( message );
              
        string Command;
        Command = llList2String( Arguments, 0 );
        
        //Debug( Command );
        
        if( Command == "SENDSECURECOM" )
        {
            string MessageToSend;
            MessageToSend = llGetSubString( message, llStringLength( "SENDSECURECOM") ,1000);
            //Debug( (string)ChannelInterActor + " " + MessageToSend );
            llShout( ChannelInterActor, MessageToSend );
        }
    }
}

