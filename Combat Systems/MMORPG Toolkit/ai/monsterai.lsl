// Monster AI module - drives monsters
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
// Add this to monsters to make them attack nearby avatars. 
//
// Monsters will need to be equiped with an InternalWeapon module to be able to attack. 

integer ChannelDeadPeople = 7;

float IdealSpeed = 5;
float Mass = 8;
float StrikeDistance=1.8;
float CoolDown = 1.0;

float IdealAttackDistance = 1.5;

//integer RotDisabled = FALSE;
integer TranslateDisabled = FALSE;
integer WorldState = TRUE;
integer Initialized = FALSE;
integer AttackDisabled = FALSE;

float LastTimeWorldOn;
float LastAttack = 0;
string LastTarget = "";

list DeadPeople = [];
list NewDeadPeople = [];

Debug( string message )
{
    llWhisper( 0, llGetScriptName() + ": " + message );
}

Attack( key Target )
{
    llMessageLinked( LINK_SET, 0, "INTERNALWEAPON-=-SWORD-=-ATTACK-=-" + (string)Target, "" );
}

SetWorldOn()
{
    if( !Initialized || !WorldState )
    {
    Debug("Activating");
    WorldState = TRUE;
    Initialized = TRUE;
    LastTimeWorldOn = llGetTimeOfDay();

        llSetStatus(STATUS_PHYSICS,FALSE);
        llSetRot(ZERO_ROTATION);
        llSetStatus(STATUS_PHYSICS,TRUE);

llSetStatus(STATUS_ROTATE_X, FALSE);
llSetStatus(STATUS_ROTATE_Y, FALSE);
llSetStatus(STATUS_ROTATE_Z, FALSE);

        llSetRot(ZERO_ROTATION);

        LastTarget = "";    
        llSetTimerEvent(5.0);

       llSetBuoyancy(1.0);
       llSetHoverHeight(2.0,FALSE,0.2);

       llSensorRemove();
       llSensorRepeat("","",AGENT,15,PI,1.0);
    }
}

TurnTowardsTarget( vector NormalizedVectorToTarget )
{
                    vector EulerRot;
                    rotation RotBetweenWorldAndTarget;
                    RotBetweenWorldAndTarget = llRotBetween( <1,0,0>, NormalizedVectorToTarget );
                    //Debug( (string)RotBetweenWorldAndTarget );
                    rotation RotToGoTo;
                    RotToGoTo = RotBetweenWorldAndTarget;
                    //Debug( (string)llRot2Fwd(<0,0,0,1> ));
                    llSetStatus(STATUS_PHYSICS, FALSE );
                    llSetRot( llRotBetween( <1,0,0>, NormalizedVectorToTarget ) );
                    llSetStatus(STATUS_PHYSICS, TRUE );
                    
                    RotToGoTo = llEuler2Rot(<0,0,1> );
                    llRotLookAt( RotToGoTo, llGetMass() * 2, llGetMass() / 5 );
}
                
Init()
{
    Mass = llGetMass();
    DeadPeople = [];
    NewDeadPeople = [];
    SetWorldOn();
}

default
{
    state_entry()
    {
        Debug( "Compile complete" );
        Init();
        llListen( ChannelDeadPeople, "","","");
        llSetTimerEvent( 10.0);
    }
    on_rez(integer start_param)
    {
        Init();
    }
    sensor(integer num_detected)
    {
        //Debug("Sensor event");

    integer i;
    integer TargetNum = 0;
    integer bTargetFound = FALSE;
    list SearchList;
       for( i = 0; i< num_detected && ! bTargetFound; i++ )
       {
           if( llListFindList( DeadPeople, [ (string)llDetectedKey(i) ])  == -1 )
           {
               bTargetFound = TRUE;
               TargetNum = i;
            }
        }

if( bTargetFound )
{
        vector VectorToTarget;
        VectorToTarget = llDetectedPos(TargetNum) - llGetPos();
        VectorToTarget.z = 0;
        
            vector NormalizedVectorToTarget;
                NormalizedVectorToTarget = llVecNorm(VectorToTarget);

        //Debug( "Detectedname: " + llDetectedName(0) );

        TurnTowardsTarget( NormalizedVectorToTarget );

        if( WorldState ) // world on
        {
           if( LastAttack < llGetTimeOfDay() - CoolDown &&
              llVecMag(VectorToTarget) <StrikeDistance)
            {
            //llSay(0, "Chomp!");
               LastAttack = llGetTimeOfDay();
               if( !AttackDisabled )
               {
                  Attack( llDetectedKey(TargetNum) );
                }
            }
            else
            {    
                 if( llVecMag(VectorToTarget) - IdealAttackDistance > IdealSpeed )
                 {
                   //  Debug( "far from target" );
                     vector NextStep;
                     NextStep = llGetPos() + NormalizedVectorToTarget * IdealSpeed;
                     if( !TranslateDisabled )
                     {
                       llMoveToTarget( NextStep, 1.0);
                    }
            }
                else
                {
                     if( !TranslateDisabled )
                     {
                    // Debug( "near target" );
                    llMoveToTarget( llGetPos() + (llVecMag(VectorToTarget) - IdealAttackDistance ) * NormalizedVectorToTarget , 1.0);
                     }
                }
            }
        }
    }
    }
    listen( integer channel, string name, key id, string message )
    {
        list SearchList;
        SearchList = [ message ];
        if( llListFindList( NewDeadPeople, SearchList ) == -1 )
        {
            //Debug( "Adding " + message + " to new dead list" );
            NewDeadPeople = NewDeadPeople + SearchList;
        }
        if( llListFindList( DeadPeople, SearchList ) == -1 )
        {
            //Debug( "Adding " + message + " to dead list" );
            DeadPeople = DeadPeople + SearchList;
        }
    }
    timer()
    {
        DeadPeople = NewDeadPeople;
        NewDeadPeople = [];
    }
}

