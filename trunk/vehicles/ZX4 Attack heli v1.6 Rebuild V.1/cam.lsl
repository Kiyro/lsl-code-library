vector camera_position = <-7.0, 0.0, 3.5>;
vector camera_target = <0.5, 0.0, 0.0>;

default
{
    state_entry()
    {
        llSetCameraEyeOffset(camera_position);
        llSetCameraAtOffset(camera_target);
    }

   // touch_start(integer total_number)
 //   {
//        //llSay(0, "Touched.");
//    }
}
