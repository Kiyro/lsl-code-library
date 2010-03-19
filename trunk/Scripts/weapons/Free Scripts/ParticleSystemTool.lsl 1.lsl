// ParticleSystemTool.lsl
//
// There are four calls in the scripting language that produce
// particle-systems.  They are:
// 
//      llMakeExplosion()
//      llMakeFire()
//      llMakeFountain()
//      llMakeSmoke()
//
// Unfortunately, the documentation in the Second Life scripting
// guide is woefully inadequate.  What to do?  ==>  Experiment!
// 
// This script can help an intrepid scriptor home in on good
// parameters for making a particle-system look "just right".
// It accepts commands from its owner that can make any of the 
// four particle systems, or change the values of the parameters
// that are used in the llMake*() call.
// 
// To make a particle system, chat one of the following commands:
//
//      explosion   -- rapidly expanding, no fading
//      fire        -- rises quickly, fades quickly
//      fountain    -- bounces on some plane, influenced by wind
//      smoke       -- rises slow, fades slow
//
// To hear a report on the current values being used in the script
// call, chat the following command:
//
//      report      -- chats list of parameter values     
//
// To change one of the parameters, use a command of the form:
//
//      parameter,value
//
// Where "parameter" is one of the following:
//
//      count       -- the number of particles to produce (integer only)
//      scale       -- the size of particles
//      speed       -- speed at which particles move
//      lifetime    -- how long particles last
//      arc         -- arc of randomization
//      bounce      -- ??? (fountain only) (integer only)
//      offset      -- where to spawn the particles (in object's z direction)
//      bounce_offset   -- ??? (fountain only)
//
// and "value" is a number, whitespace is allowed after the comma
//
// Note: the same parameters passed to different varieties of particle
// systems will produce very different results.  For instance, since "fire"
// systems decay faster than "explosion" systems, the same "lifetime" 
// parameter will not produce particle systems with the same apparent
// lifetime.  Hence the need for this script for exploring what works,
// and what doesn't.
//
// Play and learn.
//
// Andrew Linden

  
// These are the parameters
integer count = 1000;
float scale = 10.0;
float speed = 100.0;
float lifetime = 1000.0;
float arc = PI;                     // radians (not solid-angle)
integer bounce = 1;                 // fountain only
vector offset = <0,0,1>;
float bounce_offset = 1.0;          // fountain only

string last_command = "explosion";

// change this line to change the texture used in the particle system
// (the texture must be in this object's inventory, and have the 
// exact name you supply here)
string particle_texture = "butterfly2";


// a custom function for figuring out which particle system to make
make_particles(string command)
{
    // this script expects a texture in the object's inventory called "heart"
    if (command == "fountain")
        {
            llMakeFountain(count, scale, speed, lifetime, arc, bounce, particle_texture, offset, bounce_offset);
            last_command = command;
        }
        else if (command == "explosion")
        {
            llMakeExplosion(count, scale, speed, lifetime, arc, particle_texture, offset);
            last_command = command;
        }
        else if (command == "fire")
        {
            llMakeFire(count, scale, speed, lifetime, arc, particle_texture, offset);
            last_command = command;
        }
        else if (command == "smoke")
        {
            llMakeSmoke(count, scale, speed, lifetime, arc, particle_texture, offset);
            last_command = command;
        }
}


default
{
    state_entry()
    {
        // only accept commands from the owner
        llListen(0, "", llGetOwner(), "");
        last_command = "explosion";
    }
    
    touch_start(integer touch_count)
    {
        // make another particle system like the last one
        make_particles(last_command);
    }
    
    listen(integer channel, string name, key id, string command)
    {
        // convert the comma separated values (CSV) to a list
        list command_list = llCSV2List(command);
        integer list_length = llGetListLength(command_list);
        
        if (list_length == 1)
        {
            // found a single-word command
            if (command == "report")
            {
                llWhisper(0, "count = " + (string)count);
                llWhisper(0, "scale = " + (string)scale);
                llWhisper(0, "speed = " + (string)speed);
                llWhisper(0, "lifetime = " + (string)lifetime);
                llWhisper(0, "arc = " + (string)arc);
                llWhisper(0, "bounce = " + (string)bounce);
                llWhisper(0, "offset = " + (string)offset);
                llWhisper(0, "bounce_offset = " + (string)bounce_offset);
            }  
            else
            {
                make_particles(command);
            }
        }
        else if (list_length == 2)
        {
            // found a command of the form: "parameter,value"
            string variable = llList2String(command_list, 0);
            string value = llList2String(command_list, 1);
            if (variable == "count")
            {
                count = llList2Integer(command_list, 1);
                llWhisper(0, "count = " + (string)count);
            }
            else if (variable == "scale")
            {
                scale = llList2Float(command_list, 1);
                llWhisper(0, "scale = " + (string)scale);
            }
            else if (variable == "speed")
            {
                speed = llList2Float(command_list, 1);
                llWhisper(0, "speed = " + (string)speed);
            }
            else if (variable == "lifetime")
            {
                lifetime = llList2Float(command_list, 1);
                llWhisper(0, "lifetime = " + (string)lifetime);
            }
            else if (variable == "arc")
            {
                arc = llList2Float(command_list, 1);
                llWhisper(0, "arc = " + (string)arc);
            }
            else if (variable == "bounce")
            {
                bounce = llList2Integer(command_list, 1);
                llWhisper(0, "bounce = " + (string)bounce);
            }
            else if (variable == "offset")
            {
                // we can't pass vectors into a CSV, so we only change the z-value here
                offset.z = llList2Float(command_list, 1);
                llWhisper(0, "offset = " + (string)offset);
            }
            else if (variable == "bounce_offset")
            {
                bounce_offset = llList2Float(command_list, 1);
                llWhisper(0, "bounce_offset = " + (string)bounce_offset);
            }
        }
    }
}
