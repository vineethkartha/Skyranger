/* Author: Vineeth Kartha
 Date: 21-Jun- 2013
 Name of Work : GUI Library
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

PFont f;

class Button
{
  float x, y;
  float bwidth, bheight;
  String name;
  boolean act;
  PImage butimg, butimg2;

  public Button(String name, float x, float y, float bwidth, float bheight)
  {
    this.x=x;
    this.y=y;
    this.bwidth=bwidth;
    this.bheight=bheight;
    this.name=name;
    f = createFont("guidata/font", 14);
    textFont(f);
    imageMode(CENTER);
    butimg  =loadImage("guidata/button.png");
    butimg2 =loadImage("guidata/button2.png");
  }

  public void display()
  {
    if (act)
    {
      fill(0, 0, 0, 255);
      if (mouseX>x-bwidth/2&&mouseX<x+bwidth/2&&mouseY>y-bheight/2&&mouseY<y+bheight/2)
      {
        image(butimg2, x, y, bwidth, bheight);
      }
      else
        image(butimg, x, y, bwidth, bheight);
      textAlign(CENTER);
      textSize(15);
      text(name, x-textWidth(name)/2+textWidth(name)/2.5, y); //a little tweaking will be needed here if you are changing the size of the button
    }
  }

  public boolean buttonpress()
  {
    if (act&&mouseX>x-bwidth/2 &&mouseX<x+bwidth/2&&mouseY>y-bheight/2&&mouseY<y+bheight/2&&mousePressed)
      return true;
    else
      return false;
  }

  public void activate()
  {
    this.act=true;
  }

  public void deactivate()
  {
    this.act=false;
  }
}

class Disptext
{
  String content;
  float x, y;
  int size;
  public Disptext(String content, float x, float y, int size)
  {
    this.x=x;
    this.y=y;
    this.content=content;
    this.size=size;
  }
  public void displayscore(int score)
  {
    fill(255, 0, 0);
    textSize(size);
    text(content+score, x, y);
  }

  public void displaytext()
  {
    fill(255, 0, 0);
    textSize(size);
    text(content, x, y);
  }
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}
