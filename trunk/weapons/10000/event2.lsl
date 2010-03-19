integer bullettype = 1;
 integer listener; key owner;
default
{
    on_rez(integer param)
    {
        owner = llGetOwner(); llListenRemove(listener); listener = llListen(0,"",owner,"");
    }

    touch_start(integer total_number)
    {
        //llSay(0, "Touched.");
    }
    
         listen( integer channel, string name, key id, string message )
    { 
        if ( message == "m" ) //PUT HERE THE WORD YOU WANT TO TRIGGER THE SWITCH
        {
            if (bullettype == 3)
            {
                bullettype = 1;
               llMessageLinked(LINK_SET, 0, "mode", "");
              //  llSetScriptState("slave1",TRUE);
               // llSetScriptState("slave2", TRUE); //burst
              //  llSetScriptState("slave3", TRUE);
                //llSetScriptState("slave4", TRUE);
               // llSetScriptState("slave5", TRUE); //turns script.3 off //turns script.3 off
                
            }   
            else if (bullettype == 1)
            {
                bullettype = 2;
                 llMessageLinked(LINK_SET, 1, "mode", "");
                //llSetScriptState("slave1", TRUE);
                //llSetScriptState("slave2", TRUE);
               // llSetScriptState("slave3", FALSE); //single
               // llSetScriptState("slave4", FALSE);
               // llSetScriptState("slave5", FALSE); 
                
            }
            
            else if (bullettype == 2)
            {
                bullettype = 3;
                llMessageLinked(LINK_SET, 2, "mode", "");
                //llSetScriptState("slave1", FALSE);
                //llSetScriptState("slave2", FALSE);
                //llSetScriptState("slave3", FALSE); //full auto
                //llSetScriptState("slave4", FALSE);
               // llSetScriptState("slave5", FALSE);  //turns script.3 off //turns script.3 off
                
            }
        }
    }
    
}


