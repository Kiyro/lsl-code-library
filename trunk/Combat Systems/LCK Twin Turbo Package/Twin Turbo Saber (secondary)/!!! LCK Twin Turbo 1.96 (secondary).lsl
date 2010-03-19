//END-USER LICENSE AGREEMENT

//I. Terms and Conditions:
//Per the terms and conditions under the GNU General Public License, you may:

//1) Freely modify the source code of this script, so long as those modifications are properly documented within the body of the source code up to and including derivative works based upon this script under the understanding that such works fall under the GPL license. Stand-alone works (animations, sounds, textures, prims, or precompiled modules) designed to operate in conjunction with this script do not fall under this agreement and are not subject to the GPL.

//2) Freely distribute this script to any third party as deemed appropriate for public or private use so long as this notice and a copy of the GNU GPL are included.

//Per the agreement, you may NOT:

//1) Sell modified versions of this script without the express written permission of the original author unless the derivative work uses less than 20% of the original source code.


//II. Warranty Information
//This product comes "as-is" with no express or implied warranty. You may not hold the original author or any authors of derived work accountable for damages associated with the use or modification of this script unless those authors provide a statement of warranty in writing.

//III. Retroactive License.
///The terms and conditions of this script, upon entering into public domain, affect all prior versions of this script that carry the same name. All previous versions of this script, whether written by the original author or others who claim association with said author, now fall under the jurisdiction of the GPL and are subject to the terms and conditions contained therein.

//Please refer to the included GNU GPL license notecard for additional information.

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//LCK 2.0 Twin Turbo
//Derived from LCK 2.0 Opensource by Jora Welesa
//Concept by Hanumi Takakura
//Scripts by Salene Lusch
//Current non LCK standard script meets or exeeds the aproximate of 80%
//This code remains open source. All GNU rules and guidelines must be followed with this code.
//DO NOT SELL THIS KIT AS IS. IF YOU SELL YOUR OWN HILTS AND INCLUDE THIS HILT, YOU MUST SPECIFY AND PROVE BEYOND ANY DOUBT THAT YOU ARE ONLY SELLING YOUR HILT.
//IF YOU SELL YOUR HILT WITH THIS KIT, YOU MUST INCLUDE ALL OF THIS KITS' CONTENTS, INCLUDING ALL GNU LICENSES.

integer spark;
integer saberOn = FALSE;
//vector saberColor;
string style = "basic";
float hum_volume = 0.25; //Volume of hum
float volume = 0.5; //volume of the rest of sounds
float anim_time;

integer trakata = FALSE;

float ST_SPEED         = 45;
float ST_DELAY         = 10;
integer st_next;
string st_item = "Saber throw";
integer st_color = 0xfff;

integer ALL_CONTROLS;
integer BUTTONS;
integer LEFT;
integer RIGHT;

string hum_s;
string ignite_s;
string powerdown_s;
string hit_s;

string ready_a;
string enguard_a;
string sabergrab_a;
string saberthrow_a;

string sleft_a; string sleft_s;
string sright_a; string sright_s;
string sup_a; string sup_s;
string sdown_a; string sdown_s;

string strong1_a; string strong1_s;
string strong2_a; string strong2_s;
string strong3_a; string strong3_s;
string power_a; string power_s;

integer nc_line;
key nc_query;

float length = 1.55; // standart saber lenght
float length_ratio = 1.0;
float length2 = 1.55; // standart saber lenght
float length2_ratio = 1.0;

integer slave = FALSE;

string is_anim(string type) {
    string a = style + "_" + type;
    if (llGetInventoryType(a) == INVENTORY_ANIMATION) 
        return a;
    else
        return "basic_" + type;
}

string is_sound(string type) {
    string s = "SND_" + style + "_" + type;
    if (llGetInventoryType(s) == INVENTORY_ANIMATION) 
        return s;
    else
        return "SND_basic_" + type;
}

