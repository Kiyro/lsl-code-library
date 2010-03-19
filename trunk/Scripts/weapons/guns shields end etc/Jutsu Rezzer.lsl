default {

    on_rez( integer Parameter ) { llResetScript(); }
    
    state_entry() { llListen( 0, "", llGetOwner(), "Containment Jutsu" ); }
    
    listen( integer Channel, string Name, key Id, string Message ) {
    
        vector position = llGetPos();
        rotation angle = llGetRot();
        vector offset = <1.0, 0, 0>;

        llRezObject( "Containment", position + (offset * angle), ZERO_VECTOR, angle, 0 );
    }
} 