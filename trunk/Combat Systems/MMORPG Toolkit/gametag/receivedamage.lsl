// The ReceiveDmg module is responsible for receiving and processing damage dealt by other avatars or by monsters
// attacking the player
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
//   ReceiveDmg is responsible for:
//     - communicating with shield/protection objects to determine and instantiate current protection values
//     - receiving attacks, via the SecureComms module, and applying them to the Avatar
//     - enforcement of Death Condition
//
// Parameters:
//   ChannelShield   - make sure this is the same as what is on your shield modules
//   DeathTime       - length of time you will be dead for when you die
//
// Public interface:
//
//   Methods:
//
//     Attack methods:
//       llLinkedMessage( "RECEIVEDSECURECOM-=-ATTACK-=-<Target key>-=-<AttackType>-=-<AttackVector>-=-<Power>" );
//          This is an attack message, normally received via the SecureComms modulem from an attacking monster or avatar
//
//     Shield commmunication methods;
//       llWhisper( "PROTECTIONRESPONSE-=-<ShieldName>-=-<AC>-=-<MR>-=-<ProjArmour>" );
//          This is a shield response message detailed its AC, MR and Projectile Armour
//       llWhisper( "INVCHANGE" );
//          Shields and protection items send this as they are attached or detached
//
//     Stats update:
//        llLinkedMessage( "STATUPDATE-=-Life-=-<Current Life>" );
//
//   Events:
//
//       DeathCondition event:
//          llLinkedMessage( "DEATHCONDITIONON" );  // player is dead
//          llLinkedMessage( "DEATHCONDITIONOFF" );  // player is alive again
//
//       Damage instantiation:
//          llLinkedMessage( "RAISESTAT-=-Life-=-<minus Damage>" );  // update Life when attacked
//
//       Shield Communication:
//          llWhisper( "PROTECTIONPING" );  // Ask shields and protection equipment for current stats
//
//  (note <param> means "the value of parameter param")
//
//
//  Detail on attacks
//  =================
//
//  Currently processes the following attack types:
//     AttackType = "DirectDamage"
//     AttackVector =  {"MELEE" | "MAGIC" | "PROJECTILE | NOSAVE"}  (any of these values)
//
//  Power is modulated according to current protection values (AC, MR etc) according to 
// the AttackVector.  AC protects against Melee, MR protects against Magic, and Projectile protects against projectiles
//  
//  Damage = ( Power * 100 ) / ( 100 + <protectionvalue> )
//
// NOSAVE means no protection attributes applied.  You can use this to make a heal spell for example
// (heal = DirectDamage, NOSAVE, and a negative AttackPower)
//

integer ChannelShield = 5;
integer ChannelDead = 7;

integer DeathTime = 10;

integer AC = 0;
integer MR = 0;
integer ProjArmour = 0;

integer NewAC = 0;
integer NewMR = 0;
integer NewProjArmour = 0;

integer PingInProgress = FALSE;
integer PingSent = 0;
integer RedoPing = FALSE;

key OurKey = "";
integer bIsAvatar = FALSE;
integer bGotAnimPerms = FALSE;
integer bDeathConditionOn = FALSE;
integer TimeDied = 0;

TellPlayer( string Message )
{
    llWhisper( 0, Message );
}

