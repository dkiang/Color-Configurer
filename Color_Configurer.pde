/*
  Color_Configurer.pde
 
 Example file using the The Meggy Jr Simplified Library (MJSL)
  from the Meggy Jr RGB library for Arduino
   
 Allows you to configure colors for the Meggy and find out their RGB values. From an idea by Malcolm Wetzstein.
  
 Left Arrow: Red
 Up Arrow: Green
 Right Arrow: Blue
 Button A: Display numerical values
 First column is hundreds, second column is tens, third column is ones.
 Button B: Reset all RGB values to zero.
   
 
 
 Version 1.25 - 12/2/2008
 Copyright (c) 2008 Windell H. Oskay.  All right reserved.
 http://www.evilmadscientist.com/
 
 This library is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this library.  If not, see <http://www.gnu.org/licenses/>.
 	  
 */

 
 
 
 

/*
 * Adapted from "Blink,"  The basic Arduino example.  
 * http://www.arduino.cc/en/Tutorial/Blink
 */

#include <MeggyJrSimple.h>    // Required code, line 1 of 2.
int r; // color values for (r)ed, (g)reen, and (b)lue.
int g;
int b;
boolean changeColorsMode = true; // Controls whether you are changing colors, or displaying values.
int displayMode; // When displaying values, this controls the color of the dots.
int hundreds;
int tens;
int ones;

void setup()                    // run once, when the sketch starts
{
  MeggyJrSimpleSetup();      // Required code, line 2 of 2.
  Serial.begin(9600); // Debug
}

void loop()                     // run over and over again
{
  if (changeColorsMode) changeColors(); // Controls whether you are seeing colors or values.
  else displayValues();
}

void changeColors() // In this mode, the buttons mix differing amounts of r, g, and b.
{
  CheckButtonsDown();
  if (Button_A)
  {
    changeColorsMode = !changeColorsMode; // flip modes if Button A is pressed
  }
  if (Button_Left)
    r++;
    if (r > 255) r = 255; // Keeps this from exceeding the 255 limit.
  if (Button_Up)
    g++;
    if (g > 255) g = 255;
  if (Button_Right)
    b++;
    if (b > 255) b = 255;
  if (Button_B) // Resets all values to zero.
  {
    r = 0;
    g = 0;
    b = 0;
  }
  for (int i = 0; i < 8; i++)
  {
    for (int j = 0; j < 8; j++) // This paints the entire screen with whatever color has been mixed
    {
      DrawPx(i,j,CustomColor1);
      EditColor(CustomColor1,r,g,b); // Creates custom color as an expression of r, g, b values
    }
  }
  DisplaySlate();
  delay(100);
  ClearSlate();
}

void displayValues()
{
  CheckButtonsPress();
  if (Button_A)
  {
    changeColorsMode = !changeColorsMode; // flip modes when Button A is pressed
  }
  for (int i = 0; i < 8; i++)
  {
    DrawPx(2,i,White); // Draw first separator line
  }
    for (int i = 0; i < 8; i++)
  {
    DrawPx(5,i,White); // Draw second separator line
  }
  if (displayMode == 0) // Red
  {
    displayMode++;
    numerate(1,r); // method call to numerate() which expresses the number as a bunch of dots that have meaning
  }
  else if (displayMode == 1)
  {
    displayMode++;
    numerate(4,g);
  }
  else if (displayMode == 2)
  {
    displayMode = 0;
    numerate(5,b);
  }
}

void numerate(int color, int value)
{
  hundreds = value/100; // This is supposed to draw the number out as a series of hundreds, tens and ones
  for (int i = 0; i < hundreds; i++)
    DrawPx(1,i,color);
  tens = value%100;
  ones = tens%10;
  tens = (tens-ones)/10;
  if (tens > 5)
  {
    for (int i = 0; i < 5; i++)
    {
      DrawPx(3,i,color);
    }
    tens -= 5;
  }
  for (int i = 0; i < tens; i++)
    DrawPx(4,i,color);
  if (ones > 5)
  {
    for (int i = 0; i < 5; i++)
    {
      DrawPx(6,i,color);
    }
    ones -= 5;
  }
  for (int i = 0; i < ones; i++)
    DrawPx(7,i,color);
  DisplaySlate();
  delay(1000);
  ClearSlate();
}
