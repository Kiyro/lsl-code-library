key     notecardID = NULL_KEY;
key     requestID;
integer lineNum;

default
{
  state_entry()
  {
    //Register ourselves
    llSay(1, (string)llGetOwner());
        
    //Start checking for emails
    llSetTimerEvent(10);
  }
    
  on_rez(integer start_params)
  {
    llResetScript();
  }
    
  timer()
  {
    //Read the notecard if we have one
    if (notecardID != NULL_KEY)
    {
      requestID = llGetNotecardLine(notecardID, lineNum);
    }
    //Check for email
    llGetNextEmail("", "");
  }
    
  email(string time, string address, string sub, 
        string message, integer num_left)
  {
    //We received an email detailing a new notecard
    //Stop displaying
    llSetTimerEvent(0);
        
    //Get the Notecard ID
    llWhisper(0, "Receiving Notecard: " + sub);
    notecardID = (key)sub;
        
    //If there are more emails in the queue
    //Get the next email
    if (num_left > 0)
    {
      llGetNextEmail("", "");
    }
    else //Else, start displaying textures from notecard
    {
      llSetTimerEvent(10);            
    }
  }
    
  dataserver(key requested, string data)
  {
    //Make sure this request was the one we made
    if (requested == requestID)
    {
      //Check to see if we are at the end of the notecard
      if ((data == EOF) || (data == ""))
      {
        //We hit the end of the file
        //Loop back to the beginning
        lineNum = 0;
        llGetNotecardLine(notecardID, lineNum);
      }
      else
      {
        //We successfully read the line
        //Set the texture using the UUID specified
        llWhisper(0, "Read Notecard Line#" + 
                     (string)lineNum);
        llSetTexture((key)data, ALL_SIDES);
        lineNum += 1;
      }
    }
  }
}
