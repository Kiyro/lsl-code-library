key collided;
integer dead = 0;
integer health;
integer stamina;
integer blocking = 0;
string sfcs;
string title;
string owner;
string heal;
vector color;
integer tick;


fullinit()
{
    color = <253, 225, 149> / 255;
    title = "";
    init();
}
init()
{
    llMessageLinked(LINK_THIS, 0, "stopregen", NULL_KEY);  
    tick = 0;
    owner = llToLower(llKey2Name(llGetOwner()));
    heal = "heal " + llGetSubString(owner, 0, 0);
    sfcs = "SFCS " + llGetSubString(llGetObjectName(), 21, -1);
    health = 100;
    stamina = 100;
    llListen(1, "", "", "");
    llListen(532254, "", "", "");
    llListen(-690069, "", "", "");
    llListen(696969, "", "", "");
    updatehealth();
    llOwnerSay(sfcs + " Active. For Help/Commands, type /1 help. For the menu, type /1 sfcs");
}

updatehealth()
{
    string stats;
    if(health > 100)
    {
        health = 100;
    }
    else if(health < 0)
    {
        health = 0;
    }
    if(stamina > 100)
    {
        stamina = 100;
    }
    else if(stamina < 0)
    {
        stamina = 0;
    }
    if(health == 0)
    {
        die();
    }
    if(blocking == 0)
    {
       stats = sfcs + "\n";
    }
    else
    {
        stats = "Blocking....\n";
    }
    if(title != "")
    {
        stats += title + "\n";
    }
    stats += "Health: "+ (string)health + "% / Chakra: " + (string)stamina + "%";
    llShout(-696969, "color " + (string)color);
    llShout(-696969, (string)health + "," + (string)stamina);
    llSetText(stats, color, 1.0);
}

die()
{
    if(dead == 0)
    {
        dead = 1;
        llStartAnimation("sleep");
        llSetTimerEvent(0);
        llSay(0, llKey2Name(llGetOwner()) + " has been defeated");
    }
}
live()
{
    llStopAnimation("sleep");
    dead = 0;
    llSetTimerEvent(3);
}
block()
{
    llStartAnimation("block");
}
unblock()
{
    llStopAnimation("block");
}
healstam(integer damage)
{
    if(blocking == 1 && damage < 0)
    {
        stamina += damage;
    }
    else if(blocking == 0 && damage < 0)
    {
        health += damage;
    }
    else if(damage > 0)
    {
        if(health == 0)
        {
            live();
        }
        health += damage;
        stamina = 100;
    }
    
    updatehealth();
}
        
    

