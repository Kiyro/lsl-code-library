key target = "";
string texture = "bca29a42-c2f3-bf92-c614-ed91654c7bf7";
float age;
float bdelay;
integer partcount;
float radius;
float maxspeed;
float minspeed;
float accelx;
float accely;
float accelz;
float scolr;
float scolg;
float scolb;
float bcolr;
float bcolg;
float bcolb;
float ecolr;
float ecolg;
float ecolb;
float salpha;
float ealpha;
float sscalex;
float sscaley;
float escalex;
float escaley;
float bangle;
float eangle;
float omegax;
float omegay;
float omegaz;
integer bounce;
integer wind;
integer veloc;
vector tarpos;
integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE;
integer flags;
integer schannel = 190;

send_list()
{
    vector scolor = (vector)<scolr,scolg,scolb>;
    vector ecolor = (vector)<ecolr,ecolg,ecolb>;
    vector startSize = (vector)<sscalex,sscaley,0>;
    vector endSize = (vector)<escalex,escaley,0>;
    vector push = (vector)<accelx, accely, accelz>;
    vector omega = (vector)<omegax,omegay,omegaz>;
    
    llParticleSystem([  
                        PSYS_PART_FLAGS,flags,
                        PSYS_PART_START_COLOR, scolor,
                        PSYS_PART_END_COLOR, ecolor,
                        PSYS_PART_START_SCALE,startSize,
                        PSYS_PART_END_SCALE,endSize, 
                        PSYS_SRC_PATTERN, pattern,
                        PSYS_SRC_BURST_RATE,bdelay,
                        PSYS_SRC_ACCEL, push,
                        PSYS_SRC_BURST_PART_COUNT,partcount,
                        PSYS_SRC_BURST_RADIUS,radius,
                        PSYS_SRC_BURST_SPEED_MIN,minspeed,
                        PSYS_SRC_BURST_SPEED_MAX,maxspeed,
                        PSYS_SRC_TARGET_KEY,target,
                        PSYS_SRC_ANGLE_BEGIN,bangle, 
                        PSYS_SRC_ANGLE_END,eangle,
                        PSYS_SRC_OMEGA, omega,
                        PSYS_SRC_MAX_AGE, age,
                        PSYS_SRC_TEXTURE, texture,
                        PSYS_PART_START_ALPHA, salpha,
                        PSYS_PART_END_ALPHA, ealpha
                            ]);
}
update_display()
{
    string sender;
        
    sender = (string)age + "|" + (string)bdelay + "|" + (string)partcount + "|" + (string)radius + "|" + (string)maxspeed + "|" + (string)minspeed + "|" + (string)accelx + "|" + (string)accely + "|" + (string)accelz + "|" + (string)scolr + "|" + (string)scolg + "|" + (string)scolb + "|" + (string)ecolr + "|" + (string)ecolg + "|" + (string)ecolb + "|" + (string)salpha + "|" + (string)ealpha + "|" + (string)sscalex + "|" + (string)sscaley + "|" + (string)escalex + "|" + (string)escaley + "|" + (string)bangle + "|" + (string)eangle + "|" + (string)omegax + "|" + (string)omegay + "|" + (string)omegaz + "|" + texture;
    llMessageLinked(LINK_ALL_CHILDREN, 0, sender, NULL_KEY);
}


default
{
    state_entry()
    {
        llSetTimerEvent(1.0);
        llListen(schannel,"", NULL_KEY, "");
    }
    timer()
    {
        llSetText((string)llGetFreeMemory(),<1,1,1>,1.0);
    }
    listen( integer channel, string name, key id, string message )
    {
        list settings = llParseString2List(message, [" "], []);
        if (llList2String(settings,0) == "texture") texture = llList2String(settings,1);
    }
    touch(integer total_number)
    {
        if(llGetLinkName(llDetectedLinkNumber(0)) == "target") llSay(0, "Target");
        if(llGetLinkName(llDetectedLinkNumber(0)) == "texture") llSay(0, "To set texture Say on channel /"+(string)schannel+" texture :UUID:");
        if(llGetLinkName(llDetectedLinkNumber(0)) == "age+") age = age + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "age-") age = age - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "bdelay+") bdelay = bdelay + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "bdelay-") bdelay = bdelay - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "partcount+") partcount = partcount + 1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "partcount-") partcount = partcount - 1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "radius+") radius = radius + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "radius-") radius = radius - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "maxspeed+") maxspeed = maxspeed + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "maxspeed-") maxspeed = maxspeed - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "minspeed+") minspeed = minspeed + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "minspeed-") minspeed = minspeed - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "accelx+") accelx = accelx + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "accelx-") accelx = accelx - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "accely+") accely = accely + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "accely-") accely = accely - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "accelz+") accelz = accelz + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "accelz-") accelz = accelz - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "startcolr+") scolr = scolr + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "startcolr-") scolr = scolr - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "startcolg+") scolg = scolg + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "startcolg-") scolg = scolg - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "startcolb+") scolb = scolb + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "startcolb-") scolb = scolb - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "ecolr+") ecolr = ecolr + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "ecolr-") ecolr = ecolr - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "ecolg+") ecolg = ecolg + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "ecolg-") ecolg = ecolg - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "ecolb+") ecolb = ecolb + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "ecolb-") ecolb = ecolb - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "salpha+") salpha = salpha + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "salpha-") salpha = salpha - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "ealpha+") ealpha = ealpha + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "ealpha-") ealpha = ealpha - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "sscalex+") sscalex = sscalex + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "sscalex-") sscalex = sscalex - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "sscaley+") sscaley = sscaley + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "sscaley-") sscaley = sscaley - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "escalex+") escalex = escalex + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "escalex-") escalex = escalex - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "escaley+") escaley = escaley + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "escaley-") escaley = escaley - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "bangle+") bangle = bangle + PI;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "bangle-") bangle = bangle - PI;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "eangle+") eangle = eangle + PI;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "eangle-") eangle = eangle - PI;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "omegax+") omegax = omegax + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "omegax-") omegax = omegax - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "omegay+") omegay = omegay + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "omegay-") omegay = omegay - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "omegaz+") omegaz = omegaz + 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "omegaz-") omegaz = omegaz - 0.1;
        if(llGetLinkName(llDetectedLinkNumber(0)) == "send") send_list();
        update_display();
    }
}
