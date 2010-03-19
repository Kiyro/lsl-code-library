float tex_offs;

default
{
    state_entry()
    {
        llSitTarget(<0,0,0.01>,ZERO_ROTATION);
        llSetTimerEvent(0.01);
        
        tex_offs = 0;
        
        llSetBuoyancy(2.5f);
    }
    
    timer()
    {
        llOffsetTexture(tex_offs, tex_offs, ALL_SIDES);
        tex_offs += 0.01;
        
        if(tex_offs > 1.0)
        {
            tex_offs = 0;
        }
    }
}
