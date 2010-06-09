//Update Client Script 1.3

//Author: Ion Horten
//Last Modified: 2009-02-11

//Resell and copying of this script with full permissions is not permitted.
//Please don't forget to restrict the script permissions for next users before you start to sale your product!

//====================================================================================================

//Client request message format:
//ITEM_OWNER_KEY:key|ITEM_KEY:key|PRODUCT_NAME:string|PRODUCT_VERSION:string|ITEM_OWNER_NAME:string|REQUEST_COMMAND:string
//Message Sample:
//ca23ff63-38c9-45ee-8187-4b429b55cce8|d6b78de6-e2bf-48c8-a036-97ae32e64b73|Product Name|1.0|Ion Horten|notify

//Server response message format:
//PRODUCT_NAME:string|RECENT_VERSION:string|SERVER_RESPONSE:string
//Message Sample:
//Product Name|1.1|out-of-date

//====================================================================================================

string PRODUCT_NAME = "Product Name";
string PRODUCT_VERSION = "1.0";
key SERVER_KEY = "00000000-0000-0000-0000-000000000000";
string SHARED_SECRET = "";
integer UPDATE_SERVER_KEY = TRUE;

integer DAILY_UPDATE_LIMIT = 3;
integer DEBUG_MODE = FALSE;
integer FAILURE_LIMIT = 3;
integer LISTEN_CHANNEL = 12;
integer REQUEST_INTERVAL = 3600;
integer TIMER_INTERVAL = 10;

key ITEM_OWNER_KEY;
string ITEM_OWNER_NAME;

integer _failures = 0;
integer _lastRequest = 0;
key _requestID = NULL_KEY;
key _serverKey = NULL_KEY;
string _todayDate;
integer _todayUpdates = 0;

string CalculateHash(string product)
{
    return llMD5String(product + ":" + (string) llGetCreator() + ":" + SHARED_SECRET, 0);
}

DebugPrint(string message)
{
    if (DEBUG_MODE)
    {
        list time = llParseString2List(llGetTimestamp(), ["T", "."], []);

        llSay(DEBUG_CHANNEL, llList2String(time, 1) + ": " + message);
    }
}

list ParseMessage(string body)
{
    integer index = llSubStringIndex(body, "\n\n");

    if (index > 0)
    {
        //Trim LL header
        string message = llDeleteSubString(body, 0, index + 1);

        return llParseString2List(message, ["|"], []);
    }
    return [];
}

RequestServerKey()
{
    string params = "ProductName=" + PRODUCT_NAME;

    params += "&CreatorID=" + (string) llGetCreator();
    params += "&Thumbprint=" + CalculateHash(PRODUCT_NAME);

    DebugPrint("Requesting server key");

    _requestID = llHTTPRequest("http://sl.intellisoft.cz/LocateServer.ashx",
        [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], params);
}

SendRequest(string command)
{
    string request = llDumpList2String([ITEM_OWNER_KEY, llGetKey(), PRODUCT_NAME, PRODUCT_VERSION, ITEM_OWNER_NAME, command], "|");

    if (_serverKey == NULL_KEY)
        _serverKey = SERVER_KEY;

    DebugPrint("Sending update request");
    llEmail((string) _serverKey + "@lsl.secondlife.com", PRODUCT_NAME, request);
}

default
{
    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    email(string time, string address, string subject, string body, integer remaining)
    {
        DebugPrint("Update response received");

        if (llStringTrim(subject, STRING_TRIM) == PRODUCT_NAME)
        {
            list params = ParseMessage(body);

            if (llGetListLength(params) == 3)
            {
                string status = llStringTrim(llList2String(params, 2), STRING_TRIM);

                if (status == "up-to-date")
                {
                    llOwnerSay("Your version of " + PRODUCT_NAME + " is up to date.");
                    return;
                }

                if (status == "out-of-date")
                {
                    DebugPrint("Update found: " + llList2String(params, 0) + " " + llList2String(params, 1));

                    string today = llGetDate();

                    if (_todayDate != today)
                    {
                        _todayDate = today;
                        _todayUpdates = 0;
                    }

                    if ((DAILY_UPDATE_LIMIT == 0) || (_todayUpdates < DAILY_UPDATE_LIMIT))
                    {
                        llOwnerSay("A new version of " + PRODUCT_NAME + " has been found. The update has been sent and you should receive it shortly.");

                        SendRequest("update");
                        _todayUpdates++;
                    }
                    else
                    {
                        llOwnerSay("A new version of " + PRODUCT_NAME + " has been found.");
                        llOwnerSay("The automatic updating has been paused because you have reached the daily limit for automatic updates.");
                        llOwnerSay("Use '/" + (string) LISTEN_CHANNEL + "update' command to receive the update manually.");
                    }
                    return;
                }
            }
            else
            {
                DebugPrint("Invalid message format");

                if (++_failures < FAILURE_LIMIT)
                    SendRequest("notify");
            }
        }
        else
        {
            DebugPrint("Invalid product name");

            if (++_failures < FAILURE_LIMIT)
                SendRequest("notify");
        }
    }

    http_response(key request_id, integer status, list metadata, string body)
    {
        if (request_id == _requestID)
        {
            DebugPrint("HTTP response received");

            _lastRequest = llGetUnixTime();

            if (status == 200)
            {
                key serverKey = (key) body;

                if (serverKey)
                {
                    _serverKey = serverKey;
                    DebugPrint("Server key updated: " + body);
                }
                else
                {
                    DebugPrint("Server key unchanged: " + body);
                }
            }
            else
            {
                DebugPrint("Invalid HTTP response: " + body);
            }
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        message = llToLower(llStringTrim(message, STRING_TRIM));

        if (message == "memory")
        {
            llOwnerSay("Free memory (" + llGetScriptName() + "): " + (string) llGetFreeMemory() + " bytes");
            return;
        }

        if (message == "update")
        {
            _todayUpdates = 0;
            _failures = 0;

            llOwnerSay("Sending the update request...");
            SendRequest("notify");

            llOwnerSay("Done.");
            llOwnerSay("Waiting for the response...");
            return;
        }

        if (message == "version")
        {
            llOwnerSay("Product Name: " + PRODUCT_NAME);
            llOwnerSay("Version: " + PRODUCT_VERSION);
            return;
        }
    }

    on_rez(integer start_param)
    {
        ITEM_OWNER_KEY = llGetOwner();
        ITEM_OWNER_NAME = llKey2Name(ITEM_OWNER_KEY);

        _failures = 0;
        SendRequest("notify");
    }

    state_entry()
    {
        ITEM_OWNER_KEY = llGetOwner();
        ITEM_OWNER_NAME = llKey2Name(ITEM_OWNER_KEY);

        llListen(LISTEN_CHANNEL, "", ITEM_OWNER_KEY, "");
        llSetTimerEvent(TIMER_INTERVAL);
    }

    timer()
    {
        if (UPDATE_SERVER_KEY)
        {
            if ((llGetUnixTime() - _lastRequest) > REQUEST_INTERVAL)
                RequestServerKey();
        }
        llGetNextEmail("", "");
    }
}