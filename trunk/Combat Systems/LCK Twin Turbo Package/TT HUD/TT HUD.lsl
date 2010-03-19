/*
   This script is a part of the LCK Twin Turbo HUD
   Copyright 2009 Salene Lusch 

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA

*/

integer width = 4;
integer height =7;
integer half_height = 4;

tt(string message) {
    string name = llGetObjectName();
    llSetObjectName("LCK TT HUD "+ llKey2Name(llGetOwner()));
    llWhisper(99, message);
    //llOwnerSay(message);
    llSetObjectName(name);
}

list buttons = [ 
    "style 5", "style 6", "style 7", "style 8",
    "style 1", "style 2", "style 3", "style 4",
    "standard1", "shoto1", "shoto2", "standard2",
    "color1 blue", "color1 yellow", "color2 yellow", "color2 blue",
    "color1 green", "color1 purple", "color2 purple", "color2 green",
    "color1 red", "color1 cyan", "color2 cyan", "color2 red",
    "off", "on1", "on", "tools"
    ];

list styles;

list default_styles = [
    "basic",
    "strong",
    "basic",
    "strong",
    "basic",
    "strong",
    "basic",
    "strong"
];

string card = "STYLES";
integer cardline ;
key requestid;

integer tool_on = TRUE;
integer face = 4;

switch_tool() {
    vector tscale = llGetTextureScale(face);
    vector scale = llGetScale();
    string texture = llGetTexture(face);
    vector pos = llGetLocalPos();
    rotation rot = llGetLocalRot();
//    llOwnerSay((string)pos);
    integer is_off = (tscale.y < 1.0);
//    if (is_off = off)
//        return;
    integer off = !is_off;
    if (off) {
        float sense = -1.0;
        if (pos.z < -0.5)
            sense = 1.0;
        llSetPrimitiveParams([
            PRIM_SIZE, <0, scale.y, scale.z/height>,
            PRIM_TEXTURE, face, texture, <1.0, 1.0/height, 0>, <0.0, -(float)llCeil(height*0.5)/height,0.0>, 0.0,
            PRIM_POSITION, pos - sense * <0.0,0.0,0.5*scale.z * (height-1)/height>*rot
            ]);
    } else {
        vector offset  = ZERO_VECTOR;
        float sense = -1.0;
        if (pos.z < -0.5) {
            offset.y = -1.0/height;
            sense = 1.0;
        }
        llSetPrimitiveParams([
            PRIM_SIZE, <0, scale.y, scale.z*height>,
            PRIM_TEXTURE, face, texture, <1.0, 1.0, 0>, offset, 0.0,
            PRIM_POSITION, pos + sense * <0.0,0.0,0.5*scale.z*(height-1)>*rot
            ]);
    }
//        llOwnerSay((string)llGetLocalPos());
}

default
{
    
    state_entry() {
        cardline = 0;
        requestid = llGetNotecardLine(card,cardline); 
        styles= default_styles;
    }
    
    dataserver(key id, string data) {
        if (requestid != id)
            return;
        if (data == EOF) {
            return;
        }
        list tmp = llParseString2List(data, ["="], []);
        string cmd = llList2String(tmp,0);
        if (llGetSubString(cmd, 0, 4) == "style") {
            integer n = (integer)llGetSubString(cmd, 5, -1);
            if (n>0) {
                string value = llStringTrim(llList2String(tmp,1), STRING_TRIM);
                styles = llListReplaceList(styles, [value], n-1, n-1);
            }
            requestid = llGetNotecardLine(card,++cardline); 
        }
        
    }
    
    attach(key id) {
        if (id) {
            llSetTimerEvent(0.0);
            llSetAlpha(1.0, face);
            llSetTimerEvent(60.0);
        }
    }
    
    touch_start(integer total_number)
    {
        llSetAlpha(1.0, face);
        llSetTimerEvent(60.0);
        vector uv = llDetectedTouchUV(0);
        integer button = llFloor(uv.x*width) + width * llFloor(uv.y *height);
        string btext=llList2String(buttons, button);
        //llOwnerSay((string)btext);
        if (btext == "")
            return;
        if (btext == "tools") {
            switch_tool();
        } else if (llGetSubString(btext, 0, 5) == "style ") {
            integer nstyle =(integer)llGetSubString(btext, 6, -1);
            string style = llList2String(styles, nstyle-1);
            if (style != "")
                tt("style " + style);
            //llOwnerSay("Switching to saber style " + style);    
        } else {
            tt(btext);
            if (btext == "on1")
                tt("off2");
        }
    }
    
    timer() {
        llSetAlpha(0.5, face);
    }
               
    changed(integer change)
    {
        if (change&CHANGED_INVENTORY)
            llResetScript();
    }
}
