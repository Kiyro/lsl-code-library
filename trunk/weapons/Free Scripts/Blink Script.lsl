default
{
    state_entry()
    {
        llSetTexture("5eee2450-1bcf-ee2f-c634-ae3c9ad83aae",ALL_SIDES);
        float speed = 3; //times to change per second
        llSetTextureAnim(ANIM_ON|LOOP,ALL_SIDES,2,1,0,0,speed);
    }
}
