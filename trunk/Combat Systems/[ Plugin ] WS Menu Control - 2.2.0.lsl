//MELEE/RANGE WEAPON SCRIPTSET - DIALOG MENU PLUGIN
//Aug 2009 - Nexus Industries
//
//*License Conditions*
//  All that is asked is this is not resold. Give it away for free or direct inquiries to Nexus Industries.
//
//*Begin Code*

///BEGIN CONFIG///
//-System-//
integer MENU_CHAN = -852000004;                             // Menu Chat Channel, should be a very negative channel
///*END CONFIG*///

key OwnerKey;
integer KeepOpen;

integer Reload;
list StoredMenus;
list PrsMainMenu;
string DrawCommand;
list CombatsMenu;

string DRAWENTRY = "Draw/Shea";
string COMBENTRY = "Combat";

integer UserListen;
integer MenuTime;

list CurrentMenu;
integer MenuIndex;
string CurrentMsg;

string PrevPgButton = "< Page";
string NextPgButton = "Page >";
string CancelButton = "Cancel";
string GoBackButton = "Main Menu";
string MenuOpButton = "MenuOption";
string KpOpenButton = "KeepOpen";
string ReloadButton = "ReloadMenu";

integer PgNum;

StartUp()
{
    OwnerKey = llGetOwner();

    MenuCleanup();
    
    MenuReset();
}

DefaultSettings()
{
    KeepOpen = 1;
}

MenuReset()
{
    StoredMenus = [];
    PrsMainMenu = [];
    DrawCommand = "";
    CombatsMenu = [];
    llMessageLinked(LINK_SET,0,"","MENUGET");
}

MenuLoad()
{
    PrsMainMenu = [];
    
    StoredMenus = llListSort(StoredMenus,5,TRUE);

    PrsMainMenu += DRAWENTRY;
    if( llGetListLength(CombatsMenu) )
    {
        PrsMainMenu += COMBENTRY;
        CombatsMenu = ["Basic"] + llListSort(CombatsMenu,1,TRUE);
    }

    integer Count = llGetListLength(StoredMenus);
    integer Read = 1;
    for(; Read < Count; Read += 5)
    {
        PrsMainMenu += llList2List(StoredMenus,Read,Read);
    }
}

OpenMainMenu()
{
    if(Reload) { MenuLoad(); Reload = 0; }
    CurrentMenu = PrsMainMenu;
    MenuIndex = -1;
    CurrentMsg = "[ Main Menu ]";
    PgNum = 1;
    MenuDialog();
}

MenuDialog()
{
    integer ChoiceCt = llGetListLength(CurrentMenu);;
    integer PgCt = llCeil( (float)ChoiceCt / 8 );
    
    list Buttons;

    if(PgNum < 1) { PgNum = PgCt; }
    else if (PgNum > PgCt) { PgNum = 1; }
        
    integer FirstBtn = (PgNum - 1)*8;
    integer LastBtn = FirstBtn + 7;
    if (LastBtn >= ChoiceCt)
    {
        LastBtn = ChoiceCt;
    }
    Buttons = llList2List(CurrentMenu, FirstBtn, LastBtn);
    for(;llGetListLength(Buttons) < 8;) { Buttons += " "; }

    string EndButton;
    if(~MenuIndex) { EndButton = GoBackButton; }
    else { EndButton = CancelButton; }
    
    Buttons = [EndButton]+llList2List(Buttons,6,7)+[MenuOpButton]+llList2List(Buttons,4,5)+[PrevPgButton]+llList2List(Buttons,2,3)+[NextPgButton]+llList2List(Buttons,0,1);
    
    llDialog(OwnerKey, "Page "+(string)PgNum+" of "+(string)PgCt+"\n"+CurrentMsg,Buttons, MENU_CHAN);
}

MenuCleanup()
{
    llListenRemove(UserListen);
    llSetTimerEvent(0.0);
    UserListen = 0;
    MenuTime = 0;
    CurrentMenu = [];
    MenuIndex = -1;
    CurrentMsg = "";
}

