//Rotation Script for non scripters

//Axis to ratate (1 is default speed)
float x=0;
float y=0; 
float z=1;

//Speed of the rotation (1 is recommended)
float speed=.25;

//Power of the object (1 is recommended)
float power=.25;

//Remote Pin number (MUST be the same as in the vendor script)
integer pin_number = 913329;
integer startup_param = 0;
string vendor_object_name = "BuildingShelterFreeVendor";
SpinMe()
{
    llTargetOmega(<x,y,z>,speed,power);
}

StopSpin()
{
    llTargetOmega(<0,0,0>,0,0);
}

//Please do not edit the lines below for any reason
default
{
    on_rez(integer param)
    {
        if (param == pin_number) 
        {
            SpinMe();
        } else {
            StopSpin();
        }
        startup_param = param;
        llSetRemoteScriptAccessPin(pin_number);
        if (startup_param == pin_number && llGetObjectName() != vendor_object_name) {
            llSetPrimitiveParams([PRIM_TEMP_ON_REZ, TRUE]);
        } else {
            llSetPrimitiveParams([PRIM_TEMP_ON_REZ, FALSE]);
        }
    }
    //Setup the spin and allow inventory to be dropped (this is the method of control)
    state_entry()
    {
    }

    //Messages that should do something i can care less who they are from
    link_message(integer sender, integer number, string message, key id)
    {   

        if (startup_param == pin_number && llGetObjectName() != vendor_object_name) {
            if(message == "DIE")
            {
                llDie();
            } else if(message == "SPIN")
            {
                SpinMe();
            }
        }
    }
}
