//Title: Simple Notecard Vendor
//Date: 12-09-2003 03:39 AM
//Scripter: Essence Lumin

default
{
    touch_start(integer total_number)
    {
        llGiveInventory(llDetectedKey(0), "Pyramid Mall Rental and Contact Info");
    }
}

