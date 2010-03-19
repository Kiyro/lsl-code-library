SLateIt HUD 1.5
An Augmented Virtual Reality HUD by Babbage Linden
=================================

What is SLateIt?

SLateIt is a recommendation system for Second Life objects. It allows users to tag and rate objects using a Heads Up Display (HUD) interface in Second Life and to find objects using the HUD or via a web interface at http://slateit.org

How do I get a HUD?

SLateIt poster vendors can be found at a number of places in Second Life including Babbage's Kitchen in Ambleside, the GNUbie Store in Indigo and at NCI. Click on the vendor to get a FREE SLateIt HUD. Buy the poster vendor for 0L$ to get your own copy of the vendor to set up on your land.

How do I wear the HUD?

Open the SLateIt HUD 1.5 folder in your inventory, right click on the SLateIt HUD 1.5 object inside and select "Wear".

What should I see when I wear the HUD?

If you stand stationary in front of some objects for a few seconds you should see green numbers move to augment the objects with their SLatings. If you move the SLatings will dissapear. If you remain stationary again they will reappear.

How do I tag and rate objects with the HUD?

When you see something you like click on the object's overlaid SLating, click buttons on the dialogs to add tags describing the object and then click the "SLate" button to positively rate it. If you see a non-zero rating for something offensive or misleading (a plywood box labeled as an awesome gadget) click it's SLating then click the "Hate" dialog button to negatively rate the object. You won't see the object rating change, but objects which are hated many times will be removed from the slateit.org database.

How do I find objects with the HUD?

To find objects in Second Life, click on the green magnifying glass thumb icon, select tags to search for in the dialog and then click "new" to find a new object with that tag or "popular" to find the a popular object with that tag. If an object is found the map will open: click "teleport" to teleport to the object. A results is returned randomly from the set of objects that match your search, so repeatedly making the same query will return different objects for you to look at.

How do I find objects using the web interface?

Go to http://slateit.org in your browser, or click on the SLateIt text in the HUD to open the web site from Second Life. Click on tags to filter objects by tag and then new or popular to order results by rating or date added.

How do I configure the HUD?

HUD settings that can be configured either by chatting "/5 setting:value" while wearing the HUD or by editing the Settings notecard inside the HUD before wearing the HUD. Recognised settings are listed below:

SensorRange:N (scan objects up to N meters away)
RefreshTime:N (update overlay positions every N seconds)
MinRating:N (augment objects with ratings of N+)
FieldOfView:N (field of view in degrees, must match viewer)
SkipNames:X,Y,...,Z (ignore objects with names in list X,Y,...,Z)
OverlayRGB:R,G,B (set overlay colour to <R,G,B>)
Tags:X,Y,...,Z (set tags shown in dialog to list X,Y,...,Z)
SelectionTimeout:N (time out object selection after N seconds)
FindResults:N (select objects from the top N matching results)
Interface:Dialog|Chat (select interface to use when rating objects)

How do I control the HUD via chat?

Chat can be used to control the HUD as well as to modify settings by chatting "/5 command:value". Recognised commands are listed below:

Help (display help text)
New:X,Y,...,Z (find a new object with tags X,Y,...,Z)
Popular:X,Y,...,Z (find a popular object with tags X,Y,...,Z)
Slate:X,Y,..,Z (positively rate selected object and tag it with X,Y,...,Z)
Hate:X,Y,..,Z (negatively rate selected object and tag it with X,Y,...,Z)

How do I turn the HUD off?

Click on the red power thumb icon to turn the HUD off. The interface will change to show a single green power thumb icon which can be clicked to turn the HUD back on. While turned off the HUD just waits for click events to turn it back on. All other activity is disabled including scanning for objects, listening for chat commands and making requests to the http://slateit.org servers.

Can I move the HUD?

Yes. The HUD must be attached to one of the centre HUD attachment points for the overlays to position properly, but you can move the main SLateIt logo HUD interface wherever you like. Right click the HUD and choose "edit" then use the coloured arrows to drag the HUD to the designed spot on the screen.

Are you spying on me?

No. Your avatar's name and ID are recorded when you SLate or hate an object (so that you can only rate each object once) but no other information is stored. 

What happened to this being open source?

To discourage abuse of the service I have added some features which require the scripts to be no-mod. The original open source demo is included with the current version in the "SLateIt Demo (Open Source)" box. The open source version demonstrates all of the fundamental features of SLateIt, but does not save ratings to slateit.org

Why aren't HUD overlays lining up with objects properly?

Your field of view may not match the field of view used by the SLateIt HUD. Turn on FOV in the Client|HUD Info debug menu and set the SLateIt HUD FieldOfView setting to the value that appears at the bottom of your screen.

You're a Linden, does that mean I can bug you or the other Lindens for support?

No, SLateIt is a free service not associated with Linden Lab and is provided as is and without support or warranty. Feedback is welcomed, but please don't expect tech support.