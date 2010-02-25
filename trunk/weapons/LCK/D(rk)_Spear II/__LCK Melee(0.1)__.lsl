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

///////////////////////////////////////////////////////////////////////////////////////////////////

//•/•/•/•/•/•/•/Ð/A/M/E/N/•/H/A/X/•/•/•/•/•/•/•/•/•//
//complete overhaul of all scripts & remake of HUD + additional options
//including new touch functions. `0'
//////////////////////////// XXXXXXXXXXXXXXXXXXXX //////////////////////////
// Modified again to remove need for hud; in prep for LL's possible script limit per parcel 0.x
// Now controlled by one script & by menu.
// Remove push switch so can now push & deal damage at the same time, with menu for values.
//////////////////////////// XXXXXXXXXXXXXXXXXXXX //////////////////////////
// modified again =) this version doesnt have fireballs or color change option, change to sounds system also.
// made to be RP friendly, zero push default
//Howto/Info;
// Check the list of globals down below & edit where needed, your own sounds, animations etc.
// Set to play a sound from a list when you hit/sense avatar, another list used for striking (misses)
//RP Info;
// RP places care about sensor range mainly, as you cant have a 5 inch dagger with a 10 meter attack range =)

key Owner;
integer Listen;//listen handle
integer myChannel;//menu channel
float SensorRange = 3;//in meters, how far we detect for avatar when we strike
float pushPower = 0.0;//default push setting
integer Damage = 10;//default damage setting
integer On = FALSE;//define our status so the script knows
string style = "basic";//default animation style
string DamageObject = "*Damage";//object rezd to inflict damage
string HandleName = "Blade";//change prims with this name
// sounds used
float defaultVolume = 1.0;//volume for on & off sound effects
float hitVolume = 1.0;//volume for sound effects
float ambientVolume = 0.05;//lower volume for looped ambient sound
float strikeVolume = 0.15;//volume for the striking sounds
key loopSound = "108366df-4196-c62f-9d50-073361979b82";//ambient sound
key onSound = "b565ed8d-e3ec-383d-d640-3ceeb9bf6957";
key offSound = "be0cd87b-ae95-2fb5-6250-dcdd4d2ce732";

list hitSounds = ["219c5d93-6c09-31c5-fb3f-c5fe7495c115","e057c244-5768-1056-c37e-1537454eeb62"];//list of sounds, allowing diff random hit sound each 'successful' hit
list strikeSounds = ["96aeb4f2-3d59-dd37-cfa9-763614695b61","3a1b668a-0013-7edc-c15e-3e66a57622da"];//list of sounds, allowing diff random sound every strike "9850f8df-c86a-80d9-eca7-d6f12aae6f9e"
hitSound(){list dList = llListRandomize(hitSounds, 1);
    llTriggerSound(llList2String(dList, 0), hitVolume);
}
strikeSound(){list dList = llListRandomize(strikeSounds, 1);
    llTriggerSound(llList2String(dList, 0), strikeVolume);
}
//menu lists & guts
list MainButtons = ["Power •OFF•","<<•>>","Power •ON•","Hide Blade","||","Show Blade","Hide","||","Show","•>>","Options","<<•"]; 
list OptionButtons = ["<<Back","Damage","Push","Anim •OFF•","Anim Style","Anim •ON•","Practice","Default","Killer!!"];
list DamageButtons = ["<<<<","0","10","20","30","40","50","60","70","80","90","100"];
list PushButtons = ["<<<<","0.0","333","555","777","999","3333","5555","7777","9999","1000000","!!Push!!"];
list AnimStyleButtons = ["<<<<","•","•","basic","•","strong"];

