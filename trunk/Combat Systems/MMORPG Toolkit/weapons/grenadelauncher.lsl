// The Grenade Launcher module is responsible for responding to player commands to attack another player or monster
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
// This weapons module is optimized for grenade-style weapons.
//
//  Players will need in addition:
//    - to be wearing a CombatSystems GRI object (eg appropriately scripting bracelet)
//    - other players to attack, or monsters
//
//  Optional other items for plqyers:
//    - shield object
//
// Roles and responsibilities:
//   The Weapon module is responsible for:
//     - responding to player commands asking it to attack something
//     - definition of attack type, power and so on
//     - enforcement of charge time, recharge time, and charge limitations, as required by weapon designer
//
// Parameters:
//   ChannelWpn   - make sure this is the same as what is on the SendDmg module of your CS GRI
//
// Public interface:
//
//   Methods:
//     Player controls weapon via attachment interface.  No explicit methods
//
//  Events:
// 
//     Attack:
//        llWhisper( ChannelWpn, "ATTACK-=-<Target key>-=-<AttackType>-=-<AttackVector>-=-<Power>-=-<CoolDown>"
//            Swords send this to the SendDmg module to attack other avatars or monsters
//
//  (note <param> means "the value of parameter param")
//
//
//  Detail on attacks
//  =================
//
//  - AttackType, AttackVector and Power are defined by the CS GRI REceiveDmg module.  See ReceiveDmg module
//    documentation for more info
//  - Cooldown is used to enforce a delay between attacks with the weapon
//  - Currently Cooldown is enforced by the weapon, but this will be migrated to the SendDmg module, in order
//     to allow enforcement of the AttackSpeed stat
//

integer ChannelWpn = 4;
integer ChannelProjectile = 6;

string AttackType = "DirectDamage";
string AttackVector = "PROJECTILE";
float CoolDown = 0.5;
integer IdealProjectileSpeed = 8;

string ProjectileObjectName = "Grenade";

string PlayerName;
key Playerid;

float LastAttack = 0;
integer have_permissions = FALSE;
integer Message2displayed = FALSE;

float LauncherHeightOffset = 0.8;

TellPlayer( string Message )
{
    llWhisper(0,PlayerName + ", " + Message );
}

Debug( string message )
{
    llWhisper( 0, llGetScriptName() + ": " + message );
}

Fire()
{
   rotation AvatarRot;
   vector AvatarForwardVector;
   vector LauncherPos;
   vector ProjectileVelocity;
   
   AvatarRot = llGetRot();
   AvatarForwardVector = llRot2Fwd(AvatarRot);
   LauncherPos = llGetPos() + AvatarForwardVector;
   LauncherPos.z = LauncherPos.z + LauncherHeightOffset;    
   ProjectileVelocity = AvatarForwardVector * IdealProjectileSpeed;
   llRezObject(ProjectileObjectName, LauncherPos, ProjectileVelocity, AvatarRot, TRUE);
}

GenericInit()
{
    llReleaseControls();
        Playerid = llGetOwner();
        PlayerName = llKey2Name( Playerid );
        PlayerName = llGetSubString( PlayerName, 0, llSubStringIndex( PlayerName, " ") );

        TellPlayer( "Switch to mouselook to attack!" );
            llRequestPermissions(llGetOwner(),  
                PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS);   
//        llPreloadSound( "swordhit" );
        llPreloadSound( "shoot" );        

        Message2displayed = FALSE;
        llSetTimerEvent(5.0);
}    

default
{
    state_entry()
    {
        Debug( "Compile completed" );
        llListen( ChannelWpn, "","","" );
        llListen( ChannelProjectile, "","","" );
        GenericInit();
    }
    on_rez(integer startparam)
    {
        GenericInit();
    }

    timer()
    {
       llSay(0, "Use me wisely, " + PlayerName + "!");
       llSetTimerEvent(0.0);
        Message2displayed = TRUE;       
    }
    run_time_permissions(integer perms)
    {
        if(perms & (PERMISSION_TAKE_CONTROLS))
        {
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_UP | CONTROL_DOWN | CONTROL_ML_LBUTTON, TRUE, TRUE);
             have_permissions = TRUE;
        }
   }
   
    attach(key attachedAgent)
    {
        if (attachedAgent != NULL_KEY)
        {
        Playerid = llGetOwner();
            llRequestPermissions(Playerid,  
                PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS);   
        }
        else
        {
            if (have_permissions)
            {
                llReleaseControls();
                have_permissions = FALSE;
            }
        }
    }

       control(key name, integer levels, integer edges) 
    {
        if (  ((edges & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON)
            &&((levels & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) )
        {
            if(  LastAttack < llGetTimeOfDay() - CoolDown )
            {
                LastAttack = llGetTimeOfDay();
                Fire();
                llPlaySound("shoot",1.0 );
            }
        }
    }

    listen( integer channel, string name, key id, string message )
    {
        if( channel == ChannelProjectile )
        {
           // Debug( "Struck received" );
            list Arguments;
            Arguments = llParseString2List( message, ["-=-"], [] );
        
            string Command;
            Command = llList2String( Arguments, 0 );
            
            if( Command == "AREATARGETSTRUCK" )
            {
            
            key FirerId;
            FirerId = (key)llList2String( Arguments, 1 );
            
            if( FirerId == Playerid )
            {
        
            key Targetid;
            Targetid = (key)llList2String( Arguments, 2 );
            
            integer Damage;
            Damage = (integer)llList2String( Arguments, 3 );
            
            llWhisper( ChannelWpn, "ATTACK" + "-=-" + (string)Playerid + "-=-" + (string)Targetid + "-=-" + AttackType + "-=-" + AttackVector + "-=-" + (string)Damage + "-=-" + (string)CoolDown );
             }
             }
        }
    }
}

