default
{

touch_start(integer t) 
{ 
      
        list inventory = []; 
        list INVENTORY_CONSTANTS = [INVENTORY_TEXTURE, INVENTORY_SOUND, 
           INVENTORY_OBJECT, INVENTORY_SCRIPT, INVENTORY_LANDMARK, 
           INVENTORY_CLOTHING, INVENTORY_NOTECARD, INVENTORY_BODYPART, 
           INVENTORY_ANIMATION]; 
        integer i; 
        integer j; 
        integer len = llGetListLength(INVENTORY_CONSTANTS); 
        for (i = 0; i < len; i++) { 
            integer constant = (integer) llList2String(INVENTORY_CONSTANTS, i); 
            integer num = llGetInventoryNumber(constant); 
            for (j = 0; j < num; j++) { 
                string name = llGetInventoryName(constant, j); 
                if (name != llGetScriptName()) // Let's not give this script away while giving inventory contents 
                { 
                    inventory += name; 
                } 
            } 
        } 
        string folderName = (string)llGetObjectName(); //Change this to change the name of the folder
        if (llDetectedKey(0) == llGetOwner())
        {
            llGiveInventoryList(llDetectedKey(0), folderName, inventory); // Give the user the contents of the object.
        }
        else
        {
            llSay(0, "You are not on the list of approved access."); // Doesn't give anyone but the owner the contents, if someone other than owner tries to click it, it does this.
        }
} 

}