default
{
    on_rez(integer Start) { StartUp(); }
    state_entry() { StartUp(); DefaultSettings(); }

    link_message(integer Sender, integer Num, string Str, key ID)
    {
        if( ID == "MENUOPN" )
        {
            if(!UserListen)
            {
                UserListen = llListen(MENU_CHAN, "",OwnerKey,"");
                llSetTimerEvent(5.0);
            }
            OpenMainMenu();
        }
        else if( llSubStringIndex((string)ID,"MENUREG") == 0 )
        {
            string Mode = llGetSubString((string)ID,7,-1);
            
            if( Mode == "DRAW" )
            {
                DrawCommand = Str;
                Reload = 1;
            }
            else if( Mode == "COMBAT" )
            {
                if( !~llListFindList(CombatsMenu,[Str]) && llToLower(Str) != "basic")
                {
                    CombatsMenu += Str;
                    Reload = 1;
                }
            }
            else if( llStringLength((string)ID) == 7 )
            {
                list InputList = llParseString2List(Str,["||"],[]);
                
                string MainEntry = llList2String(InputList,1);
                
                if( llGetListLength(InputList) == 5 && !~llListFindList(StoredMenus,[MainEntry]) )
                {
                    if( MainEntry != DRAWENTRY && MainEntry != COMBENTRY )
                    {
                        StoredMenus += InputList;
                        Reload = 1;
                    }
                }
            }
        }
    }
    listen(integer Channel, string Name, key ID, string Message) 
    {
        MenuTime = 0;
        
        if(Message == " ")
        {
            MenuDialog();
        }
        else if( Message == PrevPgButton )
        {
            --PgNum;
            MenuDialog();
        }
        else if( Message == NextPgButton )
        {
            ++PgNum;
            MenuDialog();
        }
        else if( Message == MenuOpButton )
        {
            MenuIndex = -3;
            CurrentMenu = [KpOpenButton,ReloadButton];
            PgNum = 1;
            MenuDialog();
        }
        else if( Message == GoBackButton )
        {
            OpenMainMenu();
        }
        else if( Message == CancelButton )
        {
            llOwnerSay("Menu Closed.");
            MenuCleanup();
        }
        else if( ~llListFindList(CurrentMenu,[Message]) )
        {
            if( MenuIndex == -3 )
            {
                if( Message == KpOpenButton )
                {
                    if(KeepOpen)
                    {
                        KeepOpen = 0;
                        llOwnerSay("Automatic Menu Reopen turned OFF.");
                    }
                    else
                    {
                        KeepOpen = 1;
                        llOwnerSay("Automatic Menu Reopen turned ON.");
                    }
                        
                    if(KeepOpen) { OpenMainMenu(); }
                    else { MenuCleanup(); }
                }
                else if( Message == ReloadButton )
                {
                    llOwnerSay("Reloading Menus. Please wait a few seconds before re-opening.");
                    MenuCleanup();
                    MenuReset();
                }
            }
            else if( MenuIndex == -2 )
            {
                if( ~llListFindList(CombatsMenu,[Message]) )
                {
                    llMessageLinked(LINK_SET,1,"Combat "+ Message,"USERINPUT");
                    
                    if(KeepOpen) { OpenMainMenu(); }
                    else { MenuCleanup(); }
                }
            }
            else if( MenuIndex == -1 )
            {
                if( Message == DRAWENTRY )
                {
                    llMessageLinked(LINK_SET,1,DrawCommand,"USERINPUT");
                            
                    if(KeepOpen) { OpenMainMenu(); }
                    else { MenuCleanup(); }
                }
                else if( Message == COMBENTRY )
                {
                    MenuIndex = -2;
                    CurrentMenu = CombatsMenu;
                    CurrentMsg = "[ Combat System Options ]";
    
                    PgNum = 1;
                    MenuDialog();
                }
                else
                {
                    MenuIndex = llListFindList(StoredMenus,[Message]);
                                
                    string SubMenuButtons = llList2String(StoredMenus,MenuIndex+1);
                    if( SubMenuButtons != "NULL" )
                    {
                        CurrentMenu = llParseString2List(SubMenuButtons,["|"],[]);
                                    
                        string SubmenuMessage = llList2String(StoredMenus,MenuIndex+2);
                        if(SubmenuMessage != "NULL") { CurrentMsg = SubmenuMessage; }
                        else { CurrentMsg = ""; }
                                    
                        PgNum = 1;
                        MenuDialog();
                    }
                    else
                    {
                        string SayString;
                                    
                        string ButtonValue = llList2String(StoredMenus,MenuIndex+3);
                        if(ButtonValue != "NULL") { SayString = ButtonValue; }
                        else { SayString = Message; }
        
                        llMessageLinked(LINK_SET,1,SayString,"USERINPUT");
                                    
                        if(KeepOpen) { OpenMainMenu(); }
                        else { MenuCleanup(); }
                    }
                }
            }
            else
            {
                if( ~llListFindList(CurrentMenu,[Message]) )
                {
                    string SayString;
                    string ButtonValue = llList2String(StoredMenus,MenuIndex+3);
                    if(ButtonValue != "NULL") { SayString += ButtonValue+" "; }
                    SayString += Message;
    
                    llMessageLinked(LINK_SET,1,SayString,"USERINPUT");
                    if(KeepOpen) { OpenMainMenu(); }
                    else { MenuCleanup(); }
                }
            }
        }
    }
    timer()
    {
        if(UserListen)
        {
            ++MenuTime;
            if(MenuTime == 12)
            {
                llOwnerSay("Menu Timeout.");
                MenuCleanup();
            }
        }
    }
}