integer is_enguard = FALSE;
string newanim_replay ;

enguard() {
    llStopAnimation(ready_a);
    llStartAnimation(enguard_a);
    is_enguard = TRUE;
}

integer lastlevel = 0;

play(string anim, string sound, integer level) {
    if (is_enguard) {
        llStopAnimation(enguard_a);
        is_enguard = FALSE;
    }
    if (llGetTime()>anim_time)
        lastlevel = -1;
    if (level > lastlevel ) {
        llSensor("","",AGENT | ACTIVE,1.5,PI / 4);
        llStartAnimation(anim);
        llTriggerSound(sound,volume);
        llResetTime();
        level = lastlevel;
    } 
    //llSetTimerEvent(0.25);
}

vector color(string c) {
    c = llStringTrim(c, STRING_TRIM);
    if (c=="red") return <1.0, 0.0, 0.0>;
    else if (c == "green") return <0.0, 1.0, 0.0>;
    else if (c == "blue") return <0.0, 0.0, 1.0>;
    else if (c== "white") return <1.0, 1.0, 1.0>;
    else if (c== "purple") return <1.0, 0.0, 1.0>;
    else if (c== "yellow") return <1.0, 1.0, 0.0>;
    else if (c== "cyan") return <0.0, 1.0, 1.0>;
    else if (c== "pink") return <255,105,180>/255;
    
    if (llSubStringIndex(c, "<")>=0) {
        vector c1=(vector)c;
        return (vector)c;
    }
    list l = llParseString2List(c, [",", " "], []);
    if (llGetListLength(l) == 3) {
        return <llList2Integer(l,0), llList2Integer(l,1), llList2Integer(l,2)>/255;
    }
    return <0.5,0.5,0.5>; // grey
}


throw_color(vector color) {
    color = color * 16 - <1.0, 1.0, 1.0>;
    integer c;
    integer res = 0;
    c = llRound(color.z); if (c<0) c = 0;
    st_color = c;
    c = llRound(color.y); if (c<0) c = 0;
    st_color +=c*16;
    c = llRound(color.x); if (c<0) c = 0;
    st_color += c*256;
}
integer blade1;
integer blade2;

blade(integer b1, integer b2) {
    integer up = FALSE;
    integer down = FALSE;
    if(b1) {
        if (b1>0) {
            if (!trakata) {
                llMessageLinked(LINK_SET,0,"ON",NULL_KEY);
                if (!blade1) up = TRUE;
            }
            blade1=TRUE;
        } else if (b1<0) {
            llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
            if (blade1) down = TRUE;
            blade1=FALSE;
        }
    }
    if(b2) {
        if (b2>0) {
            if (!trakata) {
                llMessageLinked(LINK_SET,0,"ON2",NULL_KEY);
                if (!blade2) up =TRUE;
            }
            blade2=TRUE;
        } else if (b2<0){
            llMessageLinked(LINK_SET,0,"OFF2",NULL_KEY);
            if (blade2) down = TRUE;
            blade2=FALSE;
        }
    }
    saberOn = blade1||blade2;
    if (slave) return;
    //llOwnerSay((string)up + (string)down);
    if (!trakata) {
        if (up) {
            llTriggerSound(ignite_s,volume);
           // llOwnerSay("up");
        }
        if (down) {
            llTriggerSound(powerdown_s,volume);
           // llOwnerSay("down");
        }
    }
    if (saberOn) {
        if (!trakata)
            llLoopSound(hum_s,hum_volume);
    } else
        llStopSound();
}

saber_hidden() {
    if (!slave)
        llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
    llMessageLinked(LINK_SET,0,"OFF2",NULL_KEY);
    llSetLinkAlpha(LINK_SET,0.0,ALL_SIDES);
}

saber_shown() {
    llSetLinkAlpha(LINK_SET,1.0,ALL_SIDES);
}

