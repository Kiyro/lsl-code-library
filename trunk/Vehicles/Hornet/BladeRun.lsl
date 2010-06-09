default
{
    link_message(integer from, integer int, string txt, key id)
    {
        if (txt == "start")
        {
           llSetAlpha(0,1);
               llSetTexture("55fe1bc4-01b5-1533-52f1-d1f2389e49cc" , ALL_SIDES);
             llSetTexture("55fe1bc4-01b5-1533-52f1-d1f2389e49cc", 1);
            llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 10);
llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 1);
llSleep(1);
llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 2);
llSleep(1);
llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 3);
llSleep(1);
llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 4);
llSleep(1);
llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 5);
llSleep(1);
llSetTexture("55fe1bc4-01b5-1533-52f1-d1f2389e49cc" , ALL_SIDES);
llSetTexture("55fe1bc4-01b5-1533-52f1-d1f2389e49cc", 1);
llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 6);
llSleep(1);
llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 7);
llSleep(1);
llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 8);
llSleep(1);
llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 9);
llSleep(1);
llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 10);
           //  llLoopSound("f46d98b3-a812-0db8-a6d5-4943f1f7c1a3",1);
             
            llSetTexture("55fe1bc4-01b5-1533-52f1-d1f2389e49cc" , ALL_SIDES);
            llSetTexture("55fe1bc4-01b5-1533-52f1-d1f2389e49cc", 1);
        }
        if (txt == "stop")
        {
      llSetTexture("55fe1bc4-01b5-1533-52f1-d1f2389e49cc" , ALL_SIDES);
            llSetTexture("55fe1bc4-01b5-1533-52f1-d1f2389e49cc", 1);
        llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 10);
       llSleep(1);
       llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 9);
       llSleep(1);
       llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 8);
       llSleep(1);
       llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 7);
       llSleep(1);
       llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 6);
       llSleep(1);
       llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 5);
       llSetTexture("55fe1bc4-01b5-1533-52f1-d1f2389e49cc" , ALL_SIDES);
llSetTexture("55fe1bc4-01b5-1533-52f1-d1f2389e49cc", 1);
       llSleep(1);
       llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 4);
       llSleep(1);
       llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 3);
       llSleep(1);
       llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 2);
       llSleep(1);
       llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 1);
       llSetTexture("55fe1bc4-01b5-1533-52f1-d1f2389e49cc" , ALL_SIDES);
             llSetTexture("55fe1bc4-01b5-1533-52f1-d1f2389e49cc", 1);
        llSleep(1);
       llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 0);
       llSleep(1);
       
            
               
          
            llStopSound();
            if (txt == "half")
        {
          llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 0);
           llSetTexture("55fe1bc4-01b5-1533-52f1-d1f2389e49cc" , ALL_SIDES);
             llSetTexture("55fe1bc4-01b5-1533-52f1-d1f2389e49cc", 1); 
        }
            
        }
    }
}
