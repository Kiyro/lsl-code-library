// Constants
integer intListenChannel = 2938;
string  strLandmarkName = "Kasandres landmark";

string  strButtonsUser = "  1 == Pull\n
                            2 == Rip off\n
                            3 == Touch
                            ";
list    lstButtonsUser = ["Landmark", "1", "2", "3"];

// Variables
list    lstBanList = [];
integer isOn = TRUE;
integer intState = 0; // 0=idle; 1=user clicked; 2=permission; 3=ban; 4=owner clicked
string  strCurrentSelection = "";
string  strCurrentUserName;
key     keyCurrentUser;

showDialogUser(key _av)
{
    intState = 1;
    llDialog(_av, strButtonsUser, lstButtonsUser, intListenChannel);
}

showDialogPermission()
{
    intState = 2;
    llDialog(llGetOwner(), strCurrentUserName + " is trying to interact with your skirt, do you want to permit this?", ["yes", "no"], intListenChannel);
}

showDialogBan()
{
    intState = 3;
    llDialog(llGetOwner(), "Do you want to ban " + strCurrentUserName + " from clicking your skirt?", ["yes", "no"], intListenChannel);
}

showDialogOwner()
{
    intState = 4;
    llDialog(llGetOwner(), "What do you want to do?\n 
                            1 == Pull\n
                            2 == Rip off\n
                            3 == Touch", ["Landmark", "Reset list", "Say list", "1", "2", "3"], intListenChannel);
}

clear()
{
    strCurrentSelection = "";
    strCurrentUserName = "";
    keyCurrentUser = NULL_KEY;
    intState = 0;
}

default
{
    state_entry()
    {
        llListen(intListenChannel, "", "", "");
    }
    
    attach(key _id)
    {
        if (_id != NULL_KEY)
        {
            llRequestPermissions(llGetOwner(), PERMISSION_ATTACH);
        }
    }
    
    listen(integer _ch, string _nm, key _id, string _msg)
    {
        if (intState == 1) // if user clicked
        {
            if (_msg == "Landmark")
            {
                llGiveInventory(_id, strLandmarkName);
            } else if (_msg == "1")
            {
                strCurrentSelection = "1";
                keyCurrentUser = _id;
                strCurrentUserName = llKey2Name(keyCurrentUser);
                
                // Change this text to what you want to happen on button 1                
                llSay(0, strCurrentUserName + " does a step forward and pulls on " + llKey2Name(llGetOwner()) + "'s skirt watching it slip to the ground as her sleek slender body is uncovered");
                
                showDialogPermission();
            } else if (_msg == "2")
            {
                strCurrentSelection = "2";
                keyCurrentUser = _id;
                strCurrentUserName = llKey2Name(keyCurrentUser);
                
                // Change this text to what you want to happen on button 2
                llSay(0, strCurrentUserName + " grabs " + llKey2Name(llGetOwner()) + "'s skirt and gives it a good rip you won't be needing this anymore!!");
                
                showDialogPermission();
            } else if (_msg == "3")
            {
                strCurrentSelection = "3";
                keyCurrentUser = _id;
                strCurrentUserName = llKey2Name(keyCurrentUser);
                
                // Change this text to what you want to happen on button 3
                llSay(0, strCurrentUserName + " touches " + llKey2Name(llGetOwner()) + "'s skirt and feels the softness of the lace thinking of how her skin must feel");
                
                showDialogPermission();
            }
        } else if (intState == 2) // owner has to give permission
        {
            if (_msg == "no")
            {
                llSay(0, llKey2Name(llGetOwner()) + " slaps " + strCurrentUserName + " in the face leaving her tiny hand print in a redding welt as she screams!");
                showDialogBan();
            } else if (_msg == "yes")
            {
                if (strCurrentSelection == "1")
                {
                    // Change this text to what you want to happen on button 1                
                    llSay(0, llKey2Name(llGetOwner()) + "'s skirt drops to the floor");
                    clear();
                    llDetachFromAvatar(); // if you don't want the skirt to be taken off delete this line                     
                } else if (strCurrentSelection == "2")
                {
                    // Change this text to what you want to happen on button 2                
                    llSay(0, llKey2Name(llGetOwner()) + "'s skirt gets ripped to shreds");
                    clear();
                    llDetachFromAvatar(); // if you don't want the skirt to be taken off delete this line
                } else if (strCurrentSelection == "3")
                {
                    // Change this text to what you want to happen on button 3                
                    llSay(0, llKey2Name(llGetOwner()) + "'s skirt feels really soft");
                    clear();
                    llDetachFromAvatar(); // if you don't want the skirt to be taken off delete this line
                }
            }
        } else if (intState == 3) // owner denied, do you want to ban
        {
            if (_msg == "yes")
            {
                lstBanList += strCurrentUserName;
                clear();
            } else if (_msg == "no")
            {
                clear();
            }
        } else if (intState == 4) // owner clicked
        {
            if (_msg == "Landmark")
            {
                llGiveInventory(_id, strLandmarkName); 
            } else if (_msg == "Reset list")
            {
                lstBanList = [];
                llOwnerSay("Ban list has been reset");
            } else if (_msg == "Say list")
            {
                integer i;
                llOwnerSay("These are the avatars that are banned:");
                for (i = 0; i < llGetListLength(lstBanList); i++)
                {
                    llOwnerSay(llList2String(lstBanList, i));
                }
            } else if (_msg == "1")
            {
                // Change this text to what you want to happen on button 1                
                llSay(0, llKey2Name(llGetOwner()) + " drops her skirt to the floor");
                clear();
                llDetachFromAvatar(); // if you don't want the skirt to be taken off delete this line                  
            } else if (_msg == "2")
            {
                // Change this text to what you want to happen on button 2                
                llSay(0, llKey2Name(llGetOwner()) + " rips her skirt to shreds");
                clear();
                llDetachFromAvatar(); // if you don't want the skirt to be taken off delete this line
            } else if (_msg == "3")
            {
                // Change this text to what you want to happen on button 3                
                llSay(0, llKey2Name(llGetOwner()) + " feels her skirt, its soft!");
                clear();
                }
        }
    }
    
    touch_end(integer _num)
    {
        if (llDetectedKey(0) == llGetOwner()) // if owner touches
        {
            showDialogOwner(); // show the dialog for the owner
        } else
        {
            if (isOn == TRUE) // if the machine is on
            {
                keyCurrentUser = llDetectedKey(0);
                if (llListFindList(lstBanList, [llDetectedName(0)]) == -1) // if user is not in banlist
                {
                    showDialogUser(keyCurrentUser); // show the dialog to the user
                }
            }
        }
    }
}
