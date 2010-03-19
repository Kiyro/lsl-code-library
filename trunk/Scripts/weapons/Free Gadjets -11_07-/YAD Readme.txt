Monk's and tx Oh's Yet Another Danceball - YAD

Congratulations for getting this danceball..probably the best thing you ever picked up for free ; P

It comes with 30 dances, on touch you will get a menu with all listed dances + sequences. Yes, sequences. The dances and sequences are managed by a notecard in the content of the danceball with the name _DANCECARD. The syntax of the lines in the notecard is very easy. Here some examples:

Club1=Club Dance 1;0

The name before the equal sign (=) is the name which appears in the menu. After the equal sign is the name of the dance animation. After the semicolon (;) is the time in seconds how long the animation should be played. A zero (0) means forever. So, 'Club1' will appear on the menu and the triggered animation is 'Club Dance 1' and will play forever or stopped manualy.

Club(U)=Club Dance 1;16:Club Dance 2;26:Club Dance 3;18:Club Dance 4;6

This line describes a dance sequence. It will be shown as 'Club(U)' in the menu. It includes the animations 'Club Dance 1' for 16 seconds, 'Club Dance 2' for 26 seconds and so on. The animations and time values in a sequence are separated by a colon (:).

After changing the _DANCECARD notecard you need to reset the 'Controller' script or rerezz the Danceball.

If you like more then 20 concurrent dancers you need to change  the 'maxcount' variable in the 'Controller' script and copy the 'Dancer xx' scripts according to the adjusted max dancer number.

This product comes under the terms of the GNU General Public License. Read it. DO NOT RESELL THIS PRODUCT WITHOUT THE PERMISSION OF THE COPYRIGHT HOLDERS.

Have fun & keep on dancing,

monk & tx Oh
