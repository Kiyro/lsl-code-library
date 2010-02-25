default
{
    state_entry()
    {
        llSetBuoyancy(1); // so gravity doesn't pull our physical spells down
    }

   //Event if you hit a person or object
    collision_start(integer i){
        
        llDie();    // Delete object
    }
    
    //Event if you hit the ground
    land_collision_start(vector pos) {
    
        llDie(); //Delete object
    }
    
    //Event that happens when the spell is rezzed from the wand
    on_rez(integer param){
      
    }
}
