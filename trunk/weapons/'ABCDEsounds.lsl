vector push = <0,0,-8>; 
string texture = "351f44e5-69c3-08f8-c3a7-54ca14e59290";
float damage = 90;

test0( integer chargeval )
{
    
    float SoundVal = llFrand(100);
    if (SoundVal <= 33) llTriggerSound("004afc08-4b29-29a6-17e3-6b8d63da6c55", 10.0);
    else if (SoundVal >= 66) llTriggerSound("4f7f666c-4092-5f4d-096a-6576ed6ef137", 10.0);             
    else llTriggerSound("004afc08-4b29-29a6-17e3-6b8d63da6c55", 10.0); 
}
test1( integer chargeval )
{
    
    float SoundVal = llFrand(100);
    if (SoundVal <= 33) llTriggerSound("ric2.wav", 10.0);
    else if (SoundVal >= 66) llTriggerSound("ric1.wav", 10.0);             
    else llTriggerSound("ric4.wav", 10.0); 
}
default
{
    on_rez(integer sparam)
    
    {
        llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
        llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y | STATUS_ROTATE_Z, FALSE);
        
        }   
    
    
  

    collision_start(integer chargeval )
    
        {
        
     integer type = llDetectedType(0); 
    
        if (type & AGENT)
        
        {
        
         
          
            
         llTriggerSound("ff89ed2f-d011-7cfc-8bbc-0b4058a55d2e", 10.0);
         llParticleSystem( [  
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
            PSYS_SRC_TEXTURE, texture, 
            PSYS_SRC_BURST_PART_COUNT,(integer) 15,   // adjust for beam strength,
            PSYS_SRC_BURST_RATE,(float) .05,          
            PSYS_PART_MAX_AGE,(float)  .6,            
            PSYS_SRC_BURST_SPEED_MIN,(float)1,        
            PSYS_SRC_BURST_SPEED_MAX,(float) 1.0,      
            PSYS_PART_START_SCALE,(vector) <1,1,1>, 
            PSYS_PART_END_SCALE,(vector) <1,1,1>,   
            PSYS_PART_START_COLOR,(vector) <.4,.0,0>,  
            PSYS_PART_END_COLOR,(vector) <.3,.05,0>,   
            PSYS_PART_START_ALPHA,(float)1.5,          
            PSYS_PART_END_ALPHA,(float)1.00,
            PSYS_SRC_ACCEL, push,          
            PSYS_PART_FLAGS,
                 PSYS_PART_EMISSIVE_MASK |
                 PSYS_PART_INTERP_COLOR_MASK |      
                 PSYS_PART_FOLLOW_VELOCITY_MASK |
                 PSYS_PART_FOLLOW_SRC_MASK |   
                 PSYS_PART_INTERP_SCALE_MASK
                                
        ] ); 
        llSetStatus(STATUS_PHANTOM , TRUE);
        llParticleSystem( [] );
        llSleep(0.5); 
        llDie();
            
            
        }
        
        else
        
        {
        test0( (integer) chargeval );
        llParticleSystem( [  
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
            PSYS_SRC_BURST_PART_COUNT,(integer) 20,   // adjust for beam strength,
            PSYS_SRC_BURST_RATE,(float) .05,          
            PSYS_PART_MAX_AGE,(float)  .6,            
            PSYS_SRC_BURST_SPEED_MIN,(float)2,        
            PSYS_SRC_BURST_SPEED_MAX,(float)  2.50,      
            PSYS_PART_START_SCALE,(vector) <.20,.30,.20>, 
            PSYS_PART_END_SCALE,(vector) <.10,.40,.10>,   
            PSYS_PART_START_COLOR,(vector) <1,1,0.7>,  
            PSYS_PART_END_COLOR,(vector) <1,1,0>,   
            PSYS_PART_START_ALPHA,(float)1.5,          
            PSYS_PART_END_ALPHA,(float)1.00,
            PSYS_SRC_ACCEL, push,          
            PSYS_PART_FLAGS,
                 PSYS_PART_EMISSIVE_MASK |
                 PSYS_PART_INTERP_COLOR_MASK |      
                 PSYS_PART_FOLLOW_VELOCITY_MASK |
                 PSYS_PART_FOLLOW_SRC_MASK |   
                 PSYS_PART_INTERP_SCALE_MASK
                                
        ] ); 
        llSetStatus(STATUS_PHANTOM , TRUE);
        llParticleSystem( [] );
        llSetStatus(STATUS_PHANTOM , TRUE);
        llSleep(0.5);   
        
        llDie();
               
        }
    }
    
    
    }


