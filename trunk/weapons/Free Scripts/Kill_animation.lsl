default
{
    state_entry()
    {
        llSay(0, "Hello, Avatar!");
        llSetTextureAnim(0 | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0.0, 0.0, 0.5);

    }

    touch_start(integer total_number)
    {
        llSay(0, "Touched.");
    }
}
