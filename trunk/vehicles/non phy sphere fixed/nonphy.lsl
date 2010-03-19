// Non-Physical Flying Vehicle

// A.K.A: How to exploit tricks in LSL to get your way

//

// (your way being: up to 254 prims on a vehicle, in this case)

// Author: Jesrad Seraph

// Modify and redistribute freely, as long as your permit free modification and redistribution


integer hidden_face = 1;


float max_fwd = 1.0;    // fraction of the max horizontal velocity set in move and move2

float max_vert = 1.0;    // fraction of the max vertical velocity set in move and move2



integer active;

vector velocity;


float rotacity;



default

{

    on_rez(integer p)

    {

        active = FALSE;

        velocity = <0.5, 0.5, 0.5>;

        rotacity = 0.5;

        llSetPrimitiveParams([PRIM_COLOR, hidden_face, velocity, rotacity]);

    }



    touch_start(integer c)

    {

        if (llDetectedKey(0) != llGetOwner()) return;

        if (active)

        {

            llReleaseControls();

            active = FALSE;

        } else {

            llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);

        }

    }



    run_time_permissions(integer p)

    {

        if (p)

        {

            llTakeControls(CONTROL_FWD|CONTROL_BACK|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT|CONTROL_LEFT|CONTROL_RIGHT|CONTROL_UP|CONTROL_DOWN, TRUE, FALSE);

            active = TRUE;

            velocity = <0.5, 0.5, 0.5>;

            rotacity = 0.5;

            llSetColor(velocity, hidden_face);

            llSetAlpha(rotacity, hidden_face);

        } else {

            llReleaseControls();

            active = FALSE;

        }

    }



    control(key id, integer down, integer change)

    {

        if (down & CONTROL_FWD)

        {

            if (change & CONTROL_FWD) { velocity.x = 0.65; } else velocity.x = max_fwd;

        } else if (down & CONTROL_BACK)

        {

            if (change & CONTROL_BACK) { velocity.x = 0.35; } else velocity.x = (1.0 - max_fwd);

        } else {

            velocity.x = 0.5;

        }

        

        if (down & CONTROL_UP)

        {

            if (change & CONTROL_UP) { velocity.z = 0.65; } else velocity.x = max_vert;

        } else if (down & CONTROL_DOWN)

        {

            if (change & CONTROL_DOWN) { velocity.z = 0.35; } else velocity.z = (1.0 - max_vert);

        } else {

            velocity.z = 0.5;

        }



        if (down & (CONTROL_LEFT|CONTROL_ROT_LEFT))

        {

            if (change & (CONTROL_LEFT|CONTROL_ROT_LEFT)) { rotacity = 0.65; } else rotacity = 1.0;

        } else if (down & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))

        {

            if (change & (CONTROL_RIGHT|CONTROL_ROT_RIGHT)) { rotacity = 0.35; } else rotacity = 0.0;

        } else {

            rotacity = 0.5;

        }

        llSetColor(velocity, hidden_face);

        llSetAlpha(rotacity, hidden_face);

    }

}

