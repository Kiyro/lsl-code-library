// Francis wuz here
//
// modded by FliperPA to cut down on lag by 1000% without cutting much performance
// also set to listen on alternate channel to stop server parsing everything wearer says in chat
// GREAT WORK FRANCIS! :-)
//
// MOD THE NEXT LINE TO CHOOSE WHICH CHANNEL TO RUN ON
integer LISTEN_CHANNEL = 63;
// Default notecard we read on script_entry
string defaultNoteCard = "*Default Anims";
//
// Don't ask me for tech support. I won't give it.
// Copyright (C) 2004 Francis Chung
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  U

// List of all the animation states
list animState = ["Sitting on Ground", "Sitting", "Striding", "Crouching", "CrouchWalking",
                  "Soft Landing", "Standing Up", "Falling Down", "Hovering Down", "Hovering Up",
                  "FlyingSlow", "Flying", "Hovering", "Jumping", "PreJumping", "Running",
                  "Turning Right", "Turning Left", "Walking", "Landing", "Standing" ];
                  
// Index of interesting animations
integer standIndex      = 20;
integer sittingIndex    = 1;
integer sitgroundIndex  = 0;
integer hoverIndex      = 12;
integer flyingIndex     = 11;
integer flyingslowIndex = 10;
integer hoverupIndex    = 9;
integer hoverdownIndex  = 8;
integer waterTreadIndex = 25;
integer swimmingIndex   = 26;
integer swimupIndex     = 27;
integer swimdownIndex   = 28;
integer standingupIndex = 6;

// list of animations that have a different value when underwater
list underwaterAnim = [ hoverIndex, flyingIndex, flyingslowIndex, hoverupIndex, hoverdownIndex ];

// corresponding list of animations that we override the overrider with when underwater
list underwaterOverride = [ waterTreadIndex, swimmingIndex, swimmingIndex, swimupIndex, swimdownIndex];

// list of animation states that we need to stop the default animations for
list stopAnimState = [ "Sitting", "Sitting on Ground" ];

// corresponding list of animations to stop when entering that state
list stopAnimName  = [ "sit", "sit_ground" ];

// Lines in the notecards where to grab animation names
// This list is indexed the same as list overrides
list lineNums = [ 45, // 0  Sitting on Ground
                  33, // 1  Sitting
                   1, // 2  Striding
                  17, // 3  Crouching
                   5, // 4  CrouchWalking
                  39, // 5  Soft Landing
                  41, // 6  Standing Up
                  37, // 7  Falling Down
                  19, // 8  Hovering Down
                  15, // 9  Hovering Up
                  43, // 10 FlyingSlow
                   7, // 11 Flying
                  31, // 12 Hovering
                  13, // 13 Jumping
                  35, // 14 PreJumping
                   3, // 15 Running
                  11, // 16 Turning Right
                   9, // 17 Turning Left
                   1, // 18 Walking
                  39, // 19 Landing
                  21, // 20 Standing 1
                  23, // 21 Standing 2
                  25, // 22 Standing 3
                  27, // 23 Standing 4
                  29, // 24 Standing 5
                  47, // 25 Treading Water
                  49, // 26 Swimming
                  51, // 27 Swim up
                  43  // 28 Swim Down
                ];

// This is an ugly hack, because the standing up animation doesn't work quite right
// (SL is borked, this has been bug reported)
// If you play a pose overtop the standing up animation, your avatar tends to get
// stuck in place.
// This is a list of anims that we'll stop automatically
list autoStop = [ 5, 6, 19 ];
// Amount of time we'll wait before autostopping the animation
float autoStopTime = 1.5;

// List of stands                      
list    standIndexes    = [ 20, 21, 22, 23, 24 ];

// How long before flipping stand animations
float standTime = 40.0;

// How fast we should poll for changed anims, changed by FlipperPA to cut lag
// Changed from 0.001 to 0.25
// running at 0.001 doesn't have much benefit; it causes the server to process 1000 times a second
// 0.25 causes server to process only 4 times a second, which in a streaming environment
// should be just fine, with almost no affect noticed by the end user. The cost to the server versus
// benefit to the user is a good chance, IMHO. :-)
float timerEventLength = 0.25;