saber_length() {
    blade(1,0);
    llMessageLinked(LINK_SET,0,"LENG1 " + (string)(length*length_ratio), NULL_KEY);
}

saber_length2() {
    blade(0,1);
    llMessageLinked(LINK_SET,0,"LENG2 " + (string)(length2*length2_ratio), NULL_KEY);
}


default {
    state_entry() {
        ALL_CONTROLS= CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_UP | CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT | CONTROL_DOWN;
        BUTTONS = CONTROL_LBUTTON | CONTROL_ML_LBUTTON;
        RIGHT = CONTROL_RIGHT | CONTROL_ROT_RIGHT;
        LEFT = CONTROL_ROT_LEFT | CONTROL_LEFT;
        saber_hidden();
        llStopSound();
        if (!slave && llGetAttached()) {
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        }
        saberOn = FALSE;
        llSetLinkAlpha(LINK_SET,0.0,ALL_SIDES);
        state newstyle;
    }
}

state rerun {
    state_entry() {
        state run;
    }
}

state run {
    on_rez(integer params) {
        if (llGetLinkNumber()>1) // only run in the root prim
                llSetScriptState(llGetScriptName(),FALSE);
        if(llGetAttached() == 0) {
            llSetLinkAlpha(LINK_SET,1.0,ALL_SIDES);
            llMessageLinked(LINK_SET,0,"ON",NULL_KEY);
            llMessageLinked(LINK_SET,0,"ON2",NULL_KEY);
            llSetRot(ZERO_ROTATION);
        }
    }
    state_entry() {
        slave =  (llSubStringIndex(llGetScriptName(), "secondary")>=0);
        
        llListen(99,"LCK TT HUD "+ llKey2Name(llGetOwner()), NULL_KEY, "");
        llListen(99,"", llGetOwner(), "");
    }
    changed(integer change) {
        if (change & CHANGED_OWNER) {
            state rerun;
        }
        if (change & CHANGED_INVENTORY) {
            slave =  (llSubStringIndex(llGetScriptName(), "secondary")>=0);
        }
        if (change & CHANGED_LINK) {
            if (llGetLinkNumber()>1) // only run in the root prim
                llSetScriptState(llGetScriptName(),FALSE);
        }
    }

    attach(key attached) {
        if(attached) {
            llSetStatus(STATUS_BLOCK_GRAB,TRUE);
            blade1=blade2=-1; //blades(-1,-1);
            saberOn=FALSE;
            llStopSound();
            saber_hidden();
            
        } else {
            if (!slave) {
                if (llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) {
                    llStopAnimation(ready_a);
                    llStopAnimation(enguard_a);
                    is_enguard = FALSE;
                }
            }
            saber_hidden();
            llStopSound();
        }
    }
    run_time_permissions(integer perms) {
        if (slave) return; // should never happens
        if(perms & PERMISSION_TAKE_CONTROLS) {
            llTakeControls(BUTTONS, TRUE, TRUE);
        }
    }
        
    listen( integer channel, string name, key id, string msg ) {
        if(llGetOwnerKey(id) == llGetOwner()) {
            string lower = llToLower(msg);

            if( lower == "saberthrow") {
                if (slave) return;
                if(saberOn) {
                    if (llGetUnixTime() < st_next)
                        llOwnerSay("Must wait for force recharge!");
                    else
                        state saberthrow;
                }
            } 
            else if(lower == "help") {
                if (slave) return;
                llGiveInventory(llGetOwner(),"Twin Turbo manual");
            } else if (lower == "draw") {
                saber_shown();
            } else if (lower == "draw1") {
                if (!slave)
                    saber_shown();
            } else if (lower == "draw2") {
                if (slave)
                    saber_shown();
            } else if (lower == "sheath") {
                saber_hidden();
            } else if (lower == "sheath1") {
                if (!slave)
                    saber_hidden();
            }else if (lower == "sheath2") {
                if (slave)
                    saber_hidden();
            } else if(lower == "on1") {
                if (slave) return;
                llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
                llStartAnimation("hip anim"); 
                saber_shown();
                blade(1,0);
                llTakeControls(BUTTONS, TRUE, TRUE);
                llStartAnimation(ready_a);          
            } else if(lower == "twin on" || lower == "on") {
                if (!slave) {
                    llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
                    llStartAnimation("hip anim 3");
                }
                blade(1,1);
                saber_shown();
                if (slave) return;
                llTakeControls(BUTTONS, TRUE, TRUE);
                llStartAnimation(ready_a);          
            } else if(lower == "off1") {
                if (!slave) {
                    llStopAnimation(ready_a);
                    llStartAnimation("hip anim");
                }
                blade(-1,-1);
                saber_hidden();
                if (slave) return;
                llReleaseControls(); 
            } else if(lower == "twin off"||lower == "off") {
                if (!slave) {
                    llStopAnimation(ready_a);
                    llStartAnimation("hip anim 3");
                }
                blade(-1,-1);
                saber_hidden();
                if (slave) return;
                llReleaseControls();
            } else if(lower == "on2") {
                blade(0,1);
                if (slave)
                    saber_shown();
            } else if(lower == "off2") {
                blade(0,-1);
                if (slave)
                    saber_hidden();
            } else if(lower == "shoto") {
                if (saberOn &&!slave)
                    llTriggerSound(ignite_s,volume);
                length = 0.60;
                length2 = 0.60;
                saber_length2();
                saber_length();
                st_item = "Shoto throw";
            } else if(lower == "standard") {
                if (saberOn&&!slave)
                    llTriggerSound(ignite_s,volume);
                length = 1.30;
                saber_length();
                length2 = 1.30;
                saber_length2();
                st_item = "Saber throw";
            } else if(lower == "shoto1") {
                if (slave) return;
                if (saberOn)
                    llTriggerSound(ignite_s,volume);
                length = 0.60;
                saber_length();
                st_item = "Shoto throw";
            } else if(lower == "standard1") {
                if (slave) return;
                if (saberOn)
                    llTriggerSound(ignite_s,volume);
                length = 1.30;
                saber_length();
                st_item = "Saber throw";
            } else if(lower == "shoto2") {
                if (!slave && saberOn)
                    llTriggerSound(ignite_s,volume);
                length2 = 0.60;
                saber_length2();
            } else if(lower == "standard2") {
                if (!slave && saberOn)
                    llTriggerSound(ignite_s,volume);
                length2 = 1.30;
                saber_length2();
            }else if(llGetSubString(lower,0,5) == "color1") {
                if (slave) return;
                vector saberColor = color(llGetSubString(lower,7,-1));
                throw_color(saberColor);
                llMessageLinked(LINK_SET,0,"COL01 " + (string)saberColor,NULL_KEY);
            } else if(llGetSubString(lower,0,5) == "color2") {
                vector saberColor = color(llGetSubString(lower,7,-1));
                llMessageLinked(LINK_SET,0,"COL02 " + (string)saberColor,NULL_KEY);
            } else if(llGetSubString(lower,0,4) == "color") {
                vector saberColor = color(llGetSubString(lower,6,-1));
                throw_color(saberColor);
                llMessageLinked(LINK_SET,0,"COL01 " + (string)saberColor,NULL_KEY);
                llMessageLinked(LINK_SET,0,"COL02 " + (string)saberColor,NULL_KEY);
            } else if(llGetSubString(lower,0,4) == "style") {
                if (slave) return;
                style = llGetSubString(msg,6,-1);
                state newstyle;
            } else if (llGetSubString(lower,0,4) == "glow2") {
                float g = (float)llGetSubString(msg,6,-1);
                if (g>=0)
                    llMessageLinked(LINK_SET,0,"GLOW2 " + (string)g,NULL_KEY);
            } else if (llGetSubString(lower,0,4) == "glow1") {
                float g = (float)llGetSubString(msg,6,-1);
                if (g>=0)
                    llMessageLinked(LINK_SET,0,"GLOW1 " + (string)g,NULL_KEY);
            } else if (llGetSubString(lower,0,3) == "glow") {
                float g = (float)llGetSubString(msg,5,-1);
                if (g>=0) {
                    llMessageLinked(LINK_SET,0,"GLOW2 " + (string)g,NULL_KEY);
                    llMessageLinked(LINK_SET,0,"GLOW1 " + (string)g,NULL_KEY);
                }
            } else if (llGetSubString(lower,0,6) == "length2") {
                integer l = (integer)llGetSubString(msg,8,-1);
                if (l>=-35 && l<=35) {
                    length2_ratio = 1 + l*0.01;
                    saber_length2();
                }
            } else if (llGetSubString(lower,0,6) == "length1") {
                if (slave) return;
                integer l = (integer)llGetSubString(msg,8,-1);
                if (l>=-35 && l<=35) {
                    length_ratio = 1 + l*0.01;
                    saber_length();
                }
            }else if (llGetSubString(lower,0,5) == "length") {
                integer l = (integer)llGetSubString(msg,7,-1);
                if (l>=-35 && l<=35) {
                    length_ratio = length2_ratio = 1 + l*0.01;
                    saber_length(); saber_length2();
                }                
            } else if (llGetSubString(lower,0,5) == "pulse2") {
                float d = (float)llGetSubString(msg,7,-1) * 0.01;
                llMessageLinked(LINK_SET,0,"PULS2 " + (string)d,NULL_KEY);
            } else if (llGetSubString(lower,0,5) == "pulse1") {
                float d = (float)llGetSubString(msg,7,-1) * 0.01;
                llMessageLinked(LINK_SET,0,"PULS2 " + (string)d,NULL_KEY);
            } else if (llGetSubString(lower,0,4) == "pulse") {
                float d = (float)llGetSubString(msg,6,-1) * 0.01;
                llMessageLinked(LINK_SET,0,"PULS1 " + (string)d,NULL_KEY);
                llMessageLinked(LINK_SET,0,"PULS2 " + (string)d,NULL_KEY);
            } else if (llGetSubString(lower,0,8) == "diameter1") {
                if (slave) return;
                float d = (float)llGetSubString(msg,9,-1) * 0.001;
                if (d>=0.001)
                    llMessageLinked(LINK_SET,0,"DIAM1 " + (string)d,NULL_KEY);
            } else if (llGetSubString(lower,0,8) == "diameter2") {
                float d = (float)llGetSubString(msg,10,-1) * 0.001;
                if (d>=0.001)
                    llMessageLinked(LINK_SET,0,"DIAM2 " + (string)d,NULL_KEY);
            } else if (llGetSubString(lower,0,7) == "diameter") {
                float d = (float)llGetSubString(msg,9,-1) * 0.001;
                if (d>=0.001) {
                    llMessageLinked(LINK_SET,0,"DIAM1 " + (string)d,NULL_KEY);
                    llMessageLinked(LINK_SET,0,"DIAM2 " + (string)d,NULL_KEY);
                }
            } else if( msg == "cal on" ) {
                llSetTexture("3952f1f1-2211-f71a-3aa8-79f08378ddfa",ALL_SIDES);
            } else if( msg == "cal off") {
                    llSetTexture("9b9ea0f8-c212-4e93-d0ef-4d2042b5ecfa",ALL_SIDES);
            } else if(lower == "spark") {
                spark = TRUE;
            } else if(lower == "spark off") {
                spark = FALSE;
            }    
        }
    }
    control(key id,integer held,integer change) {
        if(held & BUTTONS) {
            integer pressed = change & held;
            integer released = change & ~ held;
            
            if (pressed & BUTTONS) {
                llTakeControls(ALL_CONTROLS, TRUE, TRUE);
                enguard();
                if (trakata) {
                    if (blade1)
                        llMessageLinked(LINK_SET,0,"ON",NULL_KEY);
                    if (blade2)
                        llMessageLinked(LINK_SET,0,"ON2",NULL_KEY);
                    llLoopSound(hum_s,hum_volume);
                    llTriggerSound(ignite_s,volume);
                }
            } else if (released & CONTROL_FWD) {
                if(released & CONTROL_BACK) {
                    play(strong2_a, strong2_s, 2);
                } else if(released & LEFT) {
                    play(strong3_a, strong3_s, 2);
                } else if(released & RIGHT) {
                    play(strong1_a, strong1_s, 2);
                }
            } else if((released & LEFT) && (released & RIGHT)) {
                play(power_a, power_s, 3);
            } else if(pressed & LEFT) {
                play(sleft_a, sleft_s, 1);
            } else if(pressed & RIGHT) {
                play(sright_a, sright_s, 1);   
            } else if(pressed & CONTROL_FWD) {
                play(sup_a, sup_s, 1);
            } else if(pressed & CONTROL_BACK) {
                play(sdown_a, sdown_s, 1);
            }  else {
                enguard();
            }
        } else {
            llStopAnimation(enguard_a); is_enguard= FALSE;
            llStartAnimation(ready_a);
            llTakeControls(BUTTONS, TRUE, TRUE);
            if (trakata) {
                if (blade1)
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                if (blade2)
                    llMessageLinked(LINK_SET,0,"OFF2",NULL_KEY);
                llStopSound();
                llTriggerSound(powerdown_s,volume);
            }
        }

    }
//    timer() {
//        llSetTimerEvent(0.0);
//        llSensor("","",AGENT | ACTIVE,1.5,PI / 4);
//    }
    sensor(integer num)
    {

        llTriggerSound("hit",volume);
        if(spark)
        {
            if (llFrand(1.0)<0.5)
                llMessageLinked(LINK_SET,0,"spark",NULL_KEY);
        }
    }
}

