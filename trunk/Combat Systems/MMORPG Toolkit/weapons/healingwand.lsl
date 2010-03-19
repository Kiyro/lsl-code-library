// The HealingSpell module allows you to heal others
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
// Just slot this healing wand module into something batton, wand or stave-like and wear it, or give it out to players to wear, or sell it
//
// To use, type "heal " and the first letters of the target, eg "heal azelda"
//
//  Players will need in addition:
//    - to be wearing a CombatSystems GRI object (eg appropriately scripting bracelet)
//

integer ChannelWpn = 4;

string AttackType = "DirectDamage";
string AttackVector = "NOSAVE";
integer AttackPower = -30;
float CoolDown = 10.0;
integer MaxSpellRadius = 15;

string PlayerName;
key Playerid;

float LastAttack = 0;
//integer bWeaponStillWarm = FALSE;
integer have_permissions = FALSE;
integer Message2displayed = FALSE;
string gsTargetPrefix = "";

integer bArmed = FALSE;

vector GREEN = <0,4,0>;
vector RED = <4,0,0>;
vector ORANGE = <4,0.5,0>;
vector YELLOW = <4,4,0>;
vector BLUE = <0,0,4>;
vector CYAN = <0,0.5,1>;

SetText( string text, vector color )
{
    llSetText( text, color,1.0 );
}

TellPlayer( string Message )
{
    llWhisper(0,PlayerName + ", " + Message );
}

Debug( string message )
{
    llWhisper( 0, llGetScriptName() + ": " + message );
}

TellOwner( string Message )
{
   // llInstantMessage( Playerid, Message );
}

DoHealingParticleEffect( key Targetid )
{
            llParticleSystem([
                  PSYS_PART_FLAGS, PSYS_PART_TARGET_POS_MASK,
                  PSYS_PART_START_COLOR, CYAN,
                  PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                  PSYS_SRC_MAX_AGE, 3.0,
                  PSYS_SRC_TARGET_KEY, Targetid,
                  PSYS_SRC_BURST_SPEED_MIN, 10.0,
                  PSYS_SRC_BURST_PART_COUNT,5
             ]);}

GenericInit()
{
    if( llGetAttached() != 0 )
    {
        bArmed = TRUE;
    }
    else
    {
        bArmed = FALSE;
    }
        Playerid = llGetOwner();
        PlayerName = llKey2Name( Playerid );
        PlayerName = llGetSubString( PlayerName, 0, llSubStringIndex( PlayerName, " ") );

        TellPlayer( "Type 'heal <target>' to heal" );
        TellPlayer( "eg 'heal azelda" );
        TellPlayer( "You only need to type the first few letters of the target name" );
//            llRequestPermissions(llGetOwner(),  
//                PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS);   
      //  llPreloadSound( "swordhit" );
      //  llPreloadSound( "swing1" );        

        Message2displayed = FALSE;
        llSetTimerEvent(1.0);
}    

default
{
    state_entry()
    {
        llListen( ChannelWpn, "","","" );
        GenericInit();
        llListen( 0, "","","" );
    }
    on_rez(integer startparam)
    {
        GenericInit();
    }
    listen( integer channel, string name, key id, string message )
    {
        if( id ==  Playerid )
        {
           // Debug( "[" +  llToLower( llGetSubString( message, 0, llStringLength( "heal" ) - 1 ) ) + "]");
            if( llToLower( llGetSubString( message, 0, llStringLength( "heal" ) - 1 ) ) == "heal" )
        {
         //   Debug( "validating..." );
         if (bArmed)
         {
            if(  LastAttack < llGetTimeOfDay() - CoolDown  )
            {
                if( (llGetAgentInfo(llGetOwner()) & AGENT_FLYING) == 0 )
                {
                LastAttack = llGetTimeOfDay();
            gsTargetPrefix = llToLower( llGetSubString( message, llStringLength( "heal" ) + 1 , 1000));
          //  Debug( "[" + gsTargetPrefix + "]" );
            llSensor( "","", ACTIVE|AGENT, MaxSpellRadius, PI );
        }
        else
        {
            llWhisper( 0, PlayerName + ", you cannot launch a spell whilst flying!" );
        }
            }
            else
            {
                llWhisper( 0, "You must wait for spell to recharge, " + PlayerName );
            }
        }
        else
        {
           llWhisper( 0, "You must be wearing the spell as an attachment, " + PlayerName );
        }
        }
    }
    }

    timer()
    {
//       llSay(0, "Use me wisely, " + PlayerName + "!");
//       llSetTimerEvent(.0);
        Message2displayed = TRUE;       
        if(  llAbs((integer)(llGetTimeOfDay() - LastAttack)) >  CoolDown )
        {
            SetText( "Spell Ready", GREEN );
        }
        else
        {
            SetText( "Spell Recharging...", ORANGE );
        }
    }
   
    attach(key attachedAgent)
    {
        if (attachedAgent != NULL_KEY)
        {
        Playerid = llGetOwner();
        bArmed = TRUE;
        }
        else
        {
        bArmed = FALSE;
        }
    }

    sensor(integer num_detected)
    {
integer TargetFound = FALSE;
key Targetid;
string TargetName;

        TargetFound = FALSE;
        string SampleTargetPrefix;

        integer i;
        i = 0;
        //TellPlayer( "sense event..." );
        while( TargetFound == FALSE && i < num_detected )
        {
            //TellPlayer( llDetectedName(i) + " " + (string)llDetectedType(i) + " " + (string)SCRIPTED);
//            if( ( ( llDetectedType(i) & SCRIPTED ) == SCRIPTED ) || ( ( llDetectedType(i) & AGENT ) == AGENT ) )
  //          {
      SampleTargetPrefix = llToLower( llGetSubString( llDetectedName(i), 0, llStringLength( gsTargetPrefix ) - 1  ) );
//Debug( SampleTargetPrefix );
           if( SampleTargetPrefix ==gsTargetPrefix )
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
             DoHealingParticleEffect( Targetid );
           // llSleep(1.0);
           // llParticleSystem([]);
        }
    }
}

