// Grenade module
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
// Create a grenade object with this, that you can load this into a grenade launcher attachment
//

integer ChannelProjectile = 6;

integer BlastRadius = 5;
integer GroundZeroDamage = 80;

integer bArmed = FALSE;

Debug( string message )
{
    llWhisper( 0, llGetScriptName() + ": " + message );
}

Explode()
{
   llSensor( "","", ACTIVE | AGENT, BlastRadius, PI );
}

default
{
    state_entry()
    {
        Debug( "Compile complete" );
    }
    on_rez(integer param)
    {
        llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
        //llSetBuoyancy(1.0);
        if (param)
        {
            bArmed = TRUE;
        }   
    }
    sensor( integer num_detected )
    {
        integer i;
        for( i = 0; i < num_detected; i++ )
        {
            integer Damage;
            Damage = ( BlastRadius - (integer)llVecMag( llDetectedPos(i) - llGetPos() ) ) * GroundZeroDamage / BlastRadius;
           // Debug( (string)Targetid );
            llShout( ChannelProjectile, "AREATARGETSTRUCK-=-" + (string)llGetOwner() + "-=-" + (string)llDetectedKey(i) + "-=-" + (string)Damage );
        }
    }

    collision_start(integer total_number)
    {
        if (bArmed)
        {
            Explode();
            llSetTimerEvent(3.0);
        }
    }
    land_collision_start(vector pos)
    {
        if (bArmed)
        {
            Explode();
            llSetTimerEvent(3.0);
        }
    }
    timer()
    {
        llDie();
    }
}

