integer hidden_face = 1;

float max_vel = 0.4;



default

{

    state_entry()

    {

        llSleep(0.2);    // this is to let the control script stop it from running

        while(TRUE)

        {

            llSetRot(llGetRot() * llEuler2Rot(<0,0,max_vel * (llGetAlpha(hidden_face) - 0.5)>) );

            llSetRot(llGetRot() * llEuler2Rot(<0,0,max_vel * (llGetAlpha(hidden_face) - 0.5)>) );

            llSetRot(llGetRot() * llEuler2Rot(<0,0,max_vel * (llGetAlpha(hidden_face) - 0.5)>) );

            llSetRot(llGetRot() * llEuler2Rot(<0,0,max_vel * (llGetAlpha(hidden_face) - 0.5)>) );

            llSetRot(llGetRot() * llEuler2Rot(<0,0,max_vel * (llGetAlpha(hidden_face) - 0.5)>) );

        }

    }

}