default
{
    state_entry()
    {
       llTargetOmega(<0,0,1>,.2,1.0); //first set of numbers is teh axis as represented in an ordered trecet <X, Y, Z> Put a 1 or a -1 on the axis you want it to spin on. The second number after the trecet is the speed. the third I have no idea what it does.
 //EX <0, 0, 1>, .5, 1.0) would make the object rotate around the x axis at a speed of .5
         llSetText("Pegue aqui seu Brinde! \n OOC (RPG)", <0.25,0.25,1>, 10);
    }

}