// Send a message if we encounter a state we've never seen before
integer DEBUG = TRUE;

// GLOBALS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

list stands = [ "", "", "", "", "" ];          // List of stand animations
integer curStandIndex = 0;                     // Current stand we're on (indexed [0, numStands])
string curStandAnim = "";                      // Current Stand animation
integer numStands;                             // # of stand anims we use (constant: ListLength(stands))
integer curStandAnimIndex = 0;                 // Current stand we're on (indexed [0, numOverrides] )

list overrides = [];                           // List of animations we override
list notecardLineKey = [];                     // notecard reading keys
integer notecardLinesRead;                     // number of notecard lines read
integer numOverrides;                          // # of overrides (a constant - llGetListLength(lineNums))

string  lastAnim = "";                         // last Animation we ever played
integer lastAnimIndex = 0;                     // index of the last animation we ever played
string  lastAnimState = "";                    // last thing llGetAnimation() returned


integer animOverrideOn = TRUE;                 // Is the animation override on?
integer gotPermission  = FALSE;                // Do we have animation permissions?

integer listenHandler0;                        // Listen handlers

// CODE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
list listReplace ( list _source, list _newEntry, integer _index ) {
    return llListInsertList( llDeleteSubList(_source,_index,_index), _newEntry, _index );
}

startNewAnimation( string _anim, integer _animIndex, string _state ) {
    if ( _anim != lastAnim ) {
        if ( _anim != "" ) {   // Time to play a new animation
            llStartAnimation( _anim );
            
            if ( _state != lastAnimState && llListFindList(stopAnimName, [_state]) != -1 ) {
                // Stop the default sit/sit ground animation
                llStopAnimation( llList2String(stopAnimName, llListFindList(stopAnimName, [_state])) );
            } 
            else if ( llListFindList( autoStop, [_animIndex] ) != -1 ) {
                // This is an ugly hack, because the standing up animation doesn't work quite right
                // (SL is borked, this has been bug reported)
                // If you play a pose overtop the standing up animation, your avatar tends to get
                // stuck in place.
                if ( lastAnim != "" ) {
                    llStopAnimation( lastAnim );
                    lastAnim = "";
                }
                llSleep( autoStopTime );
                llStopAnimation( _anim );
            }
        }
        if ( lastAnim != "" )
            llStopAnimation( lastAnim );
        lastAnim = _anim;
    }
    lastAnimIndex = _animIndex;
    lastAnimState = _state;
}

// Load all the animation names from a notecard
loadNoteCard( string _notecard ) {
    integer i;
    
    if ( llGetInventoryKey(_notecard) == NULL_KEY ) {
        llSay( 0, "Notecard '" + _notecard + "' does not exist." );
        return;
    }

    llInstantMessage( llGetOwner(), "Loading notecard '" + _notecard + "'..." );
    // Start reading the data
    notecardLinesRead = 0;
    notecardLineKey = [];
    for ( i=0; i<numOverrides; i++ )
        notecardLineKey += [ llGetNotecardLine( _notecard, llList2Integer(lineNums,i) ) ];
}

// Figure out what animation we should be playing right now
animOverride() {
    string  curAnimState        = llGetAnimation(llGetOwner());
    integer curAnimIndex        = llListFindList( animState, [curAnimState] );
    integer underwaterAnimIndex = llListFindList( underwaterAnim, [curAnimIndex] );
    vector  curPos              = llGetPos();
    if ( curAnimState == lastAnimState ) {
        // Do nothing
        // This conditional not absolutely necessary (In fact it's better if it's not here)
        // But it's good for increasing performance.
    } else if ( curAnimIndex == -1 ) {
        if ( DEBUG )
            llInstantMessage( llGetOwner(), "Unknown animation state '" + curAnimState + "'" );
    }
    else if ( curAnimIndex == standIndex ) {
        startNewAnimation( curStandAnim, curStandAnimIndex, curAnimState );
    }
    else {
        if ( underwaterAnimIndex != -1 && llWater(ZERO_VECTOR) > curPos.z )
            curAnimIndex = llList2Integer( underwaterOverride, underwaterAnimIndex );
        startNewAnimation( llList2String(overrides,curAnimIndex), curAnimIndex, curAnimState );
    }
}

