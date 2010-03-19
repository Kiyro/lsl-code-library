//Mostly found for free from SL libraries. Retouched and adjusted for LCK 2.0
//opensource by Hanumi Takakura. Help from Riki Barret,Areth Gall and
//Ordinal Malaprop over the SL forums. Distribute free and under the GNU
//license. Modify as needed and put your name on your changes. 

default
{
    state_entry()
    {
        key owner = llGetOwner();
        llListen(0,"",owner,"");
    }
   listen( integer channel, string name, key id, string msg )
    {
        if (llGetOwnerKey(id) == llGetOwner())      
              {
                  if( msg == "/ls on" )
                  {
                  llSetLinkAlpha(LINK_SET,0,ALL_SIDES);
                  llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
                  llStartAnimation("hip anim");
                  }
                  if( msg == "/ls off" )
                  {
                   llSetLinkAlpha(LINK_SET,1,ALL_SIDES);
                  llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
                llStartAnimation("hip anim");
                  }
              }
    }

}