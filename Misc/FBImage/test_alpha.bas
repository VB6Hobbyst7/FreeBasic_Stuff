#include once "FBImage.bi"

' load RGBA png (with alpha channel)

chdir exepath()

screenres 640,480,32 ' RGBA

line (0,0)-step(639,479),&HFF0000FF,BF

var img = LoadRGBAFile("lights_alpha.png")

put (0,0),img,ALPHA ' <- per pixel alpha blending

sleep
ImageDestroy img