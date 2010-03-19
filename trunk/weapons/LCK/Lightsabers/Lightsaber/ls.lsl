key owner;

default
{
    state_entry()
    {
        key objectkey = llGetKey();
        owner = llGetOwner();
        
        llInstantMessage(owner,"Type 'help' to learn how to us me.");
        llListen(0,"","","ls1 aqua");
        llListen(0,"","","ls1 black");
        llListen(0,"","","ls1 blue");
        llListen(0,"","","ls1 green");
        llListen(0,"","","ls1 grey");
        llListen(0,"","","ls1 orange");
        llListen(0,"","","ls1 purple");
        llListen(0,"","","ls1 red");
        llListen(0,"","","ls1 yellow");
        llListen(0,"","","ls1 white");
        llListen(0,"","","help");

    }

    listen(integer channel, string name, key id, string message)  
    {
        
        
        if (id == owner)
        {               
            
            
            if (message == "ls1 aqua")
            {   
                    llInstantMessage(owner," will now be AQUA nest time you activate it.");      
            }
            if (message == "ls1 black")
            {   
                llInstantMessage(owner," will now be BLACK next time you activate it.");               
            }
            if (message == "ls1 blue")
            {   
                llInstantMessage(owner," will now be BLUE next time you activate it.");                
            }
            if (message == "ls1 green")
            {
                llInstantMessage(owner," will now be GREEN next time you activate it.");          
            }
            if (message == "ls1 grey")
            {
                llInstantMessage(owner," will now be GREY next time you activate it.");           
            }
            if (message == "ls1 orange")
            {
                llInstantMessage(owner," will now be ORANGE next time you activate it.");
            }
            if (message == "ls1 purple")
            {   
                llInstantMessage(owner," will now be PURPLE next time you activate it.");            
            }
            if (message == "ls1 red")
            {   
                llInstantMessage(owner," will now be RED next time you activate it.");            
            }
            if (message == "ls1 yellow")
            {
                llInstantMessage(owner," will now be YELLOW next time you activate it.");
            }
            if (message == "ls1 white")
            {
                llInstantMessage(owner," will now be WHITE next time you activate it.");
            }       
            
                    
            
        }
        if (message == "help")
            {
                llGiveInventory(id,"LightSaber Instructions");
            }
    
        
    }
}