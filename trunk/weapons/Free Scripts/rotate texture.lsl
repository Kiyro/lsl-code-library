float rotate;

default
{
    state_entry()
    {
        rotate = 0;
        llSetTimerEvent(.1);
        
    }

   timer()
   {
       rotate = rotate + .1;
       if (rotate==10.1)
       {
           rotate = 0;
           
        }
        llRotateTexture(rotate,ALL_SIDES);
     }
}
