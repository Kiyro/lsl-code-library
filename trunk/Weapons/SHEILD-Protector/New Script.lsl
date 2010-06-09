integer TIME_STEPS = 5;
float   SPEED_THRESHOLD = 0.5;
string  SHIELD_TEXTURE = "PlayerShield";
string  TRANS_TEXTURE = "transparent";
string  HIT_SOUND = "ArmorHit2";

// Globals
integer giCurrentStep;
float   gfStepSize;
integer gbFading;

default
{
    state_entry()
    {
        llSetTexture( "transparent", ALL_SIDES );
        llSetTextureAnim( ANIM_ON | ROTATE | LOOP, ALL_SIDES, 0, 0, 0, TWO_PI, 20 );
//        llSetTextureAnim( FALSE, 0,0,0,0,0,0 );
        llSetAlpha( 1.0, ALL_SIDES );
        gfStepSize = (float)1 / (float)TIME_STEPS;
        gbFading = FALSE;
    }

    collision_start( integer num )
    {
        integer i;
        vector vVelocity;
        vector vCurPos = llGetPos();
        
        for ( i=0; i < num; i++ )
        {
            vVelocity = llDetectedVel(i);
            if ( llVecMag(vVelocity) > SPEED_THRESHOLD )
            {
                llSetForce(<0,0,0>, FALSE);
                llMoveToTarget(vCurPos, 0.1);
                llPushObject( llDetectedKey(i), -1.5 * vVelocity, <0,0,0>, FALSE );
                llTriggerSound( HIT_SOUND, 0.5 );
                gbFading = FALSE;
            }
        }
        llSetTimerEvent(0.1);
    }
    
    timer()
    {
        if ( FALSE == gbFading )
        {
            llSetTexture( SHIELD_TEXTURE, ALL_SIDES );
            gbFading = TRUE;
            giCurrentStep = TIME_STEPS;
        }
        
        llSetAlpha( gfStepSize * giCurrentStep--, ALL_SIDES );

        if ( giCurrentStep == 0 )
        {
            llSetTexture( TRANS_TEXTURE, ALL_SIDES );
            llSetAlpha( 1.0, ALL_SIDES );
            llSetTimerEvent(0.0);
            llStopMoveToTarget();
        }
    }
}
