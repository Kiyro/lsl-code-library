default
{
    state_entry()
    {
       llTargetOmega(<0,0,1>,PI,1.0);
    }
on_rez(integer start_param)
{
    llSleep(6);
    llDie();
}
}
