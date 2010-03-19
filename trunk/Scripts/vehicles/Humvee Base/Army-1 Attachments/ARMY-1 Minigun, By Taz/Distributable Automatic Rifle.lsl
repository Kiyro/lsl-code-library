

integer z = FALSE; 
//key y = "b85073b6-d83f-43a3-9a89-cf882b239488"; 

m() 
{ 
    vector b = llGetPos();    // b is the position
    rotation a = llGetRot();  // a is the rotation
    
    vector something = llRot2Euler(a );
    something.x = .0 ; something.y= .0 ;
    
    a= llEuler2Rot (something);
    
    vector c = llRot2Fwd(a);  // c is the forward component of rotation
    vector d = llRot2Up(a);   // d is the upward component of rotation
    b += c; b += d * 1; c *= 65; 
    llRezObject("Bullet", b, c, a, 0); 
} 

default 

{ 
on_rez(integer blah)

{
    llResetScript();

}


state_entry() 
{ 

llPreloadSound("556SMGburst"); 
llSetSoundQueueing(TRUE); 

llListen (0, "", llGetOwner() , "fire");

} 

attach(key a) 
{ 

if(a == NULL_KEY) 
{   z = FALSE; 
    //llStopAnimation("hold_R_rifle"); 
    //llReleaseControls(); 
} 

else 

{  

integer b; 
b = PERMISSION_TRIGGER_ANIMATION; 
b += PERMISSION_TAKE_CONTROLS; 
//llRequestPermissions(a, b); 

}

} 


run_time_permissions(integer a) 
{ 

if(a > 0) 
{ 

//llStartAnimation("hold_R_rifle"); 
//llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE); 


} 

} 


listen(integer channel, string name, key id, string msg)
{
    
    llTriggerSound("556SMGburst", 1); 
    m();     
    m();     
    m();     
    m();     
    llTriggerSound("556SMGburst", 1);     
    
    
    
}


control(key a, integer b, integer c) 
{ 

if((b & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) 
{ 
    llTriggerSound("556SMGburst", 1); 
    m();     
    m(); 
} 

} 

}
