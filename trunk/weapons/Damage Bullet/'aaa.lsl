//Avatar Type
list avatarsoundlist = ["0b8dc1d7-2ba3-8b54-8aa4-2ba64664bf2c","607667bc-5e8b-20b0-d101-703230ec4e8f"];
//Ground Type
list landsoundlist = ["865eb07f-a1e9-1cb6-d1d5-dbf6a6ca9297","26738818-f22e-9c68-d22b-b32036a548fe","934d6ac6-16ad-25d3-165b-689922507f56"];
//Object Type
list objectsoundlist = ["3fea5716-35c6-370c-f3fd-3b6f02fc5410","400cd364-173a-c954-9d65-5ae874fda641","c335a35b-d130-1d4a-0e2f-c5d8a7a16321","ed8a21ba-3774-1cd3-f8b7-24867cc583d6"];

sound(integer type)
{

    //1 - Land
    //2 - Object
    //3 - Avatar
    if(type == 1)
    {
        llTriggerSound(llList2Key(llListRandomize(llListRandomize(landsoundlist, 1), 1), 0), 1.0);
    }
    if(type == 2)
    {
        llTriggerSound(llList2Key(llListRandomize(llListRandomize(objectsoundlist, 1), 1), 0), 1.0);
    }
    if(type == 3)
    {
        llTriggerSound(llList2Key(llListRandomize(llListRandomize(avatarsoundlist, 1), 1), 0), 1.0);    
    }
}       

default
{
    collision_start(integer num_detected)
    {    
        if(llDetectedType(0) & AGENT)
        {   
            sound(3);
        }
        else
        {
            sound(2);
        }
    }
    land_collision(vector pos)
    {
        sound(1);
    }
}

