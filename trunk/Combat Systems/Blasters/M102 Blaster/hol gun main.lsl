//This is the child script for my blaster script, if someone other then I got this script, then im confused :)
//45648569-2df0-c7e5-13f9-aa73a406f303
key invis = "8bc7a8b6-ce6a-5565-deae-523cbd63c463";
key texture = "e0e4623f-686f-d205-e4fc-73b2e7cbc0c6";
string owner;
checkown()
{
    owner=llGetOwner();
}
stopall()
{
    llStopAnimation("hold_r_bazooka");
    llStopAnimation("hold_r_handgun");
    llStopAnimation("hold_r_rifle");
    llStopAnimation("aim_r_bazooka");
    llStopAnimation("aim_r_handgun");
    llStopAnimation("aim_r_rifle");
}
default
{
    state_entry()
    {
        string owner = llGetOwner();
        llRequestPermissions(owner,PERMISSION_TRIGGER_ANIMATION);
        llListen(758,"","","");
        
    }
        listen(integer c, string n, key id, string m)
    {
        if(m=="hol")
        {
            stopall();
            llSetTexture((string)invis,ALL_SIDES);
            
        }
        if(m=="unhol")
        {
            
            llSetTexture((string)texture,ALL_SIDES);
        }
        
    }
    link_message(integer c, integer s, string m, key id)
    {
        if(m=="pistol")
        {
            llStartAnimation("hold_r_handgun");
        }
        else if(m=="rifle")
        {
            llStartAnimation("hold_r_rifle");
        }
        else if(m=="bazooka")
        {
            llStartAnimation("hold_r_bazooka");
        }
    }
}