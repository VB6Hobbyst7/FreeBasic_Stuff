#include "fbgfx.bi" 
Using FB

' Useful constants (makes your code easier to read and write).
const FALSE = 0
const TRUE = 1

SCREEN 18,16,2,0 ' Sets the graphic mode
SETMOUSE 0,0,0  ' Hides the mouse cursor

DIM SHARED background1 AS ANY PTR ' A pointer that points to a memory
                                  ' buffer holding the background graphics
DIM SHARED WarriorSprite(12) AS ANY PTR ' A pointer that points to a memory
                                        ' buffer holding the warrior sprites
DIM SHARED workpage AS INTEGER
DIM SHARED AS INTEGER Frame1, Frame2

' Let's hide the work page since we are
' going to load program graphics directly
' on the screen.
SCREENSET 1, 0

' Load the background image and store
' it into a memory buffer.
background1 = IMAGECREATE (640, 480)
BLOAD "BACKGRND24bit.bmp", 0
GET (0,0)-(640-1,480-1), background1

CLS ' Clear our screen since we
    ' are loading a new image (not
    ' neccesary but wise).

' Load the sprites onto the screen and store them 
' into an array.
BLOAD "SPRITES24bit.bmp", 0
FOR imagepos AS INTEGER = 1 TO 12
	WarriorSprite(imagepos) = IMAGECREATE (40, 40)
	GET (0+(imagepos-1)*48,0)-(39+(imagepos-1)*48,39),  WarriorSprite(imagepos)
NEXT imagepos

TYPE ObjectType
X          AS SINGLE
Y          AS SINGLE
Speed      AS SINGLE
Frame      AS INTEGER
Direction  AS INTEGER
Move       AS INTEGER
Attack     AS INTEGER
Alive      AS INTEGER
END TYPE

DIM SHARED Player AS ObjectType

' Warrior's (player's) initial
' position, speed (constant)
' and direction (1 = right)
Player.X = 150
Player.Y = 90
Player.Speed = 1
Player.Direction = 1

DO
    
' Player.Direction = 1 -> warrior moving right
' Player.Direction = 2 -> warrior moving left
' Player.Direction = 3 -> warrior moving down
' Player.Direction = 4 -> warrior moving up

Player.Move = FALSE ' By deafult the player is not
                    ' moving.
                    
' According to pushed key move the
' player and flag the proper direction.
IF MULTIKEY(SC_RIGHT) THEN 
    Player.X = Player.X + Player.Speed
    Player.Direction = 1
    Player.Move = TRUE
END IF
IF MULTIKEY(SC_LEFT) THEN 
    Player.X = Player.X - Player.Speed
    Player.Direction = 2
    Player.Move = TRUE
END IF
IF MULTIKEY(SC_DOWN) THEN 
    Player.Y = Player.Y + Player.Speed
    Player.Direction = 3
    Player.Move = TRUE
END IF
IF MULTIKEY(SC_UP) THEN 
    Player.Y = Player.Y - Player.Speed
    Player.Direction = 4
    Player.Move = TRUE
END IF

' The following 4 conditions prevent
' the warrior to walk off the screen.
IF Player.X < 0 THEN 
Player.Move = FALSE
Player.X = 0
END IF
IF Player.X > 600 THEN 
Player.Move = FALSE
Player.X = 600
END IF
IF Player.Y < 0 THEN 
Player.Move = FALSE
Player.Y = 0
END IF
IF Player.Y > 440 THEN 
Player.Move = FALSE
Player.Y = 440
END IF

screenlock ' Lock our screen (nothing will be
           ' displayed until we unlock the screen).
screenset workpage, workpage xor 1 ' Swap work pages.

' Frame1 changes from 1 to 2 or vice versa every
' 16 cycles (set with Frame2 variable).
Frame2 = (Frame2 MOD 16) + 1
IF Frame2 = 10 THEN Frame1 = (Frame1 MOD 2) + 1
IF Player.Move = FALSE OR Frame1 = 0 THEN Frame1 = 1

' According to player's direction flag the 
' proper sprite (check in the tutorial on which
' position each sprite is stored).
IF Player.Direction = 1 THEN Player.Frame = 6 + Frame1
IF Player.Direction = 2 THEN Player.Frame = 4 + Frame1
IF Player.Direction = 3 THEN Player.Frame = 0 + Frame1
IF Player.Direction = 4 THEN Player.Frame = 2 + Frame1

' Pastes the background.
PUT (0, 0), background1, PSET
' Paste the warrior on Player.X and Player.Y coordinates, 
' using sprite number Player.Frame, and skip background color.
PUT (Player.X, Player.Y), WarriorSprite(Player.Frame), TRANS


workpage xor = 1 ' Swap work pages.
screenunlock ' Unlock the page to display what has been drawn.

SLEEP 10, 1 ' Slow down the program and prevent 100 % CPU usage.
    
LOOP UNTIL MULTIKEY(SC_Q) OR MULTIKEY(SC_ESCAPE)

' Destroy our memory buffers before ending the program
' (free memory).
IMAGEDESTROY (background1)
FOR imagepos AS INTEGER = 1 TO 12
IMAGEDESTROY WarriorSprite(imagepos)
NEXT imagepos