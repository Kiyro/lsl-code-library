list mainmenu = ["On", "Both On", "Off", "Throw", "1 Color", "2 Color", "Form", "Dmg Opts", "Blur", "Glow"];
list clrmenu = ["Blue", "Aqua", "Green", "Gold", "Silver", "Red", "Purple", "Orange", "Yellow", "Custom", "Main Menu"];
list dmgmenu = ["RP", "Dmg", "Push", "Low", "Normal", "High", "1HitKill", "Main Menu"];
list colorz = ["<0,0,255>", "<0,255,255>", "<0,255,0>", "<253,225,140>", "<192,192,192>", "<255,0,0>", "<255,0,255>", "<255,128,0>", "<255,255,0>"];


init()
{
    llListen(1, "", "", "");
    llListen(69, "", "", "");
    llListen(70, "", "", "");    
}

default
{
    state_entry()
    {
        init();
    }
    on_rez(integer start_param)
    {
        init();
    }
    attach(key attached)
    {
        init();
    }
    listen(integer chan, string name, key id, string msg)
    {
        string mesg = llToLower(msg);
        vector color;
        integer clrnum = llListFindList(clrmenu, [msg]);
        if(llGetOwnerKey(id) == llGetOwner())
        {
            if(mesg == "menu")
            {
                llDialog(llGetOwner(), "Main Menu", mainmenu, 69);
            }
            else if(mesg == "1 color")
            {
                llDialog(llGetOwner(), "Color 1 Menu", clrmenu, 69);
            }
            else if (mesg == "2 color")
            {
                llDialog(llGetOwner(), "Color 2 Menu", clrmenu, 70);                     }
            else if (mesg == "dmg opts")
            {
                llDialog(llGetOwner(), "Damage Options", dmgmenu, 69);
            }
            else if (mesg == "form")
            {
                llOwnerSay("To Set Form: /69 style stylename. (Replace stylename with the style.)");
            }
            else if (mesg == "custom")
            {
                if(chan == 69)
                {
                    llOwnerSay("To Set Custom Color: /69 color <R,G,B> (R, G and B are 0-255)");
                }
                if(chan == 70)
                {
                    llOwnerSay("To Set Custom Color: /69 color2 <R,G,B> (R, G and B are 0-255)");
                }
            }
            else if(mesg == "Main Menu")
            {
                llDialog(llGetOwner(), "Main Menu", mainmenu, 69);
            }
            else if(clrnum != -1)
            {
                color = (vector)llList2String(colorz, clrnum);
                color /= 255;
                if(chan == 69)
                {
                    llMessageLinked(LINK_SET,0,"COLOR " + (string)color,NULL_KEY);
                }
                else if(chan == 70)
                {
                    llMessageLinked(LINK_SET,0,"2COLOR " + (string)color,NULL_KEY);
                }
            }
        }
    }
            
}
