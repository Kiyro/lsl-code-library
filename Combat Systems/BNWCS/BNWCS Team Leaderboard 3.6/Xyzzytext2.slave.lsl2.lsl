//////////////////////////////////////////// 
// XyText v2.0 SLAVE Script (5 Face, Single Texture) 
//
// Modified by Thraxis Epsilon and Gigs Taggart 5/2007
// Rewrite to allow one-script-per-object operation
//
// Modified by Kermitt Quirk 19/01/2006 
// To add support for 5 face prim instead of 3 
// 
// Originally Written by Xylor Baysklef 
// 
//
//////////////////////////////////////////// 
 
 
integer REMAP_INDICES       = 304002; 
integer RESET_INDICES       = 304003;
 
//internal API
integer REGISTER_SLAVE      = 305000;
integer SLAVE_RECOGNIZED    = 305001;
integer SLAVE_DISPLAY       = 305003;
integer SET_FONT_TEXTURE    = 304005; 
 
integer SLAVE_DISPLAY_EXTENDED = 305004;
integer SLAVE_RESET = 305005;
 
 
// This is an extended character escape sequence. 
string  ESCAPE_SEQUENCE = "\\e"; 
 
// This is used to get an index for the extended character. 
string  EXTENDED_INDEX  = "12345"; 
 
// Face numbers. 
integer FACE_1          = 3; 
integer FACE_2          = 7; 
integer FACE_3          = 4; 
integer FACE_4          = 6; 
integer FACE_5          = 1; 
 
 
///////////// GLOBAL VARIABLES /////////////// 
// This is the key of the font we are displaying. 
key     gFontTexture        = "b2e7394f-5e54-aa12-6e1c-ef327b6bed9e"; 
// All displayable characters.  Default to ASCII order. 
string gCharIndex; 
 
integer gActive; //if we are recognized, this is true
/////////// END GLOBAL VARIABLES //////////// 
 