state saberthrow {
    state_entry() {
        if (! (llGetAttached() & (ATTACH_RHAND | ATTACH_LHAND) ) )
            return;
        if (trakata) {
           llMessageLinked(LINK_SET, 0, "ON", NULL_KEY); 
        }
        llSetTimerEvent(0.0);
        llSetLinkAlpha(LINK_SET,0.0,ALL_SIDES);
        llStartAnimation(saberthrow_a);
        llStopAnimation(ready_a);
        llStopAnimation(enguard_a); is_enguard = FALSE;
        llStopSound();
        llMessageLinked(LINK_SET, 0, "OFF", NULL_KEY);
        if(blade2)
            llMessageLinked(LINK_SET, 0, "OFF2", NULL_KEY);  
        llSetLinkAlpha(LINK_SET,0.0,ALL_SIDES);
        rotation rot = llGetRot();
        vector front = llRot2Fwd(rot);
        
        st_next = llGetUnixTime() + 10;
        llRezObject(st_item, llGetPos() + <0.0,0.0,0.75> +  front , ST_SPEED * front , rot, 0x1000 + st_color);
        llSetTimerEvent(4.0);
    }
    timer() {
        state run;
    }
    state_exit() {
        llSetLinkAlpha(LINK_SET,1.0,ALL_SIDES);
        llMessageLinked(LINK_SET, 0, "ON", NULL_KEY);
        if (blade2)
           llMessageLinked(LINK_SET, 0, "ON2", NULL_KEY); 
        llStartAnimation(sabergrab_a);
        llStartAnimation(ready_a);
        llLoopSound(hum_s,hum_volume);
    }
}

