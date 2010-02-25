ASCII Display is not really an display which works with
ASCIII values, but it covers the ASCII characters.

This README file is a brief documentation of the ASCII Display
as it is. It will start with the creation and handling of fonts. Font creation
is a deeply detailed process and because of that, and because I like
to see other new fonts on the display, this README takes it in front.

If you are OK with the default fonts come with the display or like to
play with the display first, you can skip to the second part. The second
part describes how to deal with the display.


Font creation and handling:

Fonts are handled with font textures (.TGA files) and notecards
in the content folder. The next example describe the fontmatrix of a
font and is in the content folder. This notecard example describes
the default font.

Example:

// calculation for horizontal coordinates is:  face offset + char in line * char distance in line
//
// texture key or name
fonts5w
//
// vertical offsets for line1, line2, line3 (from texture edit)
0.348, 0.315, 0.282
//
// horizontal offsets for line1, line2, line3 (indentation)
0.0, 0.0, 0.0
//
// char distance in line1, line2, line3 (distance between two characters)
0.02937, 0.02937, 0.0298
//
// texture offset of face1, face2, face3, face4, face5 (from texture edit)
-0.46, -0.476, -0.571, -0.476, -0.491
//
// horizontal and vertical repeats per face (from texture edit) (negative numbers means flipped)
// face 1    |    face 2 |       face 3  |        face 4 |        face 5
0.05, 0.03, 0.02, 0.03, -0.29, 0.03, 0.02, 0.03, 0.05, 0.03
//
// character rows
aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpP, qQrRsStTuUvVwWxXyYzZ0123456789, `~!@#$%^&*()-_=+[]\{}|;:'"%2C<.>/?

The character row part describes the character setup on your font texture,
the character "," (comma) is noted as an escaped URL character (%2C).
The values are offsets on the font texture image and face offsets. These
numbers and letters are used to calculate the face position on the single
prim faces.

Best practice: select texture editing. zoom in to the beginning of the first
characters per line on the font texture, make a note these numbers in
the corresponding fields on the notecard. You may need to play around
with the parameters. Save the font notecard back and load the new font
settings from the touch menu.

There are 5 font texture files in the inventory, the both default font notecards
describe 2 fonts from the fonts5w texture file. Please send in font descriptions
of other fonts and textures when you like to share it with other users in
further releases. New font textures and descriptions are also welcome!



ASCII Display handling:

Talk to the display-rezer script on channel 23 to rez out a display. The
syntax is very easy: "/23 rezout lines prims" - without the quotes,
where lines = the number of lines you want and prims = the number of
prims to put on a line. 4 lines with 3 prims will result in a 15x4 display.
To delete the prims, type into the chat line "/23 unrez", again without the
quotes. When the display is rezzed, you may disable the display-rezzer
script by check the "Running" checkbox off.

Display commands go on channel 89 and have the following syntax:

/89 color <color vector>
/89 bgcolor <color vector>
/89 reset
/89 fullbright
/89 nofullbright
/89 blink
/89 noblink
/89 alpha                                            -- background
/89 noalpha
/89 linecolor n <color vector>            -- Give line n the specified color. lines count from 0
/89 cellcolor n.m <color vector>        -- Tints the cell m in line n. cells also count from 0
/89 facecolor n.m f <color vector>    -- Colors the face f on line n at cell m, faces count from 1
/89 overwrite                                     -- Appends text to the cursor, overwrite existing texts
/89 nooverwrite                                 -- and wrap to the begin of display when reached it's end
/89 linebreak                                     -- Use at your own risk because it uses recursive routine on 16k

On channel 90 goes the text, "/90 hello world" (without quotes) will write
"hello world" on the display (without quotes). 

These commands. on channel 89 and 90, are handled by the ASCII MPU script.
You may change the channel ID's in the script (on top of the script) to something
else, which will not conflict with other ASCII Displays devices in the surrounding area.



Hope you have fun with your new ASCII Display. If you need features,
I need money and others too. You can easily donate me and give me good
ratings, if you like to.

The whole thing is GPL'ed and is governed by the terms of the
GNU Public license. Read the GNU License notecard, thats part of
our deal.


tx Oh

Special thanks go to Saskia McLaglen and  Monk Zymurgy for their supportive nature.
For hosting and patience I like to say thanks to the grid.spinner group. I also say thanks to
Adam Brokken and the whole POEE discordian group for making discordia what it is.