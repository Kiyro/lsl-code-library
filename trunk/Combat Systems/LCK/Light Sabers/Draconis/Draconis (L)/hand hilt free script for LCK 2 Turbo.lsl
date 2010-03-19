//Extracted from LCK 2.0's core script and modified for hilts by Hanumi
//Takakura. Use under GNU license. Please put your name on any changes.
//vector saberColor;

default
{
    link_message(integer sender_num, integer num, string msg, key id)
    {
        if(msg == "OFF")
        {
            llSetLinkAlpha(LINK_SET,0,ALL_SIDES);
        }
        else if(msg == "ON")
        {
            llSetLinkAlpha(LINK_SET,1,ALL_SIDES);
        }
    }
    state_entry()
    {
        llListen(72,"","","");
    }
    
    listen( integer channel, string name, key id, string message )
    {
        if(llGetOwnerKey(id) == llGetOwner())
            {
            if( message == "saber1 on" )
            {
                llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
                llStartAnimation("hip anim");
            }
            if( message == "saber1 off" )
            {
                llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
                llStartAnimation("hip anim");
            }
            if( message == "saber2 on" )
            {
                llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
                llStartAnimation("hip anim 2");
            }
            if( message == "saber2 off" )
            {
                llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
                llStartAnimation("hip anim 2");
            }
            if( message == "twin on" )
            {
                llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
                llStartAnimation("hip anim 3");
            }
            if( message == "twin off" )
            {
                llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
                llStartAnimation("hip anim 3");
            }
        }
    }
}