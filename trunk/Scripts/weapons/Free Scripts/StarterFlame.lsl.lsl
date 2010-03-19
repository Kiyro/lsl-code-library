// Original flame script is open source by Gassy Cat Workshop. Freely distribute, but leave this comment block unchanged.

// Fuego script updated by Seronis Zagato for server friendliness
// USING UNFILTERED LISTENERS ON CHANNEL ZERO IS EVIL.  =-)
//

key scream="a233103c-982e-d3de-dd93-68c6e1a8e482"; // we don't need the actual sound in inv
string light_phrase="fuego!"; // how does speaker ignite flame? must be lower case.
string off_phrase="no fuego!"; // how does speaker turn flame off? must be lower case

default {
    state_entry() {
        llSetTexture("alpha", ALL_SIDES); // light
        llSetTextureAnim (ANIM_ON | LOOP,ALL_SIDES,4,4,0,0,20.0); // fire moves
        state doused;
    } // initialize base setting requirements
}

state doused {
    state_entry() {
        llListen(0,"",llGetOwner(),"");
        llListen(-913,"",NULL_KEY, light_phrase );

        llSetStatus(STATUS_PHANTOM, TRUE); // so nobody bumps into it
        llSetScale(<.1,.1,.1>); // shrink so that it's out of the way
        llSetTexture("alpha",ALL_SIDES);
    }

    listen(integer number, string name, key id, string message) // listen to me!
    {   message=llToLower(message);     // account for case
        if( message == light_phrase )   // speaker wants on
        {   llSay(-913,light_phrase);
            state ignited;
        }
    } // SCREAM!
}

state ignited {
    state_entry() {
        llListen(0,"",llGetOwner(),"");
        llListen(-913,"",NULL_KEY, off_phrase );

        llSetStatus(STATUS_PHANTOM, TRUE); // so nobody bumps into it
        llSetScale(<4,.01,4>);      // grow big!
        llSetTexture("lit_texture",ALL_SIDES); // light up!

        llPlaySound(scream,10);
    }

    listen(integer number, string name, key id, string message) // listen to me!
    {   message=llToLower(message);     // account for case
        if(message==off_phrase)         // speaker wants off
        {   llSay(-913,off_phrase);
            state doused;
        } // fire becomes invisible
    }
}