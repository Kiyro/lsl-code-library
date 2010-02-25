//•/•/•/•/•/•/•/D/A/M/E/N/•/H/A/X/•/•/•/•/•/•/•/•/•//

default 
{
    link_message(integer sender, integer num, string str, key id)
    {
        string response_string;
        if (str == "Red")
        {
        list lighton = [ PRIM_POINT_LIGHT,TRUE, 
                             <255, 0, 0>, 
                             1.0, 
                             10.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
/////////////////////////////////////
        else if (str == "Darkred")
        {
        list lighton = [ PRIM_POINT_LIGHT,TRUE, 
                             <0.5, 0, 0>, 
                             1.0, 
                             10.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
/////////////////////////////////////
        else if (str == "Green")
        {
        list lighton = [ PRIM_POINT_LIGHT,TRUE, 
                             <0, 255, 0>, 
                             1.0, 
                             10.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
/////////////////////////////////////
        else if (str == "Darkgreen")
        {
        list lighton = [ PRIM_POINT_LIGHT,TRUE, 
                             <0, 0.5, 0>, 
                             1.0, 
                             10.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
/////////////////////////////////////
        else if (str == "Blue")
        {

        list lighton = [ PRIM_POINT_LIGHT,TRUE, 
                             <0, 0, 255>, 
                             1.0, 
                             10.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
/////////////////////////////////////
        else if (str == "Darkblue")
        {
        list lighton = [ PRIM_POINT_LIGHT,TRUE, 
                             <0, 0, 0.5>, 
                             1.0, 
                             10.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
/////////////////////////////////////
        else if (str == "Lavender")
        {
        list lighton = [ PRIM_POINT_LIGHT,TRUE, 
                             <0.2,0.2,0.4>, 
                             1.0, 
                             10.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
/////////////////////////////////////
        else if (str == "Pink")
        {
        list lighton = [ PRIM_POINT_LIGHT,TRUE, 
                             <1,0.5,0.5>, 
                             1.0, 
                             10.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
/////////////////////////////////////
        else if (str == "Neon-Pink")
        {
        list lighton = [ PRIM_POINT_LIGHT,TRUE, 
                             <1,0,0.5>, 
                             1.0, 
                             10.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
/////////////////////////////////////
        else if (str == "Yellow")
        {
        list lighton = [ PRIM_POINT_LIGHT,TRUE, 
                             <1,1,0>, 
                             1.0, 
                             10.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
/////////////////////////////////////
        else if (str == "Orange")
        {
        list lighton = [ PRIM_POINT_LIGHT,TRUE, 
                             <1,0.5,0>, 
                             1.0, 
                             10.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
/////////////////////////////////////
        else if (str == "Brown")
        {
        list lighton = [ PRIM_POINT_LIGHT,TRUE, 
                             <0.5,0.25,0>, 
                             1.0, 
                             10.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
/////////////////////////////////////
        else if (str == "Gold")
        {
        list lighton = [ PRIM_POINT_LIGHT,TRUE, 
                             <0.5,0.5,0>, 
                             1.0, 
                             10.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
/////////////////////////////////////
        else if (str == "-< ON >-")
        {
        list lighton = [ PRIM_POINT_LIGHT,TRUE, 
                             <1,1,1>, 
                             1.0, 
                             10.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
/////////////////////////////////////
        else if (str == "-< OFF >-")
        {
        list lighton = [ PRIM_POINT_LIGHT,FALSE, 
                             <1,1,1>, 
                             0.0, 
                             0.0, 
                             0.0];
        llSetPrimitiveParams( lighton );
        }
        else
        {
            //llOwnerSay("Invalid Selection, Try again~");
        }
    }
//
}