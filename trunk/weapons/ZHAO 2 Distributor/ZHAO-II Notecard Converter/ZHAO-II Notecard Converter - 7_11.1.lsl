// ZHAO-II-notecard-converter - Ziggy Puff, 07/07

/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Notecard converter script. Reads notecards in the old format and generates notecards in the new
// format. Since scripts can't write to notecards, this says the required text in chat
//
/////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////
// New notecard format
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
// Lines starting with a # are treated as comments and ignored. Blank lines are ignored. Valid lines 
// look like this:
//
// [ Walking ]SexyWalk1|SexyWalk2|SexyWalk3
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////

// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.

string notecardName;
key query;
integer lineNum;

//Do it the stupid brute-force way
list Standing = [];
list Walking = [];
list Sitting = [];
list SittingOnGround = [];

string Running;
string CrouchWalking;
string Flying;
string TurningLeft;
string TurningRight;
string Jumping;
string HoveringUp;
string Crouching;
string FlyDown;
string Hovering;
string PreJumping;
string Falling;
string Landing;
string StandingUp;
string FlyingSlow;
string Floating;
string SwimmingForward;
string SwimmingUp;
string SwimmingDown;

Initialize()
{
    Standing = [];
    Walking = [];
    Sitting = [];
    SittingOnGround = [];

    Running = "";
    CrouchWalking = "";
    Flying = "";
    TurningLeft = "";
    TurningRight = "";
    Jumping = "";
    HoveringUp = "";
    Crouching = "";
    FlyDown = "";
    Hovering = "";
    PreJumping = "";
    Falling = "";
    Landing = "";
    StandingUp = "";
    FlyingSlow = "";
    Floating = "";
    SwimmingForward = "";
    SwimmingUp = "";
    SwimmingDown = "";
}

PrintHelp()
{
    llOwnerSay("Drag the animations notecard from your old ZHAO to your inventory.");
    llOwnerSay("Then drag that notecard from your inventory into this object's inventory.");
}

PrintNotecardStuff()
{
    llOwnerSay("This converter will only generate the notecard lines needed by ZHAO-II.");
    llOwnerSay("For additional instructions on setting up the notecard, click the 'Help' button on your ZHAO-II or read the included 'Default' notecard");

    string s = "Copy every line after this one (you can leave the blank lines):\n\n";
        
    // More brute force code. No need to worry about multi-line config, since the old notecard
    // could only have 5 of anything

    s += "\n[ Standing ]";             s += llDumpList2String(Standing, "|");
    s += "\n[ Walking ]";              s += llDumpList2String(Walking, "|");
    s += "\n[ Sitting ]";              s += llDumpList2String(Sitting, "|");
    s += "\n[ Sitting On Ground ]";    s += llDumpList2String(SittingOnGround, "|");

    s += "\n[ Crouching ]";            s += Crouching;
    s += "\n[ Crouch Walking ]";       s += CrouchWalking;
    s += "\n[ Landing ]";              s += Landing;
    s += "\n[ Standing Up ]";          s += StandingUp;
    s += "\n[ Falling ]";              s += Falling;
    s += "\n[ Flying Down ]";          s += FlyDown;
    s += "\n[ Flying Up ]";            s += HoveringUp;
    s += "\n[ Flying ]";               s += Flying;
    s += "\n[ Flying Slow ]";          s += FlyingSlow;
    s += "\n[ Hovering ]";             s += Hovering;
    s += "\n[ Jumping ]";              s += Jumping;
    s += "\n[ Pre Jumping ]";          s += PreJumping;
    s += "\n[ Running ]";              s += Running;
    s += "\n[ Turning Right ]";        s += TurningRight;
    s += "\n[ Turning Left ]";         s += TurningLeft;
    s += "\n[ Floating ]";             s += Floating;
    s += "\n[ Swimming Forward ]";     s += SwimmingForward;
    s += "\n[ Swimming Up ]";          s += SwimmingUp;
    s += "\n[ Swimming Down ]";        s += SwimmingDown;

    s += "\n\n\n";

    llOwnerSay(s);
}

PrintFooter()
{
    llOwnerSay("Stop copying here.");
    llOwnerSay("Paste the copied text into a new notecard.");
    llOwnerSay("Drag that notecard into the inventory of the ZHAO-II");
    llOwnerSay("Wear the ZHAO-II, and load the new notecard.");
    llOwnerSay("You can now remove the '" + notecardName + "' notecard from this object's inventory.");
    llOwnerSay("Click the [CHAT] button, followed by the [HISTORY] button, to view your chat buffer and see the notecard information.");
}

