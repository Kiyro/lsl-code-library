//MELEE/RANGE WEAPON SCRIPTSET - COMBO ALPHA/TEXTURE ANIMATION/GLOW SLAVE
//Aug 2009 - Nexus Industries
//
//*License Conditions*
//  All that is asked is this is not resold. Give it away for free or direct inquiries to Nexus Industries.
//
//*Begin Code*

// The (preferred) alternative to using Slave Scripts for Alpha/Glow is to use the MultiAlpha/Glow Plugins. //

// For the Weapon/Dummy Master Scripts; SHOW triggers when Drawn, HIDE when Sheathed. //
// For the Sheath Master Script; HIDE triggers when Drawn, SHOW when Sheathed. //

// TIP - Prims that Glow should be Full Bright (Texture Tab) for precise control over the Glow appearance. //
// TIP - Alpha = 1.0 - (Texture Tab Transparency / 100) //
// NOTE - An understanding of the llSetTextureAnim function is required for the ANIM functions. //

///BEGIN CONFIG///
//-Alpha-//
integer THISPRIM_ALPHA = 0;                                     // Use SHOW/HIDE ALPHA Commands on this Prim. (1 = On, 0 = Off)
float SHOW_ALPHA = 1.0;                                         // SHOW mode Alpha value (1.0 = Full Visible, 0.0 = Non Visible)
float HIDE_ALPHA = 0.0;                                         // HIDE mode Alpha value (1.0 = Full Visible, 0.0 = Non Visible)
//-Glow-//
integer THISPRIM_GLOW = 0;                                      // Use SHOW/HIDE GLOW Commands on this Prim. (1 = On, 0 = Off)
float SHOW_GLOWVAL = 0.1;                                       // SHOW mode Glow value (1.0 = Max Bright, 0.0 = None)
float HIDE_GLOWVAL = 0.0;                                       // HIDE mode Glow value (1.0 = Max Bright, 0.0 = None)
//-TextureAnim-//
integer THISPRIM_TEXANIM = 0;                                   // Use SHOW/HIDE TEXANIM Commands on this Prim. (1 = On, 0 = Off)
integer SHOW_MODE;  // Use Config2 Below. //
integer SHOW_FACE = ALL_SIDES;                                  //SHOW mode llSetTextureAnim 'Face'
integer SHOW_SIZEX = 1;                                         //SHOW mode llSetTextureAnim 'SizeX'
integer SHOW_SIZEY = 1;                                         //SHOW mode llSetTextureAnim 'SizeY'
float SHOW_START = 1.0;                                         //SHOW mode llSetTextureAnim 'Start'
float SHOW_LENGTH = 1.0;                                        //SHOW mode llSetTextureAnim 'Length'
float SHOW_RATE = 0.06;                                         //SHOW mode llSetTextureAnim 'Rate'
integer HIDE_MODE;  // Use Config2 Below. //
integer HIDE_FACE = ALL_SIDES;                                  //HIDE mode llSetTextureAnim 'Face'
integer HIDE_SIZEX = 1;                                         //HIDE mode llSetTextureAnim 'SizeX'
integer HIDE_SIZEY = 1;                                         //HIDE mode llSetTextureAnim 'SizeY'
float HIDE_START = 1.0;                                         //HIDE mode llSetTextureAnim 'Start'
float HIDE_LENGTH = 1.0;                                        //HIDE mode llSetTextureAnim 'Length'
float HIDE_RATE = 0.06;                                         //HIDE mode llSetTextureAnim 'Rate'
///*END CONFIG*///

default
{
    state_entry()
    {
        //These have to be set in State Entry because Operations cannot be done from the Global Variables directly.
        
        ///BEGIN CONFIG2//
        SHOW_MODE = ANIM_ON|SMOOTH|LOOP;                        //SHOW mode llSetTextureAnim 'Mode'
        HIDE_MODE = FALSE;                                      //HIDE mode llSetTextureAnim 'Mode'
        //*END CONFIG2*//
    }
    link_message(integer Sender, integer Num, string Str, key ID)
    {
        if(ID == "WEAPONSTATE")
        {
            if(Str == "SHOW")
            {
                if(THISPRIM_TEXANIM) { llSetTextureAnim(SHOW_MODE,SHOW_FACE,SHOW_SIZEX,SHOW_SIZEY,SHOW_START,SHOW_LENGTH,SHOW_RATE); }
                if(THISPRIM_ALPHA) { llSetAlpha(HIDE_ALPHA,ALL_SIDES); }
                list PrimitiveParams = [];
                if(THISPRIM_GLOW) { PrimitiveParams += [PRIM_GLOW,ALL_SIDES,SHOW_GLOWVAL]; }
                if(PrimitiveParams != []) { llSetPrimitiveParams(PrimitiveParams); }
            }
            else if(Str == "HIDE")
            {
                if(THISPRIM_TEXANIM) { llSetTextureAnim(HIDE_MODE,HIDE_FACE,HIDE_SIZEX,HIDE_SIZEY,HIDE_START,HIDE_LENGTH,HIDE_RATE); }
                if(THISPRIM_ALPHA) { llSetAlpha(HIDE_ALPHA,ALL_SIDES); }
                list PrimitiveParams = [];
                if(THISPRIM_GLOW) { PrimitiveParams += [PRIM_GLOW,ALL_SIDES,HIDE_GLOWVAL]; }
                if(PrimitiveParams != []) { llSetPrimitiveParams(PrimitiveParams); }
            }
        }
    }
}