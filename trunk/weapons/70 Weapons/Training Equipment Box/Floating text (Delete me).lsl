default
{
    state_entry()
    {
        llAllowInventoryDrop(TRUE); 
        llSetText("Free Wooden Training Weapons", <1,1,1>, 1);
       
    }
    
    touch_start(integer num)
    {
        llWhisper(0,"You see a crate filled with training equipment. (Buy for 0 lindens to obtain).");
    }
}
