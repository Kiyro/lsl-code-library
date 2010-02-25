//GT flex skirt generator
float elipse = 1.0; //elipse parameter between 0 (line) and 1 (perfect circle)
float bend = 0.0; //bending parameter 0 = flat .3
string link = "panel"; //object to use
integer number = 20; //number links in chain
vector offsetrot = <0,0,0>; //rotation of object

make()
{
    integer n;
    float t; //parameter
    float d; //derivitive angle
    vector p; //position
    vector re; //rotation in euler
    rotation rot; //re in rot format

    for(n = 1;n <= number;n++) {
        t = TWO_PI * ((float)n/(float)number);
        llOwnerSay((string)n);
        p.x = llCos(t);
        p.y = elipse * llSin(t);
        p.z = bend * llCos(t)*llCos(t) + 1;
        p = p + llGetPos();
        re.x = -1 * llSin(t) + DEG_TO_RAD * offsetrot.x;
        re.y = llCos(t) + DEG_TO_RAD * offsetrot.y;

        re.z = t + DEG_TO_RAD * offsetrot.z;

        rot = llEuler2Rot(re);
        llRezObject(link, p, ZERO_VECTOR, rot, 0);
    }
}
        

default
{
    state_entry()
    {
        llSay(0, "Touch to generate");
    }

    touch_start(integer total_number)
    {
        make();
    }
}
