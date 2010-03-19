// CATEGORY:Vehicle
// CREATOR:Aaron Perkins
// DESCRIPTION:Realistic Car Seat.lsl
// ARCHIVED BY:Ferd Frederix

//**********************************************
//Title: Car Seat
//Author: Aaron Perkins
//Date: 2/17/2004
//**********************************************

default
{
    state_entry()
    {
        llSitTarget(<0,0,0.5>, llEuler2Rot(<0,-0.4,0> ));
    }

}
// END //
