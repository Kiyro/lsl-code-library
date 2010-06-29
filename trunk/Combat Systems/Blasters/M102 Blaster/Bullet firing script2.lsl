vector  gEyeOffset = <0.0, 0.0, 0.84>;
integer velocity=100;
f() 
    { 
vector my_pos = llGetPos() + gEyeOffset; 
rotation my_rot = llGetRot();
vector my_fwd = llRot2Fwd(my_rot);
llRezObject("Bullet", my_pos, my_fwd * velocity,my_rot,1);

}
 default
 {
     listen(integer c, string n ,key id, string m)
     {
         if(llGetSubString(m,0,1)=="/v")
            {
                string mess=llGetSubString(m,3,-1); 
                velocity-=velocity;
                velocity=(integer)mess;
               
            }
        }
        link_message(integer n, integer g, string m, key id)
        {
            if(m=="shots")
            {
                f();
            }
        }
    }       