/* Author: Vineeth Kartha
 Date: 21-Jun- 2013
 Name of Work : Library with opponents for a game
 Description:  A game where a space craft shoots asteroids. This is the prelimineray work on the project
 */

/*The MIT License (MIT)
 
 //Copyright (c) 2013 Vineeth Kartha
 
 Permission is hereby granted, free of charge, to any person obtaining a copy  of this software and associated documentation files (the "Software"), 
 to deal  in the Software without restriction, including without limitation the rights  to use, copy, modify, merge, publish, distribute, sublicense, 
 and/or sell  copies of the Software, and to permit persons to whom the Software is  furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in  all copies or substantial portions of the Software.
 
 //THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  LIABILITY, 
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

int radius=40;

class Rock
{
  PImage rockimg;
  float rockx, rocky;
  public float xacc, yacc;

  public Rock(String imagefile, float rockx, float rocky, boolean onoff)
  {
    imageMode(CENTER);
    rockimg=loadImage(imagefile);
    this.rockx=rockx;
    this.rocky=rocky;
    if (onoff)
      this.xacc=random(1);
    else
      this.xacc=0;
    this.yacc=random(1);
  }
  public void display()
  {
    image(this.rockimg, this.rockx, this.rocky, width/10, height/10);
    rockx+=xacc;
    rocky+=yacc;
    if ((rockx-radius)<0||(rockx+radius)>width)
    {
      xacc=-xacc;
    }
    if ((rocky-radius)<0||(rocky+radius)>height)
    {
      yacc=-yacc;
    }
  }

  public boolean collidebomb(Bomb b)
  {
    if (distance(b.bx, b.by, this.rockx, this.rocky)<45)
    {
      return true;
    }
    return false;
  }

  public boolean collidecraft(float x, float y)
  {
    if (distance(x, y, this.rockx, this.rocky)<70)
    {
      return true;
    }
    return false;
  }

  public boolean collideuforock(Rock a)
  {
    if (distance(a.rockx, a.rocky, this.rockx, this.rocky)<60)
    {
      return true;
    }
    return false;
  }
  public boolean timetospawn()
  {
    if (spawn<0)
    {
      spawn=100;
      return true;
    }
    else
      return false;
  }
}

