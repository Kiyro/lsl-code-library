// The Weapon module is responsible for responding to player commands to attack another player or monster
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
// Just slot this module into something sword, batton, wand or stave-like and wear it, or give it out to players to wear, or sell it
// Weapons can be melee, or magical, or projectile, or just about anything you can imagine!!!!
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

string AttackType = "DirectDamage";
string AttackVector = "MELEE";
integer AttackPower = 20;
float CoolDown = 0.5;

string PlayerName;
key Playerid;

float LastAttack = 0;
integer have_permissions = FALSE;
integer Message2displayed = FALSE;

TellPlayer( string Message )
{
    llWhisper(0,PlayerName + ", " + Message );
}

TellOwner( string Message )
{
   // llInstantMessage( Playerid, Message );
}

GenericInit()
{
        Playerid = llGetOwner();
        PlayerName = llKey2Name( Playerid );
        PlayerName = llGetSubString( PlayerName, 0, llSubStringIndex( PlayerName, " ") );

        TellPlayer( "Switch to mouselook to attack!" );
            llRequestPermissions(llGetOwner(),  
                PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS);   
        llPreloadSound( "swordhit" );
        llPreloadSound( "swing1" );        

        Message2displayed = FALSE;
        llSetTimerEvent(5.0);
}    

default
{
    state_entry()
    {
        llListen( ChannelWpn, "","","" );
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
               llSensor("","",ACTIVE | AGENT,2.0,PI/4);
            llStartAnimation("sword_strike_R");
            llPlaySound("swing1",1.0 );
        }
    }
    }
    
    sensor(integer num_detected)
    {
integer TargetFound = FALSE;
key Targetid;
string TargetName;

        TargetFound = FALSE;

        integer i;
        i = 0;
        //TellPlayer( "sense event..." );
        while( TargetFound == FALSE && i < num_detected )
        {
            //TellPlayer( llDetectedName(i) + " " + (string)llDetectedType(i) + " " + (string)SCRIPTED);
            if( ( ( llDetectedType(i) & SCRIPTED ) == SCRIPTED ) || ( ( llDetectedType(i) & AGENT ) == AGENT ) )
            {
                //TellPlayer( "target found: " + llDetectedName(i) );
                TargetFound = TRUE;
                Targetid = llDetectedKey(i);
                TargetName = llDetectedName(i);
            }
            i++;
        }
        
        if( TargetFound )
        {
            llWhisper( ChannelWpn, "ATTACK" + "-=-" + (string)Playerid + "-=-" + (string)Targetid + "-=-" + AttackType + "-=-" + AttackVector + "-=-" + (string)AttackPower + "-=-" + (string)CoolDown );
        }
    }

    listen( integer channel, string name, key id, string message )
    {
        if( message == "HITSUCCESS-=-" + (string)llGetKey() )
        {
               llPlaySound( "swordhit", 1.0);
         }
    }
}