default
{
    state_entry()
    {
        llAllowInventoryDrop(TRUE);
        llSetText("ZHAO-II Notecard Converter\nTouch for info", <1,1,1>, 1);
    }

    touch_start(integer num)
    {
        PrintHelp();
    }

    changed(integer change)
    {
        if (!(change & CHANGED_INVENTORY))
        {
            return;
        }

        integer numNotecards = llGetInventoryNumber(INVENTORY_NOTECARD);

        if (numNotecards == 0)
        {
            return;
        }

        if (numNotecards > 1)
        {
            llOwnerSay("Too many notecards - there should only be one notecard in the inventory of the " + 
                        llGetObjectName() + ".");
            return;
        }

        notecardName = llGetInventoryName(INVENTORY_NOTECARD, 0);
        llOwnerSay("Reading notecard '" + notecardName + "'...");

        // One simple sanity check to try and make sure this is a valid notecard
        // Read the first line and see if it says ":: [ Walking (also Striding) 1 ] ::"

        lineNum = 0;
        query = llGetNotecardLine(notecardName, lineNum);
    }

    dataserver(key id, string data)
    {
        if (id != query)
        {
            return;
        }

        if (data == EOF)
        {
            PrintNotecardStuff();
            PrintFooter();
            return;
        }

        // Sanity check
        if (lineNum == 0)
        {
            if (data != ":: [ Walking (also Striding) 1 ] ::")
            {
                llOwnerSay("'" + notecardName + "' does not appear to be a valid ZHAO animation notecard.");
                llOwnerSay("Please check the notecard and try again.");
                return;
            }
            else
            {
                Initialize();
                lineNum++;
                query = llGetNotecardLine(notecardName, lineNum);
                return;
            }
        }

        // OK, brute force code, here we go...
        if ((lineNum == 1) ||
            (lineNum == 55) ||
            (lineNum == 57) ||
            (lineNum == 59) ||
            (lineNum == 61))
        {
            if (data != "")
            {
                Walking += [data];
            }
        }
        else if ((lineNum == 21) ||
                 (lineNum == 23) ||
                 (lineNum == 25) ||
                 (lineNum == 27) ||
                 (lineNum == 29))
        {
            if (data != "")
            {
                Standing += [data];
            }
        }
        else if ((lineNum == 33) ||
                 (lineNum == 63) ||
                 (lineNum == 65) ||
                 (lineNum == 67) ||
                 (lineNum == 69))
        {
            if (data != "")
            {
                Sitting += [data];
            }
        }
        else if ((lineNum == 45) ||
                 (lineNum == 71) ||
                 (lineNum == 73) ||
                 (lineNum == 75) ||
                 (lineNum == 77))
        {
            if (data != "")
            {
                SittingOnGround += [data];
            }
        }
        else if (lineNum == 3)
        {
            Running = data;
        }
        else if (lineNum == 5)
        {
            CrouchWalking = data;
        }
        else if (lineNum == 7)
        {
            Flying = data;
        }
        else if (lineNum == 9)
        {
            TurningLeft = data;
        }
        else if (lineNum == 11)
        {
            TurningRight = data;
        }
        else if (lineNum == 13)
        {
            Jumping = data;
        }
        else if (lineNum == 15)
        {
            HoveringUp = data;
        }
        else if (lineNum == 17)
        {
            Crouching = data;
        }
        else if (lineNum == 19)
        {
            FlyDown = data;
        }
        else if (lineNum == 31)
        {
            Hovering = data;
        }
        else if (lineNum == 35)
        {
            PreJumping = data;
        }
        else if (lineNum == 37)
        {
            Falling = data;
        }
        else if (lineNum == 39)
        {
            Landing = data;
        }
        else if (lineNum == 41)
        {
            StandingUp = data;
        }
        else if (lineNum == 43)
        {
            FlyingSlow = data;
        }
        else if (lineNum == 47)
        {
            Floating = data;
        }
        else if (lineNum == 49)
        {
            SwimmingForward = data;
        }
        else if (lineNum == 51)
        {
            SwimmingUp = data;
        }
        else if (lineNum == 53)
        {
            SwimmingDown = data;
        }

        lineNum += 2;
        query = llGetNotecardLine(notecardName, lineNum);
    }
}
