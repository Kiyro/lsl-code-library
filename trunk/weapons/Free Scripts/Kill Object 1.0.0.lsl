default
{
    state_entry()
    {
        key id = llGetOwner();
        llListen(0,"",id,"kill object");
    }

    listen(integer number, string name, key id, string m)
     {
        if (m=="kill object")
        {
            llDie();
        }
    }
}