state newstyle {
    state_entry() {
        
        if (saberOn) {
            newanim_replay = ready_a;
        } else {
            newanim_replay = "";
        }
        
        hum_s = "hum";
        ignite_s = "ignite";
        powerdown_s = "powerdown";
        hit_s = "hit";
        
        ready_a = is_anim("ready");
        enguard_a = is_anim("enguard");
        saberthrow_a =  "saberthrow";
        sabergrab_a = "sabergrab";
        
        sleft_a=is_anim("sleft");
        sright_a=is_anim("sright");
        sup_a=is_anim("sup");
        sdown_a=is_anim("sdown");
        strong1_a=is_anim("strong1");
        strong2_a=is_anim("strong2");
        strong3_a=is_anim("strong3");
        power_a=is_anim("power");

        sleft_s=is_sound("sleft");
        sright_s=is_sound("sright");
        sup_s=is_sound("sup");
        sdown_s=is_sound("sdown");
        strong1_s=is_sound("strong1");
        strong2_s=is_sound("strong2");
        strong3_s=is_sound("strong3");
        power_s=is_sound("power");

        anim_time = 0.25;

        if (llGetInventoryType("style_" + style) != INVENTORY_NOTECARD) {
            state run;
        }
        nc_line = 0;
        nc_query = llGetNotecardLine("style_" + style, nc_line);
    }
    
    
    state_exit() {
        if (newanim_replay != "") {
            llStopAnimation(newanim_replay);
            llStartAnimation(ready_a);
        }
    }
    dataserver(key query_id, string data) {
        if (query_id == nc_query) {
            if (data == EOF) {
                llOwnerSay("Style "+style+" loaded");
                state run;
            }
            if ((data != "") && (llGetSubString(data, 0, 0) != "#")) {
                integer idx = llSubStringIndex(data, ":");
                if (idx>1) {
                    string k = llGetSubString(data, 0, idx-1);
                    if (k == "delay") {
                        anim_time = (float)llGetSubString(data, idx+1, -1);
                        jump next;
                    }
                    list opts = llParseString2List(llGetSubString(data, idx+1, -1), [" "], []);
                    string anim=""; string sound="";
                    integer l = llGetListLength(opts);
                    while(--l>=0) {
                        string value = llList2String(opts, l);
                        integer type = llGetInventoryType(value);
                        if (type == INVENTORY_ANIMATION)
                            anim = value;
                        else if (type = INVENTORY_SOUND)
                            sound = value;
                    }
                    if ( k == "sleft") { if (anim != "") sleft_a = anim; if (sound != "") sleft_s = sound; }
                    else if ( k == "sright") { if (anim != "") sright_a = anim; if (sound != "") sright_s = sound; }
                    else if ( k == "sup") { if (anim != "") sup_a = anim; if (sound != "") sup_s = sound; }
                    else if ( k == "sdown") { if (anim != "") sdown_a = anim; if (sound != "") sdown_s = sound; }
                    else if ( k == "strong1") { if (anim != "") strong1_a = anim; if (sound != "") strong1_s = sound; }
                    else if ( k == "strong2") { if (anim != "") strong2_a = anim; if (sound != "") strong2_s = sound; }
                    else if ( k == "strong3") { if (anim != "") strong3_a = anim; if (sound != "") strong3_s = sound; }
                    else if ( k == "power") { if (anim != "") power_a = anim; if (sound != "") power_s = sound; }
                    else if ( k == "ready") { if (anim != "") ready_a = anim; }
                    else if ( k == "sabergrab") { if (anim != "") sabergrab_a = anim; }
                    else if ( k == "saberthrow") { if (anim != "") saberthrow_a = anim; }
                    else if ( k == "enguard") { if (anim != "") enguard_a = anim;}
                    else if ( k == "hum") { if (sound != "") hum_s = sound; }
                    else if ( k == "ignite") { if (sound != "") ignite_s = sound; }
                    else if ( k == "powerdown") { if (sound != "") powerdown_s = sound; }
                    else if ( k == "hit") { if (sound != "") hit_s = sound; }
 
               }
            }
            @next;
            nc_query = llGetNotecardLine("style_" + style, ++nc_line);
        }
    }
}