ResetCharIndex() { 
   gCharIndex  = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`"; 
   gCharIndex += "abcdefghijklmnopqrstuvwxyz{|}~"; 
   gCharIndex += "\n\n\n\n\n"; 
} 
 
vector GetGridOffset(integer index) { 
   // Calculate the offset needed to display this character. 
   integer Row = index / 10; 
   integer Col = index % 10; 
 
   // Return the offset in the texture. 
   return <-0.45 + 0.1 * Col, 0.45 - 0.1 * Row, 0.0>; 
} 
 
ShowChars(integer link,vector grid_offset1, vector grid_offset2, vector grid_offset3, vector grid_offset4, vector grid_offset5) { 
   // Set the primitive textures directly. 
 
   // <-0.256, 0, 0> 
   // <0, 0, 0> 
   // <0.130, 0, 0> 
   // <0, 0, 0> 
   // <-0.74, 0, 0> 
 
   llSetLinkPrimitiveParams( link,[ 
        PRIM_TEXTURE, FACE_1, (string)gFontTexture, <0.126, 0.1, 0>, grid_offset1 + <0.037, 0, 0>, 0.0, 
        PRIM_TEXTURE, FACE_2, (string)gFontTexture, <0.05, 0.1, 0>, grid_offset2, 0.0, 
        PRIM_TEXTURE, FACE_3, (string)gFontTexture, <-0.74, 0.1, 0>, grid_offset3 - <0.244, 0, 0>, 0.0, 
        PRIM_TEXTURE, FACE_4, (string)gFontTexture, <0.05, 0.1, 0>, grid_offset4, 0.0, 
        PRIM_TEXTURE, FACE_5, (string)gFontTexture, <0.126, 0.1, 0>, grid_offset5 - <0.037, 0, 0>, 0.0 
        ]); 
} 
 
RenderString(integer link, string str) {
   // Get the grid positions for each pair of characters. 
   vector GridOffset1 = GetGridOffset( llSubStringIndex(gCharIndex, llGetSubString(str, 0, 0)) ); 
   vector GridOffset2 = GetGridOffset( llSubStringIndex(gCharIndex, llGetSubString(str, 1, 1)) ); 
   vector GridOffset3 = GetGridOffset( llSubStringIndex(gCharIndex, llGetSubString(str, 2, 2)) ); 
   vector GridOffset4 = GetGridOffset( llSubStringIndex(gCharIndex, llGetSubString(str, 3, 3)) ); 
   vector GridOffset5 = GetGridOffset( llSubStringIndex(gCharIndex, llGetSubString(str, 4, 4)) ); 
 
   // Use these grid positions to display the correct textures/offsets. 
   ShowChars(link,GridOffset1, GridOffset2, GridOffset3, GridOffset4, GridOffset5); 
} 
 
RenderExtended(integer link, string str) { 
   // Look for escape sequences. 
   list Parsed       = llParseString2List(str, [], [ESCAPE_SEQUENCE]); 
   integer ParsedLen = llGetListLength(Parsed); 
 
   // Create a list of index values to work with. 
   list Indices; 
   // We start with room for 5 indices. 
   integer IndicesLeft = 5; 
 
   integer i = 0; 
   string Token; 
   integer Clipped; 
   integer LastWasEscapeSequence = FALSE; 
   // Work from left to right. 
   for (; i < ParsedLen && IndicesLeft > 0; ++i) { 
       Token = llList2String(Parsed, i); 
 
       // If this is an escape sequence, just set the flag and move on. 
       if (Token == ESCAPE_SEQUENCE) { 
           LastWasEscapeSequence = TRUE; 
       } 
       else { // Token != ESCAPE_SEQUENCE 
           // Otherwise this is a normal token.  Check its length. 
           Clipped = FALSE; 
           integer TokenLength = llStringLength(Token); 
           // Clip if necessary. 
           if (TokenLength > IndicesLeft) { 
               Token = llGetSubString(Token, 0, IndicesLeft - 1); 
               TokenLength = llStringLength(Token); 
               IndicesLeft = 0; 
               Clipped = TRUE; 
           } 
           else 
               IndicesLeft -= TokenLength; 
 
           // Was the previous token an escape sequence? 
           if (LastWasEscapeSequence) { 
               // Yes, the first character is an escape character, the rest are normal. 
 
               // This is the extended character. 
               Indices += (llSubStringIndex(EXTENDED_INDEX, llGetSubString(Token, 0, 0)) + 95); 
 
               // These are the normal characters. 
               integer j = 1; 
               for (; j < TokenLength; ++j) 
                   Indices += llSubStringIndex(gCharIndex, llGetSubString(Token, j, j)); 
           } 
           else { // Normal string. 
               // Just add the characters normally. 
               integer j; 
               for (j = 0; j < TokenLength; ++j) 
                   Indices += llSubStringIndex(gCharIndex, llGetSubString(Token, j, j)); 
           } 
 
           // Unset this flag, since this was not an escape sequence. 
           LastWasEscapeSequence = FALSE; 
       } 
   } 
 
   // Use the indices to create grid positions. 
   vector GridOffset1 = GetGridOffset( llList2Integer(Indices, 0) ); 
   vector GridOffset2 = GetGridOffset( llList2Integer(Indices, 1) ); 
   vector GridOffset3 = GetGridOffset( llList2Integer(Indices, 2) ); 
   vector GridOffset4 = GetGridOffset( llList2Integer(Indices, 3) ); 
   vector GridOffset5 = GetGridOffset( llList2Integer(Indices, 4) ); 
 
   // Use these grid positions to display the correct textures/offsets. 
   ShowChars(link,GridOffset1, GridOffset2, GridOffset3, GridOffset4, GridOffset5); 
} 
 
integer ConvertIndex(integer index) { 
   // This converts from an ASCII based index to our indexing scheme. 
   if (index >= 32) // ' ' or higher 
       index -= 32; 
   else { // index < 32 
       // Quick bounds check. 
       if (index > 15) 
           index = 15; 
 
       index += 94; // extended characters 
   } 
 
   return index; 
} 
 
 
default 
{ 
    state_entry() 
    { 
        // Initialize the character index. 
        ResetCharIndex();
        llMessageLinked(LINK_THIS, REGISTER_SLAVE, llGetScriptName() , NULL_KEY);  
    } 
 
    on_rez(integer num)
    {
        llResetScript();       
    }
 
    link_message(integer sender, integer channel, string data, key id) 
    { 
 
        if (channel == SLAVE_RECOGNIZED)
        {
            if (data == llGetScriptName())
            {
                gActive=TRUE;
            }
            return;
        }
 
        if (channel == SLAVE_DISPLAY) 
        { 
            if (!gActive)  
                return;
 
            list params=llCSV2List((string)id);
            if (llList2String(params, 1) != llGetScriptName())
                return;
 
 
            RenderString(llList2Integer(params, 0),data);
            return; 
        } 
 
       if (channel == SLAVE_DISPLAY_EXTENDED) 
       {
            if (!gActive)  
                return;
 
            list params=llCSV2List((string)id);
            if (llList2String(params, 1) != llGetScriptName())
                return;
 
            RenderExtended(llList2Integer(params, 0),data);
       } 
 
        if (channel == SET_FONT_TEXTURE) 
        { 
           gFontTexture = id; 
           return; 
        } 
 
        if (channel == REMAP_INDICES) { 
           // Parse the message, splitting it up into index values. 
           list Parsed = llCSV2List(data); 
           integer i; 
           // Go through the list and swap each pair of indices. 
           for (i = 0; i < llGetListLength(Parsed); i += 2) { 
               integer Index1 = ConvertIndex( llList2Integer(Parsed, i) ); 
               integer Index2 = ConvertIndex( llList2Integer(Parsed, i + 1) ); 
 
               // Swap these index values. 
               string Value1 = llGetSubString(gCharIndex, Index1, Index1); 
               string Value2 = llGetSubString(gCharIndex, Index2, Index2); 
 
               gCharIndex = llDeleteSubString(gCharIndex, Index1, Index1); 
               gCharIndex = llInsertString(gCharIndex, Index1, Value2); 
 
               gCharIndex = llDeleteSubString(gCharIndex, Index2, Index2); 
               gCharIndex = llInsertString(gCharIndex, Index2, Value1); 
           } 
           return; 
        } 
        if (channel == RESET_INDICES) { 
           // Restore the character index back to default settings. 
           ResetCharIndex(); 
           return; 
        } 
 
 
        if (channel == SLAVE_RESET)
        {
            ResetCharIndex();
            gActive=FALSE;
            llMessageLinked(LINK_THIS, REGISTER_SLAVE, llGetScriptName() , NULL_KEY);
        }
 
    } 
 
 
} 