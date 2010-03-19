// Internal melee weapon module, for use by monsters and AIs
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
// This is what monsters and robots use as a weapon. 
// 
// Just add it in along with the rest of the monster modules. 
// 
// You can change the values of damage and so on in the paramters at the top.

string WeaponName = "SWORD";

string AttackType = "DirectDamage";
string AttackVector = "MELEE";
integer AttackPower = 20;
float CoolDown = 0.5;

float LastAttack = 0;

Debug( string message )
{
    llWhisper( 0, llGetScriptName() + ": " + message );
}

ProcessAttackRequest()
{
   // Debug( "attack request received" );
            if(  LastAttack < llGetTimeOfDay() - CoolDown )
            {
                LastAttack = llGetTimeOfDay();
               // Debug( "Attacking..." );
               //llSensor("","",SCRIPTED | AGENT,2.0,PI/4);
               llSensor("","",ACTIVE | AGENT,2.0,PI/4);
               //llSensor("","",SCRIPTED,2.0,PI/4);
            //llStartAnimation("sword_strike_R");
            llPlaySound("swing1",1.0 );
        }
}

SendAttackCodes( key Targetid )
{
    llMessageLinked( LINK_SET, 0, "SENDDMG-=-ATTACK" + "-=-" + (string)llGetKey() + "-=-" + (string)Targetid + "-=-" + AttackType + "-=-" + AttackVector + "-=-" + (string)AttackPower + "-=-" + (string)CoolDown, "" );
}

default
{
    state_entry()
    {
        Debug( "Compile complete" );
    }
    sensor(integer num_detected)
    {
  //      integer TargetFound = FALSE;
        key ThisTargetid;
        integer SensorType;
//        string TargetName;

//        TargetFound = FALSE;

  //      integer i;
//        i = 0;
  //      Debug( "sense event..." );
//        while( TargetFound == FALSE && i < num_detected )
  //      {
//            Debug( llDetectedName(0) + " " + (string)llDetectedType(0) + " " + (string)SCRIPTED);
//            if( ( ( llDetectedType(i) & SCRIPTED ) == SCRIPTED ) || ( ( llDetectedType(i) & AGENT ) == AGENT ) )
  //          {
    //            Debug( "target found: " + llDetectedName(0) );
                //TargetFound = TRUE;
                ThisTargetid = llDetectedKey(0);
                //ThisTarget
                //TargetName = llDetectedName(i);
    //        }
      //      i++;
    //    }
        
//        if( TargetFound )
  //      {
            SendAttackCodes( ThisTargetid);
            llPlaySound( "swordhit", 1.0);
    //    }
    }
    link_message( integer sendernum, integer num, string message, key id )
    {
      //  Debug( message );
        list Arguments;
        Arguments = llParseString2List( message, ["-=-"],[] );
        
        string Command;
        Command = llList2String( Arguments, 0 );
        
      //  Debug( Command );
        
        if( Command == "INTERNALWEAPON" )
        {
      //  Debug( llList2String( Arguments, 1 ) );
            if( llList2String( Arguments, 1 ) == WeaponName )
            {
      //  Debug( llList2String( Arguments, 2 ) );
                if( llList2String( Arguments, 2 ) == "ATTACK" )
                {
                    ProcessAttackRequest();
                }
            }
        }
    }
}

