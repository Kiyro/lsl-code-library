default
{
    on_rez(integer p)
    {
        if(p!=0)
        {
            llSetTimerEvent(0.45);
        }
    }

    timer()
    {
        llDie();
    }
}

// Any questions ? call missjessie Babii
