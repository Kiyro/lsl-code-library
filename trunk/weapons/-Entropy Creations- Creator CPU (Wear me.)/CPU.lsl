default
{
    state_entry()
    {
        key owner = llGetOwner();
        llListen(1,"",owner,"");
    }
    listen( integer channel, string name, key id, string message )
    {
        vector height = llGetAgentSize(llGetOwner());
        if( llToLower(message) == "pose" )
        {
            llRezObject("Posing Stand", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "haven" )
        {
            llRezObject("Builder Haven", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
            llInstantMessage(llGetOwner(), "Sit on the platform that is created near you to be taken up 400m.");
        }
        if( llToLower(message) == "claw" )
        {
            llRezObject("claw", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "column" )
        {
            llRezObject("column", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "cube" )
        {
            llRezObject("cube", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "half-cube" )
        {
            llRezObject("half-cube", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "pyramid" )
        {
            llRezObject("pyramid", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "prism" )
        {
            llRezObject("prism", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "cylinder" )
        {
            llRezObject("cylinder", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "half-cylinder" )
        {
            llRezObject("half-cylinder", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "cone" )
        {
            llRezObject("cone", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "half-cone" )
        {
            llRezObject("half-cone", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "sphere" )
        {
            llRezObject("sphere", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "half-sphere" )
        {
            llRezObject("half-sphere", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "torus" )
        {
            llRezObject("torus", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "tube" )
        {
            llRezObject("tube", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "ring" )
        {
            llRezObject("ring", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "spring" )
        {
            llRezObject("spring", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
        if( llToLower(message) == "shield" )
        {
            llRezObject("Sandbox Shield", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
            llInstantMessage(llGetOwner(), "Sit on the orb that is created near you to be protected from annoying sandbox pushers.");
        }
        if( llToLower(message) == "help cpu" )
        {
            llGiveInventory(llGetOwner(), "-Entropy Creations- Terms of Service");
            llGiveInventory(llGetOwner(), "-Entropy Creations- Creator CPU Readme");
            llRezObject("-Entropy Creations- Shapers", llGetPos() + (llRot2Fwd(llGetRot()) * 1),<0,0,0>,<0,0,0,1>,1);
        }
    }
    on_rez(integer start_param)
    {
        llInstantMessage(llGetOwner(), "Ready to begin, "+llKey2Name(llGetOwner())+". Please say '/1 help cpu' to recieve the Readme Notecard and begin the initialization process.");
        llResetScript();
    }
}

