integer AutoSheathOnRez = TRUE; 

default
{
    state_entry()
    {
    if(AutoSheathOnRez) {
        llMessageLinked(LINK_SET, 0, "sheathed", "");
        //llSetAlpha(1.0, ALL_SIDES);
    }
    llListen(PUBLIC_CHANNEL,"",llGetOwner(),"");
    llListen(72,"","","");
    
    }
    on_rez(integer rez)
    {
    llResetScript();
    }
    
    
    listen(integer a, string b, key id, string msg)
    {   
    if(llGetOwnerKey(id) == llGetOwner())
        {
        if(msg == "/ls on") {
        llSetLinkAlpha(LINK_SET,0,ALL_SIDES);
        
        }
        if(msg == "/ls off"){
        llSetLinkAlpha(LINK_SET,1,ALL_SIDES);
        
        }
    }
    }
    attach(key id)
    {
        if(id == NULL_KEY){
           // llMessageLinked(LINK_SET, 0, "sheathed", "");
        }
    }
}
