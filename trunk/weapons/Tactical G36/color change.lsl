default
{
    state_entry()
    {
        
    }
    
    link_message(integer sender, integer num, string m, key id)
{
m=llToUpper(m); 
if (m=="RED") llSetColor(<1,0,0>, ALL_SIDES); 
if (m=="GREEN") llSetColor(<0,1,0>, ALL_SIDES); 
if (m=="BLUE") llSetColor(<0,0,1>, ALL_SIDES); 
if (m=="BLACK") llSetColor(<0,0,0>, ALL_SIDES); 
if (m=="WHITE") llSetColor(<1,1,1>, ALL_SIDES); 
if (m=="YELLOW") llSetColor(<1,1,0>, ALL_SIDES); 
if (m=="CYAN") llSetColor(<0,1,1>, ALL_SIDES); 
if (m=="MAGENTA") llSetColor(<1,0,1>, ALL_SIDES); 
if (m=="GREY") llSetColor(<0.5,0.5,0.5>, ALL_SIDES); 
} 

} 