// Initialize listeners, and reset some status variables
initialize() {
    if ( animOverrideOn )
        llSetTimerEvent( timerEventLength );
    else
        llSetTimerEvent( 0 );
    lastAnim = "";
    lastAnimIndex = -1;
    lastAnimState = "";
    gotPermission = FALSE;
    if ( listenHandler0 )
        llListenRemove( listenHandler0 );
    listenHandler0 = llListen( LISTEN_CHANNEL, "", llGetOwner(), "" );
}

// STATE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

default {
    state_entry() {
        integer i;
        
        if ( llGetAttached() )
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS);
            
        // Initialize!
        numStands = llGetListLength( stands );
        numOverrides = llGetListLength(lineNums);
        curStandAnimIndex = llList2Integer(standIndexes,curStandIndex);

        // populate override list with blanks
        for ( i=0; i<numOverrides; i++ ) {
            overrides += [ "" ];
        }
        initialize();
        loadNoteCard( defaultNoteCard );
        llResetTime();
    }
    
    run_time_permissions(integer parm) {
        if( parm == (PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS) ) {
            llTakeControls( CONTROL_DOWN|CONTROL_UP|CONTROL_FWD|CONTROL_BACK|CONTROL_LEFT|CONTROL_RIGHT
                            |CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT, TRUE, TRUE);
            gotPermission = TRUE;
        }
    }
    
    attach( key k ) {
        if ( k != NULL_KEY )
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS);
    }
    
    listen(integer _channel, string _name, key _id,string _message) {
        if( _message == "ao on" ) {
            llSetTimerEvent( timerEventLength );
            animOverrideOn = TRUE;
            if ( gotPermission )
                animOverride();
            llInstantMessage( llGetOwner(), "Franimation override on." );
        }
        else if ( _message == "ao off" ) {
            llSetTimerEvent( 0 );
            animOverrideOn = FALSE;
            startNewAnimation( "", -1, lastAnimState );
            llInstantMessage( llGetOwner(), "Franimation override off." );
        }
        else if ( _message == "ao hide" ) {
            llSetLinkAlpha( LINK_SET, 0, ALL_SIDES );
            llInstantMessage( llGetOwner(), "Franimation override set invisible." );
        }
        else if ( _message == "ao show" ) {
            llSetLinkAlpha( LINK_SET, 1, ALL_SIDES );
            llInstantMessage( llGetOwner(), "Franimation override set visible." );
        }
        else if ( _message == "ao reset" ) {
            llResetScript();
        }
    }
    
    dataserver(key _query_id, string _data) {
        integer index = llListFindList( notecardLineKey, [_query_id] );
        if ( _data != EOF && index != -1 ) {    // not at the end of the notecard and not random crap
            if ( index == curStandAnimIndex )   // Pull in the current stand animation
                curStandAnim = _data;
            if ( index == lastAnimIndex )       // Whoops, we're replacing the currently playing anim
                startNewAnimation( _data, lastAnimIndex, lastAnimState );  // Better play the new one :)

            // Store the name of the new animation
            overrides = listReplace( overrides, [_data], index );
            
            // See if we're done loading the notecard. Users like status messages.
            if ( ++notecardLinesRead == numOverrides )
                llInstantMessage( llGetOwner(), "Finished reading notecard. (" +
                                  (string) llGetFreeMemory() + " bytes free)" );
        }
    }
    
    on_rez( integer _code ) {
        initialize();
    }

    touch_start(integer _total_number) {
    }
    
    control( key _id, integer _level, integer _edge ) {
        if ( animOverrideOn && gotPermission )
            animOverride();
    }
    
    timer() {
        if ( animOverrideOn && gotPermission ) {
            animOverride();
            if ( llGetTime() > standTime ) {
                curStandIndex = (curStandIndex+1) % numStands;
                curStandAnimIndex = llList2Integer(standIndexes,curStandIndex);
                curStandAnim = llList2String(overrides, curStandAnimIndex);
                if ( lastAnimState == "Standing" )
                    startNewAnimation( curStandAnim, curStandAnimIndex, lastAnimState );
                llResetTime();
            }
        }
    }
}