MainMenu(){llListenRemove(Listen);
    Listen = llListen(myChannel,"","","");
    llDialog(Owner,"
*Hide Blade & Show Blade control visibility of the blades only.
*Hide & Show control visibility of your weapon.
*Options will open a sub menu with damage, push & other core controls.",MainButtons,myChannel);   
}
OptionMenu(){
    llDialog(Owner,"
*Anim ON & Anim OFF will also toggle your ability to strike.
*Damage will open a sub menu controlling the damage level.
    ",OptionButtons,myChannel);   
}
DamageMenu(){
    llDialog(Owner,"
NOTE; Damage has no effect on RP systems, they work by collision so damage setting has NO EFFECT. This is for damage enabled land only.
    
*These options control how much damage you deal with each successfull strike.",DamageButtons,myChannel);   
}
PushMenu(){
    llDialog(Owner,"
*These options control how much force you strike your target with; Effecting how far you push the target.
*!!Push!! is maxint aka max value allowed.",PushButtons,myChannel);   
}
AnimStyleMenu(){
    llDialog(Owner,"
*These two options control what style animations are played when you strike.",AnimStyleButtons,myChannel);   
}
//function for handling only prim with certain name, defined as HandleName
Hide(){integer i;
    for (i = llGetNumberOfPrims(); i > 0; --i){
        if (llGetLinkName(i) == HandleName){
            llSetLinkPrimitiveParams(i,[PRIM_COLOR, ALL_SIDES, llGetColor(0), 0.0,PRIM_GLOW, ALL_SIDES, 0.0]); 
        }
    }
}
Show(){integer i;
    for (i = llGetNumberOfPrims(); i > 0; --i){
        if (llGetLinkName(i) == HandleName){
            llSetLinkPrimitiveParams(i,[PRIM_COLOR, ALL_SIDES, llGetColor(0), 1.0,PRIM_GLOW, ALL_SIDES, 0.15 ]); 
        }
    }
}
//Enter the code~
default{
    state_entry(){
        Owner = llGetOwner();
        myChannel = (integer)llFrand(DEBUG_CHANNEL) * -1;
        llStopSound();
    }
//
    on_rez(integer params){vector color = llGetColor(0);
        float RedRandom = llFrand(255)/255*(PI/color.z);
        float GreenRandom = llFrand(255)/255*(PI/color.y);
        float BlueRandom = llFrand(255)/255*(PI/color.x);
        llSetLinkColor(LINK_SET,<RedRandom,GreenRandom,BlueRandom>,ALL_SIDES);
        llResetScript();
    }
//
    touch_start(integer t){
        if(llDetectedKey(0) == Owner){MainMenu();
        }
        else{//do this if someone other than owner touches
            llTriggerSound("a90bb691-2940-c75e-c2b3-3cb1a1588651",0.5);
            llInstantMessage(llDetectedKey(0),"Sorry "+llDetectedName(0)+".. Access Denied;");
        }  
    }
//
    attach(key attached){
        if(attached == llGetOwner()){llSetStatus(STATUS_BLOCK_GRAB,TRUE);
            llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
        }
    }
//
    run_time_permissions(integer perms){
        if(perms & PERMISSION_TAKE_CONTROLS){
            llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_UP | CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT | CONTROL_DOWN, TRUE, TRUE);
        }
    }
//    
    listen( integer channel, string name, key id, string msg ){
        if(llGetOwnerKey(id) == Owner && channel == myChannel){
            if(msg == "<<<<"||msg=="•"){OptionMenu();
                return;
            }
            else if (llListFindList(AnimStyleButtons, [msg]) != -1){style = msg;
                llOwnerSay("/me >> New Style Accepted : "+msg+" :");
                return;
            }
            else if (llListFindList(DamageButtons, [msg]) != -1){
                Damage = (integer)msg;
                llOwnerSay("/me >> New Damage Setting Accepted : "+msg+" :
                    PushForce : "+(string)pushPower+" 
                    Damage    : "+(string)Damage+"%");
                return;
            }
            else if (llListFindList(PushButtons, [msg]) != -1){
                if(msg == "!!Push!!"){
                    pushPower = (float)2147483647.0;
                }
                else{pushPower = (float)msg;
                    llOwnerSay("/me >> New Push Force Setting Accepted : "+msg+" :
                    PushForce : "+(string)pushPower+" 
                    Damage    : "+(string)Damage+"%");
                return;
                }
            }
            else if(msg == "<<Back"){MainMenu();
            }
            else if(msg == "Options"){OptionMenu();
            }
            else if(msg == "Damage"){DamageMenu();
            }
            else if(msg == "Anim Style"){AnimStyleMenu();
            }
            else if(msg == "Push"){PushMenu();
            }
            else if(msg == "Hide"){llSetLinkAlpha(LINK_SET,0.0,ALL_SIDES);
            }
            else if(msg == "Show"){llSetLinkAlpha(LINK_SET,1.0,ALL_SIDES);
            }
            else if(msg == "Hide Blade"){Hide();
            }
            else if(msg == "Show Blade"){Show();
            }
            else if(msg == "Practice"){Damage = 1;pushPower = 0.0;
                llOwnerSay("/me >> New Setting Accepted : "+msg+" Mode :
                PushForce : "+(string)pushPower+"
                Damage    : "+(string)Damage+"%");
            }
            else if(msg == "Default"){Damage = 10;pushPower = 1.0;
                llOwnerSay("/me >> New Setting Accepted : "+msg+" Mode :
                PushForce : "+(string)pushPower+" 
                Damage    : "+(string)Damage+"%");
            }
            else if(msg == "Killer!!"){Damage = 100;pushPower = 1.0;
                llOwnerSay("/me >> New Setting Accepted : "+msg+" Mode :
                PushForce : "+(string)pushPower+" 
                Damage    : "+(string)Damage+"%");
            }
            else if(msg == "Power •ON•"){On = TRUE;
                Show();
                llTriggerSound(onSound,defaultVolume);
                llLoopSound(loopSound,ambientVolume);// ambient hum
                llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
                llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_UP | CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT | CONTROL_DOWN, TRUE, TRUE);
                llStartAnimation(style + "_ready");   
                llOwnerSay("/me >> "+msg);        
            }
            else if(msg == "Power •OFF•"){On = FALSE;
                llTriggerSound(offSound,defaultVolume);
                llStopSound();
                llReleaseControls();
                llStopAnimation(style + "_ready");
                llOwnerSay("/me >> "+msg);
                Hide();
            }
            else if(msg == "Anim •OFF•"){
                llReleaseControls();
                llStopAnimation(style + "_ready");
                llOwnerSay("/me >> "+msg);
            }
            else if(msg == "Anim •ON•"){
                if(On == TRUE){
                    llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
                    llStartAnimation(style + "_ready");
                    llOwnerSay("/me >> "+msg);
                }
            }
            else{return;
            }
        }
    }
//
    control(key id,integer held,integer change){
        if(held&CONTROL_LBUTTON||held&CONTROL_ML_LBUTTON){
            llStopAnimation(style + "_ready");
            llStartAnimation(style + "_enguard");
            if((change&held&CONTROL_ROT_LEFT)|(change&~held&CONTROL_LEFT)){
                llStopAnimation(style + "_enguard");
                strikeSound();
                llStartAnimation(style + "_sleft");
                llSetTimerEvent(0.25);
            }
            if((change&held&CONTROL_ROT_RIGHT)|(change&~held&CONTROL_RIGHT)){
                llStopAnimation(style + "_enguard");
                strikeSound();
                llStartAnimation(style + "_sright");
                llSetTimerEvent(0.25);
            }
            if(change&held&CONTROL_FWD){
                llStopAnimation(style + "_enguard");
                strikeSound();
                llStartAnimation(style + "_sup");
                llSetTimerEvent(0.25);
            }
            if(change&held&CONTROL_BACK){
                llStopAnimation(style + "_enguard");
                strikeSound();
                llStartAnimation(style + "_sdown");
                llSetTimerEvent(0.25);
            }
            if((change&~held&CONTROL_BACK)&&(change&~held&CONTROL_FWD)){
                llStopAnimation(style + "_enguard");
                strikeSound();
                llStartAnimation(style + "_strong2");
                llSetTimerEvent(0.25);
            }
            if((change&~held&CONTROL_FWD)&&((change&~held&CONTROL_LEFT)||(change&~held&CONTROL_ROT_LEFT))){
                llStopAnimation(style + "_enguard");
                strikeSound();
                llStartAnimation(style + "_strong3");
                llSetTimerEvent(0.25);
            }
            if((change&~held&CONTROL_FWD)&&((change&~held&CONTROL_RIGHT)||(change&~held&CONTROL_ROT_RIGHT))){ 
                llStopAnimation(style + "_enguard");
                strikeSound();
                llStartAnimation(style + "_strong1");
                llSetTimerEvent(0.25);
            }
            if(((change&~held&CONTROL_LEFT)||(change&~held&CONTROL_ROT_LEFT))&&((change&~held&CONTROL_RIGHT)||(change&~held&CONTROL_ROT_RIGHT))){
                llStopAnimation(style + "_enguard");
                strikeSound();
                llStartAnimation(style + "_power");
                llSetTimerEvent(0.25);
            }
            llSetDamage(Damage);
        }
        else if(~held&CONTROL_LBUTTON||~held&CONTROL_ML_LBUTTON){
            llStopAnimation(style + "_enguard");
            llStartAnimation(style + "_ready");
            llSetDamage(0);
        }
    }
//
    timer(){llSensor("","",AGENT,SensorRange,PI_BY_TWO);
    }
//
    sensor(integer num){
        if(On == TRUE){
            if(num != 0){
                float distance = llVecDist(llGetPos(),llDetectedPos(0));
                if(distance < 1.0){distance = 1.0;
                }
                float mod = llPow(distance,3.0)+llGetObjectMass(llDetectedKey(0));
                llRezObject(DamageObject,llDetectedPos(0),<0,0,0>,ZERO_ROTATION,Damage);
                hitSound();
                llPushObject(llDetectedKey(0),<-pushPower,0,pushPower> * mod ,ZERO_VECTOR,TRUE);
                //^ if push values are 0, it has no effect; default is zero.
                llSetTimerEvent(0.0);
            }
        }
        else{
        }
    }
//
    no_sensor(){
        llSetTimerEvent(0.0);
    }
}