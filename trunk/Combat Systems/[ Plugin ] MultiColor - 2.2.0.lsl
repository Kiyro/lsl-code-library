//MELEE/RANGE WEAPON SCRIPTSET - MULTICOLOR PLUGIN
//Aug 2009 - Nexus Industries
//
//*License Conditions*
//  All that is asked is this is not resold. Give it away for free or direct inquiries to Nexus Industries.
//
//*Begin Code*

// TIP - Color RGB Values = (Color Picker Values / 255) //
// TIP - Prim Names do not need to match the Tag exactly, only CONTAIN the Tag. (Example "Object *C1") //

///BEGIN CONFIG///
//-Color-//
integer USE_MENU = 1;                   // Range Weapons need this turned Off if Bullet Colors are used, it has it's own Menu Entry. (1 = On, 0 = Off)
string COLOR_COMMAND = "Color";         // Prefix for Input Commands.

integer LINK_COLOR_MODE = 2;            // 0 = Diabled.
                                        // 1 = Set All Prims. Tags are not involved, this Mode always uses Entry 1.
                                        // 2 = Set Prims where Name contains the *A Tag and a Entry Number. [Format: *A#]
                                        // 3 = Set Prims where Name does NOT contain the *A Tag, this Mode always uses Entry 1.
                                        
integer USE_PREMADE_LIST = 1;           // See CONFIG 2 Below. Note the list has 1 Entry per Color. This will override COLOR_LIST settings. (1 = On, 0 = Off)

list COLOR_LIST = [2,                   // [Entries per Color, Color A Name, Entry 1 ColorA, Entry 2 ColorA, ... , Color B Name, Entry 1 ColorB, Entry 2 ColorB, ... ];
"Red",      <1,0,0>,    <0.5,0,0>,      // NOTE: Having more or less Entries for any Color than the 'Entries per Color' parameter *will* break the List.
"Green",    <0,1,0>,    <0,0.5,0>,      // MODE 2 NOTE: Referencing a higher Entry than there are in the List will have unexpected results.
"Blue",     <0,0,1>,    <0,0,0.5>
]; 
///*END CONFIG*///

string BASE_TAG = "*C";

integer CommandLength;
string MenuList;

PremadeColorList()
{
    ///BEGIN CONFIG 2///
    
    // Compiler doesn't like lists larger than 70, so the color list is split into sets of 35 Colors and added together during Runtime. (Name,<R,G,B>) //
    
    list Colors1 = ["black",<0,0,0>,"blue",<0,0,1>,"gold",<1,0.84,0>,"gray",<0.5,0.5,0.5>,"green",<0,0.5,0>,
    "hotpink",<1,0.41,0.71>,"indigo",<0.29,0,0.51>,"lavender",<0.7,0.7,1>,"magenta",<1,0,1>,"orange",<1,0.65,0>,
    "pink", <1,0.75,0.8>,"purple",<0.5,0,0.5>,"red",<1,0,0>,"silver",<0.75,0.75,0.75>,"teal",<0,0.5,0.5>,
    "turquoise",<0.25,0.88,0.82>,"violet",<0.8,0.51,0.8>,"white",<1,1,1>,"yellow",<1,1,0>,"darkblue",<0,0,0.55>,
    "darkcyan",<0,0.55,0.55>,"darkgray",<0.4,0.4,0.4>,"darkgreen",<0,0.39,0>,"darkmagenta",<0.55,0,0.55>,
    "darkorange",<1,0.55,0>,"darkred",<0.55,0,0>,"darkviolet",<0.58,0,0.83>,"lightblue",<0.68,0.85,0.9>,
    "lightgreen",<0.56,0.93,0.56>,"lightgrey",<0.83,0.83,0.83>,"lightpink",<1,0.71,0.76>,"lightyellow",<1,1,0.88>];
    
    list Colors2 = ["aquamarine",<0.5,1,0.83>,"azure",<0.8,1,1>,"blueviolet",<0.54,0.17,0.89>,"chartreuse",<0.5,1,0>,
    "coral",<1,0.5,0.31>,"crimson",<0.86,0.08,0.24>,"cyan",<0,1,0.9>,"deeppink",<1,0.08,0.58>,
    "deepskyblue",<0,0.75,1>,"forestgreen",<0.13,0.55,0.13>,"fuchsia",<1,0,1>,"goldenrod",<0.85,0.65,0.13>,
    "greenyellow",<0.68,1,0.18>,"honeydew",<0.94,1,0.94>,"indianred",<0.8,0.36,0.36>,"lawngreen",<0.49,0.99,0>,
    "limegreen",<0.2,0.8,0.2>,"mediumblue",<0,0,0.8>,"midnightblue",<0.1,0.1,0.44>,"mintcream",<0.96,1,0.98>,
    "navajowhite",<1,0.87,0.68>,"orangered",<1,0.27,0>,"orchid",<0.85,0.44,0.84>,"plum",<0.87,0.63,0.87>,
    "royalblue",<0.25,0.41,0.88>,"salmon",<0.98,0.5,0.45>,"seagreen",<0.18,0.55,0.34>,"seashell",<1,0.96,0.93>];
    
    list Colors3 = ["skyblue",<0.53,0.81,0.92>,"slateblue",<0.42,0.35,0.8>,"springgreen",<0,1,0.5>,"steelblue",<0.27,0.51,0.71>,
    "yellowgreen",<0.6,0.8,0.2>,"brown",<.24,.17,.15>];

    ///*END CONFIG 2*///
    
    COLOR_LIST = [1] + Colors1 + Colors2 + Colors3;
}

