/////////////////////////////////
//ultra basic sliding door script
//by Kyrah Abattoir
/////////////////////////////////

vector closed = <121.007,31.148,23.088>;//XYZ coordinates of the door when closed
vector open = <119.941,31.148,23.088>;//XYZ coordinates of the door when closed
float time = 5.0;//time before the door close itself
default
{
    state_entry()
    {
        llSetPos(closed);
        llSetText("",<1,1,1>,1.0);//REMOVE THIS LINE
    }

    touch_start(integer total_number)
    {
        llSetPos(open);
        llSleep(time);
        llSetPos(closed);
    }
}