Debug( string message )
{
    llWhisper( 0, llGetScriptName() + ": " + message );
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

GetPermsIfNeeded()
{
    bGotAnimPerms = FALSE;
    if( llGetAttached() == 0 )
    {
        bIsAvatar = FALSE;
    }
    else
    {
        bIsAvatar = TRUE;
    }    
    if( bIsAvatar )
    {
        llRequestPermissions( llGetOwner(), PERMISSION_TRIGGER_ANIMATION );
    }
}

PingProtection()
{
//    Debug( "pingproection function" );
   if( bIsAvatar )
   {
    if( !PingInProgress )
    {
  //      Debug( "no ping in progress" );
        PingSent = (integer)llGetWallclock();
        NewAC = 0;
        NewMR = 0;
        NewProjArmour = 0;
        llWhisper( ChannelShield, "PROTECTIONPING" );
        PingInProgress = TRUE;
    }
    else
    {
      //  Debug ("setting redo ping flag" );
        RedoPing = TRUE;
    }
}
}

ReduceStat( string StatName, integer Amount )
{
    llMessageLinked( LINK_SET, 0, "RAISESTAT-=-" + StatName + "-=-" + (string)(-Amount), "" );
}

SetStat( string StatName, integer Value )
{
    llMessageLinked( LINK_SET, 0, "SETSTAT-=-" + StatName + "-=-" + (string)Value, "" );
}

ProcessDirectDamage( string AttackVector, integer Power )
{
   // Debug( "dd received" );
    integer Damage;
    if( AttackVector == "MELEE" )
    {
        Damage = ( Power * 100 ) / ( 100 + AC );
    }
    else if( AttackVector == "MAGIC" )
    {
        Damage = ( Power * 100 ) / ( 100 + MR );
    }
    else if( AttackVector == "PROJECTILE" )
    {
        Damage = ( Power * 100 ) / ( 100 + ProjArmour );
    }
    else if( AttackVector == "NOSAVE" )
    {
       // Debug( "no save received" );
        Damage = Power;
    }
    ReduceStat( "Life", Damage );
}

ProcessAttack( string AttackType, string AttackVector, integer Power )
{
    if( AttackType == "DirectDamage" )
    {
        ProcessDirectDamage( AttackVector, Power );
    }
    else if( AttackType == "ManaDamage" )
    {
    }else if( AttackType == "IncreaseMoveSpeed" )
    {
    }else if( AttackType == "IncreaseAttackSpeed" )
    {
    }else if( AttackType == "IncreaseAttackRange" )
    {
    }
}

StatsPing()
{
    llMessageLinked( LINK_SET, 0, "PINGSTATS", "" );
}

Init()
{
        GetKey();
        GetPermsIfNeeded();
        StatsPing();
        RedoPing = FALSE;
        PingProtection();
}

TellPlayerProtectionStats()
{
    llWhisper( 0, "Protection stats: AC:" + (string)AC + " MR:" + (string)MR + " ProjArmour:" + (string)ProjArmour );
}

EnforceDeathCondition()
{
   llShout( ChannelDead, (string)OurKey );
    if( bIsAvatar )
    {
                   TellPlayer( "You are dead.  Please wait...");
                   // llShout( Channel, "KILLED"  +"-=-" + (string)llFrand(1000.0) + "-=-" + (string)Attackerid + "-=-" + (string)Playerid );
                   
                   llMessageLinked( LINK_SET, 0, "DEATHCONDITIONON", "" );
                   if( bGotAnimPerms )
                   {
                      llStartAnimation( "dead" );
                    }
                   llMoveToTarget( llGetPos(), 0.2 );                   
                   
                   TimeDied = (integer)llGetWallclock();
                   bDeathConditionOn = TRUE;
    }
    else
    {
           llMoveToTarget( llGetPos(), 0.2 );                   
           TimeDied = (integer)llGetWallclock();
           bDeathConditionOn = TRUE;
           llSleep( DeathTime );
           llDie();
    }
}

default
{
    state_entry()
    {
        Debug( "Compile complete" );
        llSetTimerEvent( 3.0 );
        Init();
        llListen( 0, "","","" );
        llListen( ChannelShield, "", "","" );
    }
    on_rez( integer param )
    {
        Init();
    }
    listen( integer channel, string name, key id, string message )
    {
        if( bIsAvatar )
        {
        if( channel == ChannelShield )
        {
        list Arguments;
        Arguments = llParseString2List( message, ["-=-"], [] );
        
        string Command;
        Command = llList2String( Arguments, 0 );
                    
        if( Command == "PROTECTIONRESPONSE" )
        {
            NewAC = NewAC + (integer)llList2String( Arguments, 2 );
            NewMR = NewMR + (integer)llList2String( Arguments, 3 );
            NewProjArmour = NewProjArmour + (integer)llList2String( Arguments, 4 );
        }
        else if( Command == "INVCHANGE" )
        {
            PingProtection();
        }
        }
        else if( channel == 0 && bIsAvatar )
        {
            if( llToLower(message) == "stats" )
            {
                if( id == llGetOwner() )
                {
                    TellPlayerProtectionStats();
                }
            }
        }
       }
    }
    timer()
    {
        if( PingInProgress )
        {
            if( llAbs( (integer)llGetWallclock() - PingSent ) >= 5 )
            {
                AC = NewAC;
                MR = NewMR;
                ProjArmour = NewProjArmour;
                PingInProgress = 0;
                if( RedoPing )
                {
                    RedoPing = FALSE;
                    PingProtection();
                }
            }
        }
        else if( llAbs( (integer)llGetWallclock() - PingSent ) >= 60 )
        {
                    PingProtection();
        }
        
        if( bDeathConditionOn )
        {
            if( llAbs((integer)llGetWallclock() - TimeDied ) > DeathTime )
            {
                   SetStat( "Life", 100 );    
                   llMessageLinked( LINK_SET, 0, "DEATHCONDITIONOFF", "" );
                   if( bGotAnimPerms )
                   {
                      llStopAnimation("dead");
                    }
                   llStopMoveToTarget();
                   bDeathConditionOn = FALSE;
                   
                   TellPlayer( "Ressurection completed" );
                   // llShout( Channel, "RESURRECTED-=-" + (string)llFrand(1000.0) +"-=-" + (string)Playerid +"-=-" ) ;
                   
           }
           else
           {
               llShout( ChannelDead, (string)OurKey );
            }
        }
    }
    link_message( integer sendernum, integer num, string message, key id )
    {
        list Arguments;
        Arguments = llParseString2List( message, ["-=-"], [] );
        
        string Command;
        Command = llList2String( Arguments, 0 );
        
        //Debug( "link message " + message + " " + Command );
        if( Command == "RECEIVEDSECURECOM" )
        {
            if( llList2String( Arguments, 1 ) == "ATTACK" )
            {
                if( ! bDeathConditionOn )
                {
            key Target;
            Target = (key)llList2String( Arguments, 2 );
              // Debug( (string)Target + " " + (string)OurKey );
               if( Target == OurKey )
               {
            string AttackType;
            string AttackVector;
            integer Power;
            
            AttackType = llList2String( Arguments, 3 );
            AttackVector = llList2String( Arguments, 4 );
            Power = (integer)llList2String( Arguments, 5 );
                    ProcessAttack( AttackType, AttackVector, Power );
                }
               }
            }
        }
        else if( Command == "STATUPDATE" )
        {
            if( llList2String( Arguments, 1 ) == "Life" )
            {
                if( (integer)llList2String( Arguments, 2 ) <= 0 )
                {
                    if( !bDeathConditionOn )
                    {
                       EnforceDeathCondition();
                    }
                }
            }
        }
    }
    run_time_permissions( integer perms )
    {
        bGotAnimPerms = TRUE;
    }
}

