float max_vel = 2.0;

integer hidden_face = 1;



default

{

    state_entry()

    {

        llSleep(0.3);    // this is to let the control script stop it from running

        while(TRUE)

        {

            llSetPos(max_vel * (llGetColor(hidden_face) - <0.5, 0.5, 0.5>) * llGetRot() + llGetPos());

            llSetPos(max_vel * (llGetColor(hidden_face) - <0.5, 0.5, 0.5>) * llGetRot() + llGetPos());

            llSetPos(max_vel * (llGetColor(hidden_face) - <0.5, 0.5, 0.5>) * llGetRot() + llGetPos());

            llSetPos(max_vel * (llGetColor(hidden_face) - <0.5, 0.5, 0.5>) * llGetRot() + llGetPos());

            llSetPos(max_vel * (llGetColor(hidden_face) - <0.5, 0.5, 0.5>) * llGetRot() + llGetPos());

        }

    }

}