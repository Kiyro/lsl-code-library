
integer gTimeout = 10;

default
{
    state_entry()
    {

    }

    attach(key on)
    {
        if (on != NULL_KEY)
        {
            llRequestPermissions(on, PERMISSION_TRIGGER_ANIMATION);
            llSetTimerEvent(0.0);
            llSetTimerEvent(gTimeout);
        }
        else
        {
            llSetTimerEvent(0.0);
        }        
    }
    
    timer()
    {
        float choice;
        choice = llFrand(3.0);
        if (choice < 2.5)
        {
            llStartAnimation("smoke_inhale");
        }
        else
        {
            llStartAnimation("smoke_inhale");
        }
    }
    
}
