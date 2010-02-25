// Prim Calculator 1.3
// Catherine Omega Heavy Industries

// Tells you the number of prims that can be used on a given size of lot.
// Tells you the amount of land you must own to support a certain number of prims.
// Example: "/land 512" or "/prims 100"

default
{
    state_entry()
    {
        llListen(0,"",llGetOwner(),"");
    }

    listen(integer channel, string name, key id, string m)
    {
        integer command_divide = llSubStringIndex(m," "); // establish that space (" ") divides words.

        string gCommand = llToLower(llGetSubString(m, 0, command_divide - 1)); // grab the first word of the the input string.
        string gSubCommand = llToLower(llGetSubString(m, command_divide + 1, 40)); // grab the rest of the input string.
        
        // Calculate Prims
        if (gCommand == "/land")
        {
            float land = (float)gSubCommand;
            float primsF = land / 65536 * 15000;
            integer primsI = (integer)primsF; // converts the float to an integer for easier reading. Note that land must be purchased in parcels of 16 square metres.
            
            llSay(0,"You can use up to " + (string)primsI + " prims.");
        }
        
        // Calculate Land
        if (gCommand == "/prims")
        {
            integer prims = (integer)gSubCommand;
            integer land = prims * 65536 / 15000;
            llSay(0,"You need " + (string)land + " square metres of land to support " + (string)prims + " prims.");
        }
    }
}
