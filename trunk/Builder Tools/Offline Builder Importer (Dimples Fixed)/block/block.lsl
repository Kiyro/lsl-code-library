// Second Life Offline Builder Importer
// Copyright (C) 2006  Thraxis Epsilon

// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

integer channel;
list rules;

warpPos( vector d ) //R&D by Keknehv Psaltery, ~05/25/2006 
{ 
    if ( d.z > 768 )      //Otherwise we'll get stuck hitting the ceiling 
        d.z = 768; 
    //The number of jumps necessary 
    integer s = (integer)(llVecMag(d-llGetPos())/10)+1; 
    //Try and avoid stack/heap collisions 
    if ( s > 100 )   
        s = 100;    //  1km should be plenty 
    //Solve '2^n=s'    
    integer e = (integer)( llLog( s ) / llLog( 2 ) );      
    rules = [ PRIM_POSITION, d ];  //The start for the rules list 
    integer i; 
    for ( i = 0 ; i < e ; ++i )     //Start expanding the list 
        rules += rules; 
    integer r = s - (integer)llPow( 2, e ); 
    if ( r > 0 )                    //Finish it up 
        rules += llList2List( rules, 0, r * 2 + 1 ); 
    llSetPrimitiveParams(rules);
}



string List2TypeCSV(list input) { // converts a list to a CSV string with type information prepended to each item
    integer     i;
    list        output;
    integer     len;

    len=llGetListLength(input); //this can shave seconds off long lists
    for (i = 0; i < len; i++) {
        output += [llGetListEntryType(input, i)] + llList2List(input, i, i);
    }
    
    return llList2CSV(output);
}

list TypeCSV2List(string inputstring) { // converts a CSV string created with List2TypeCSV back to a list with the correct type information
    integer     i;
    list        input;
    list        output;
    integer     len;

    input = llParseString2List(inputstring,["~"],[]);

    len=llGetListLength(input);
    for (i = 0; i < len; i += 2) {
        if (llList2Integer(input, i) == TYPE_INTEGER) output += (integer)llList2String(input, i + 1);
        else if (llList2Integer(input, i) == TYPE_FLOAT) output += (float)llList2String(input, i + 1);
        else if (llList2Integer(input, i) == TYPE_STRING) output += llList2String(input, i + 1);
        else if (llList2Integer(input, i) == TYPE_KEY) output += (key)llList2String(input, i + 1);
        else if (llList2Integer(input, i) == TYPE_VECTOR) output += (vector)llList2String(input, i + 1);
        else if (llList2Integer(input, i) == TYPE_ROTATION) output += (rotation)llList2String(input, i + 1);
    }
    
    return output;
}


default
{
    on_rez(integer number)
    {
        channel = number;
        llListen(channel,"",NULL_KEY,"");
    }
    
    listen(integer chan,string name, key id, string message)
    {
        if (chan != channel)
            return;

        list param = llParseString2List(message,["="],[]);
        
        if(llList2String(param,0) == "name")
            llSetObjectName(llGetSubString(llList2String(param,1),1,llStringLength(llList2String(param,1)) - 1));
        if(llList2String(param,0) == "description")
            llSetObjectDesc(llGetSubString(llList2String(param,1),1,llStringLength(llList2String(param,1)) - 1));
        if(llList2String(param,0) == "position")
            warpPos((vector)llList2String(param,1));
        if(llList2String(param,0) == "rotation")
            llSetRot((rotation)llList2String(param,1));
        if(llList2String(param,0) == "size")
            llSetPrimitiveParams([PRIM_SIZE,(vector)llList2String(param,1)]);
        if(llList2String(param,0) == "physics")
            llSetPrimitiveParams([PRIM_PHYSICS,llList2Integer(param,1)]);
        if(llList2String(param,0) == "temporary")
            llSetPrimitiveParams([PRIM_TEMP_ON_REZ,llList2Integer(param,1)]);
        if(llList2String(param,0) == "phantom")
            llSetPrimitiveParams([PRIM_PHANTOM,llList2Integer(param,1)]);
        if(llList2String(param,0) == "material")
            llSetPrimitiveParams([PRIM_MATERIAL,llList2Integer(param,1)]);
        if(llList2String(param,0) == "prim")
                llSetPrimitiveParams(TypeCSV2List(llList2String(param,1)));    
        if(llList2String(param,0) == "done")
                llRemoveInventory(llGetScriptName());
    }
}