default
{
    state_entry()
    {
        fullinit();
    }
    run_time_permissions(integer perms)
    {
        if(perms & PERMISSION_TAKE_CONTROLS)
        {
            llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_UP | CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT | CONTROL_DOWN, TRUE, TRUE);
            init();
        }
        if(perms & PERMISSION_TRIGGER_ANIMATION)
        {
            live();
        }
    }
    attach(key attached)
    {
        if(attached != NULL_KEY)
        {
            llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
        }
    }
    collision_start(integer total)
    {
        if(llDetectedKey(0) != collided)
        {
            collided = llDetectedKey(0);
            if(llDetectedName(0) == "Fireball")
            {
                healstam(-10);
            }
            else if(llDetectedName(0) == "Pull")
            {
            }
            else if(llDetectedType(0) & ACTIVE && !(llDetectedType(0) & AGENT))
            {
                healstam(-2);
            }
        }
        
    }
    sensor(integer total)
    {
        integer i;
        for(i = 0; i < total; i++)
        {
            llShout(-690069, llDetectedKey(i));
        }
    }
    timer()
    {
        if(health < 100 || stamina < 100)
        {
            if(tick == 1)
            {
                health += 1;
                tick = 0;
            }
            else if(tick == 0)
            {
                tick = 1;
            }
            if(blocking == 0)
            {
                stamina += 1;
            }
            updatehealth();
        }
    }
    control(key id,integer held,integer change)
    {
        if(held & CONTROL_LBUTTON || held & CONTROL_ML_LBUTTON)
        {
            blocking = 0;
            if((change & held & CONTROL_ROT_LEFT) | (change & ~held & CONTROL_LEFT))
            {
                llSensor("", "", AGENT, 4, PI_BY_TWO);
            }
            if((change & held & CONTROL_ROT_RIGHT) | (change & ~held & CONTROL_RIGHT))
            {
                llSensor("", "", AGENT, 4, PI_BY_TWO);
            }
            if(change & held & CONTROL_FWD)
            {
                llSensor("", "", AGENT, 4, PI_BY_TWO);                
            }
            if(change & held & CONTROL_BACK)
            {
                llSensor("", "", AGENT, 4, PI_BY_TWO);                
            }
            
        }
        else if(~held & CONTROL_LBUTTON || ~held & CONTROL_ML_LBUTTON)
        {
            if((held & CONTROL_BACK) && (held & CONTROL_FWD))
            {
                if(stamina > 0)
                {
                    blocking = 1;
                    block();
                }
                else
                {
                    if(blocking == 1)
                    {
                        unblock();
                    }
                    blocking = 0;
                }
                updatehealth();
            }
//            else if((change & ~held & CONTROL_BACK) && (change & ~held & CONTROL_FWD))
            else
            {
                if(blocking == 1)
                {
                    unblock();
                }
                blocking = 0;
                updatehealth();
            }
        }
    }
    link_message(integer sender, integer num, string msg, key id)
    {
        if(msg == "regen")
        {
            if(health < 100 && stamina > 0 && health > 0)
            {
                stamina -= 2;
                health += 2;
            }
            if(health >= 100 || stamina == 0 || health == 0)
            {
                llMessageLinked(LINK_THIS, 0, "stopregen", NULL_KEY);  
            }
                
            updatehealth();
        }
    }
    listen(integer chan, string name, key id, string msg)
    {
        string mesg;
        mesg = llToLower(msg);
        if(chan == 1)
        {
            if(llGetOwnerKey(id) == llGetOwner())
            {
                if(mesg == "reset")
                {
                    live();
                    init();
                }
                else if(mesg == "fullreset")
                {
                    live();
                    fullinit();
                }
                else if(mesg == "regen")
                {
                    llMessageLinked(LINK_THIS, 0, "startregen", NULL_KEY);
                }
                else if(mesg == "stopregen")
                {
                    llMessageLinked(LINK_THIS, 0, "stopregen", NULL_KEY);
                }
                else if(mesg == "help")
                {
                    llGiveInventory(llGetOwner(), "SFCS Help");
                }
                else if(llGetSubString(mesg, 0, 5) == "color ")
                {
                    color = (vector)llGetSubString(msg, 6, -1);
                    color /= 255;
                    updatehealth();
                }
                else if(llGetSubString(mesg, 0, 5) == "title ")
                {
                    title = llGetSubString(msg, 6, -1);
                    if(llToLower(title) == "none")
                    {
                        title = "";
                    }
                    updatehealth();
                }
            }
            
            if(llGetSubString(mesg, 0, 5) == heal)
            {
                if(health < 100)
                {
                    healstam(10);
                }
                updatehealth();
            }
        }
        else if(chan == 532254 && llGetSubString(name, 0, 4) == "Force")
        {
            if(msg == (string)llGetOwner())
            {
                healstam(-2);
            }
            else if(msg == (string)llGetOwner() + "+")
            {
                healstam(5);
            }
        }
        else if(chan == 696969)
        {
            if(msg == (string)llGetOwner())
            {
                healstam(-5);
            }
            else if(msg == (string)llGetOwner() + "+")
            {
                healstam(5);
            }
            else if(llGetSubString(msg, 0, 35) == (string)llGetOwner())
            {
                healstam((integer)llGetSubString(msg, 36, -1));
            }
        }
        else if(chan == -690069)
        {
            if(msg == (string)llGetOwner())
            {
                healstam(-2);
            }
            else if(msg == "updatehp" && llGetOwnerKey(id) == llGetOwner())
            {
                updatehealth();
            }
        }
    }
        
}
