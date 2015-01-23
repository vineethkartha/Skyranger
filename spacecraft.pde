/* Author: Vineeth Kartha
 Date: 21-Jun- 2013
 Name of Work : Library with spacecraft
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

class Spacecraft
{
  PImage normal, left, right, fired;
  public float x, y;

  public Spacecraft(String normal, String left, String right, String fired, float x, float y)
  {
    imageMode(CENTER);
    this.normal=loadImage(normal);
    this.left=loadImage(left);
    this.right=loadImage(right);
    this.fired=loadImage(fired);
    this.x=x;
    this.y=y;
  } 

  public void display(float xacc, float yacc)
  {
    x+=xacc;
    y+=yacc;
    if (keyPressed&&keyCode==UP)
      image(fired, x, y, width*3/20, height/15);
    else if (keyPressed&&keyCode==DOWN)
      image(normal, x, y, width*3/20, height/15);
    else if (keyPressed&&keyCode==LEFT)
      image(left, x, y, width*3/20, height/15);
    else if (keyPressed&&keyCode==RIGHT)
      image(right, x, y, width*3/20, height/15);
    else
      image(normal, x, y, width*3/20, height/15);

    /*to constrain the craft within the given space*/
    if (x>width-20)
      x=width-20;
    if (x<20)
      x=20;
    if (y<30)
      y=30;
    if (y>height-30)
      y=height-30;
  }
  public int shoot()
  {
    if (keyPressed&& key=='a'||key=='A')
      return 1;
    else if (keyPressed&&key=='d'||key=='D')
      return 2;
    else
      return 0;
  }
  public void spawn()
  {
    x=width/2;
    y=height/2;
  }
}