StartUp()
{
    if( USE_PREMADE_LIST ) { PremadeColorList(); }

    CommandLength = llStringLength(COLOR_COMMAND);

    list Entries;
    integer PointerMove = llList2Integer(COLOR_LIST,0) + 1;
    integer Count = llGetListLength(COLOR_LIST);
    integer Read = 0;
    for(; Read < Count; Read += PointerMove)
    {
        string Name = llList2String(COLOR_LIST,Read);
        if( llStringLength(Name) > 24 )
        {
            Name = llGetSubString(Name,1,23);
            COLOR_LIST = llListReplaceList(COLOR_LIST,[Name],Read,Read);
        }
        Entries += Name;
    }
    MenuList = llDumpList2String(llListSort(Entries,1,1),"|");
}

MultiColor(string Input)
{
    integer NumberOfPrims = llGetNumberOfPrims();
    integer StartIndex = llListFindList(COLOR_LIST,[Input]);

    integer PointerMove = llList2Integer(COLOR_LIST,0) + 1;
    integer Count = llGetListLength(COLOR_LIST);
    integer Read = 1;
    for(; Read < Count && !~StartIndex; Read += PointerMove)
    {
        string ReadColor = llList2String(COLOR_LIST, Read);
        if( Input == llToLower(ReadColor) )
        {
            StartIndex = Read;
        }
    }
    
    if( ~StartIndex )
    {
        if( LINK_COLOR_MODE == 1 ) { llSetLinkColor(LINK_SET,llList2Vector(COLOR_LIST,StartIndex +1),ALL_SIDES); }
        else if( LINK_COLOR_MODE == 2 )
        {
            integer CurrLink = 1;
            if( NumberOfPrims == 1 )
            {
                CurrLink = 0;
                NumberOfPrims = 0;
            }
            do
            {
                string LinkName = llGetLinkName(CurrLink);
                integer Index = llSubStringIndex(LinkName,BASE_TAG);
                if( ~Index )
                {
                    integer Entry = (integer)llGetSubString(LinkName,Index+2,-1);
                    if( Entry > 0 )
                    {
                        llSetLinkColor(CurrLink,llList2Vector(COLOR_LIST,StartIndex+Entry),ALL_SIDES);
                    }
                }
            }
            while( ++CurrLink <= NumberOfPrims );
        }
        else if( LINK_COLOR_MODE == 3 )
        {
            vector Color = llList2Vector(COLOR_LIST,StartIndex+1);

            integer CurrLink = 1;
            if( NumberOfPrims == 1 )
            {
                CurrLink = 0;
                NumberOfPrims = 0;
            }
            do
            {
                if( !~llSubStringIndex(llGetLinkName(CurrLink),BASE_TAG) )
                {
                    llSetLinkColor(CurrLink,Color,ALL_SIDES);
                }
            }
            while( ++CurrLink <= NumberOfPrims );
        }
    }
}

default
{
    state_entry() { StartUp(); }   
    link_message(integer Sender, integer Num, string Str, key ID)
    {
        if(ID == "USERINPUT")
        {
            Str = llToLower(Str);
        
            if(llSubStringIndex(Str,llToLower(COLOR_COMMAND)) == 0 && LINK_COLOR_MODE)
            {
                MultiColor(llGetSubString(Str,CommandLength+1,-1));
            }
        }
        else if(ID == "MENUGET")
        {
            llMessageLinked(LINK_SET,0,llGetScriptName()+"||"+COLOR_COMMAND+"||"+MenuList+"||Choose a Color||"+COLOR_COMMAND,"MENUREG");
        }
    }
}