// The Shield module is used to create shields and protection equipment that players can wear
// Copyright (C) Hugh Perkins 2003
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
// Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
// You can find the licence also on the web at: 
// http://www.opensource.org/licenses/gpl-license.php
// 
// You will need the SecondLife runtime to use this module www.secondlife.com
//
// Just slot this module into something shield-like and wear it, or give it out to players to wear, or sell it
//
//  Players will need in addition:
//    - to be wearing a CombatSystems GRI object (eg appropriately scripting bracelet)
//    - a weapon object / magical stave / wand - make this using the Weapons module
//    - other players to attack, or monsters
//
// Roles and responsibilities:
//   Shield is responsible for:
//     - telling the CombatSystems GRI (CS GRI) its protection ratings (AC, MR, Projectile Armour)
//     - letting the CS GRI know when it is attached or detached
//
// Parameters:
//   ChannelShield   - make sure this is the same as what is on your CS GRI modules
//   AC   - Resistance to melee damage of the shield
//   MR   - Resistance to magic damage
//   ProjArmour   - Resistance to projectile attacks
//
// Public interface:
//
//   Methods:
//
//       Shield Communication:
//          llWhisper( "PROTECTIONPING" );  // CS GRI sends this to ask shields to send their protection stats
//
//   Events:
//
//     Shield commmunication methods;
//       llWhisper( "PROTECTIONRESPONSE-=-<ShieldName>-=-<AC>-=-<MR>-=-<ProjArmour>" );
//          Shield lets CS GRI know what it is called, and its protection statistics
//       llWhisper( "INVCHANGE" );
//          Shield sends this when attached or detached
//
//  (note <param> means "the value of parameter param")
//

integer ChannelShield = 5;

integer MR = 0;
integer AC = 10;
integer ProjArmour = 5;

SendInvChangedMessage()
{
    llWhisper( ChannelShield, "INVCHANGE" );
}

default
{
    state_entry()
    {
        //llListen( ChannelShield, llKey2Name( llGetOwner() ), llGetOwner(), "" );
        llListen( ChannelShield, "", "", "" );
        SendInvChangedMessage();
    }
    on_rez( integer param )
    {
    }
    attach( key id )
    {
        // this covers both attach and detach
        SendInvChangedMessage();
    }
    listen( integer channel, string name, key id, string message )
    {
        if( message == "PROTECTIONPING" )
        {
            llWhisper( ChannelShield, "PROTECTIONRESPONSE-=-" + llGetObjectName() + "-=-" + (string)AC + "-=-" + (string)MR + "-=-" + (string)ProjArmour );
        }
    }
}
// The Shield module is used to create shields and protection equipment that players can wear
//
// Just slot it into something shield-like and wear it, or give it out to players to wear, or sell it
//
//  Players will need in addition:
//    - to be wearing a CombatSystems GRI object (eg appropriately scripting bracelet)
//    - a weapon object / magical stave / wand - make this using the Weapons module
//    - other players to attack, or monsters
//
// Roles and responsibilities:
//   Shield is responsible for:
//     - telling the CombatSystems GRI (CS GRI) its protection ratings (AC, MR, Projectile Armour)
//     - letting the CS GRI know when it is attached or detached
//
// Parameters:
//   ChannelShield   - make sure this is the same as what is on your CS GRI modules
//   AC   - Resistance to melee damage of the shield
//   MR   - Resistance to magic damage
//   ProjArmour   - Resistance to projectile attacks
//
// Public interface:
//
//   Methods:
//
//       Shield Communication:
//          llWhisper( "PROTECTIONPING" );  // CS GRI sends this to ask shields to send their protection stats
//
//   Events:
//
//     Shield commmunication methods;
//       llWhisper( "PROTECTIONRESPONSE-=-<ShieldName>-=-<AC>-=-<MR>-=-<ProjArmour>" );
//          Shield lets CS GRI know what it is called, and its protection statistics
//       llWhisper( "INVCHANGE" );
//          Shield sends this when attached or detached
//
//  (note <param> means "the value of parameter param")
//

integer ChannelShield = 5;

integer MR = 0;
integer AC = 10;
integer ProjArmour = 5;

SendInvChangedMessage()
{
    llWhisper( ChannelShield, "INVCHANGE" );
}

default
{
    state_entry()
    {
        //llListen( ChannelShield, llKey2Name( llGetOwner() ), llGetOwner(), "" );
        llListen( ChannelShield, "", "", "" );
        SendInvChangedMessage();
    }
    on_rez( integer param )
    {
    }
    attach( key id )
    {
        // this covers both attach and detach
        SendInvChangedMessage();
    }
    listen( integer channel, string name, key id, string message )
    {
        if( message == "PROTECTIONPING" )
        {
            llWhisper( ChannelShield, "PROTECTIONRESPONSE-=-" + llGetObjectName() + "-=-" + (string)AC + "-=-" + (string)MR + "-=-" + (string)ProjArmour );
        }
    }
}

