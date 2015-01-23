/* Author: Vineeth Kartha
 Date: 21-Jun- 2013
 Name of Work : Space shoot
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

/* RADIUS OF BULLET-8
 RADIUS OF SPACE CRAFT-35
 RADIUS OF ROCK- 73 */

import  java.io.*;
Maxim maxim;

AudioPlayer shoot, accelerate, side, smallexp, bigexp;
AudioPlayer click, intro;


Button start, about, helpb, menub, volb, contactb, hscrb;  //menu buttons
HScrollbar vol; //Slider to adjust volume.

Disptext scr;   //To display score

Spacecraft craft; //Player's space ship

PrintWriter scrfile;

String [] scrline;
String[] lines;
String playername = "Enter your name";

PImage bg, debris, logo; 
PImage planenormal, bmnos; 
PImage [] explode;
PImage []atmexplode;

ArrayList<Bomb> bombs;
ArrayList<Atombomb> atmbmbs;
ArrayList<Rock> rocks, alien;

int WIDTH=500, HEIGHT=700;

int count=0, high; //to count the animation frames

int once=1, i=0, debanim=0; //a general variable for loops and also for the background animation of debris

float ax, ay;

int atmbcount=0;

float accx=0, accy=0;
float friction=0.5;
float expx, expy; // to mark the location or the explosion animation

boolean explosionsmall=false, explosionbig=false, gameover=false, in=false;

boolean abt=false, playing=false, menu=true, help=false, volume=false, contact=false, hscr=false; // to detect which menu option is selected
int spawn=100;

int health=0, score=0;

/* function to find the vector distatnce between two points*/
float distance(float x1, float y1, float x2, float y2)
{
  return(sqrt(abs(sq(x2-x1)+sq(y2-y1))));
}

void setup() 
{
  maxim = new Maxim(this);

  shoot = maxim.loadFile("shot.wav");
  shoot.setLooping(false);
  accelerate = maxim.loadFile("thrust.wav");
  accelerate.setLooping(false);
  side = maxim.loadFile("thrustside.wav");
  side.setLooping(false);

  smallexp = maxim.loadFile("smallexp.wav");
  smallexp.setLooping(false);
  bigexp = maxim.loadFile("bigexp.wav");
  bigexp.setLooping(false);

  click = maxim.loadFile("click.wav");
  click.setLooping(false);
  intro = maxim.loadFile("intro.wav");
  intro.setLooping(true);
  intro.speed(0.8);

  /* Back ground image and animation*/
  bg = loadImage("backgnd.jpg");
  debris=loadImage("debris.png");

  /*images for health and remaining b-bombs*/
  planenormal=loadImage("data/plane1.png");
  bmnos=loadImage("data/atmbmb.png");

  logo=loadImage("data/logo2.png");

  explode=loadImages("data/explosion", ".png", 6); //the images needed for explosion animation
  atmexplode=loadImages("data/exp", ".png", 15);

  bombs=new ArrayList<Bomb>();
  atmbmbs=new ArrayList<Atombomb>();
  rocks=new ArrayList<Rock>();
  alien=new ArrayList<Rock>(); 
  size(WIDTH, HEIGHT);

  imageMode(CENTER);

  start=new Button("Play", width/2, height/2-(height/12), width*3/10, height/12);
  helpb=new Button("Help", width/2, height/2, width*3/10, height/12);
  about=new Button("About", width/2, height/2+(height/12), width*3/10, height/12);
  volb=new Button("Volume", width/2, height/2+(height/6), width*3/10, height/12);
  menub=new Button("Menu", width/2, height/2+(height/3), width*3/10, height/12);
  contactb=new Button("Contact Me", width/2, height/2+(height/6), width*3/10, height/12);
  hscrb=new Button("HIGH SCORES", width/2, height/2+(height/4), width*3/10, height/12);

  vol = new HScrollbar(width/8, height/2-8, width-width/4, 16, 16);

  scr=new Disptext("SCORE:", textWidth("SCORE"), textWidth("SCORE")/2, 14);

  craft=new Spacecraft("data/plane1.png", "data/planeleft.png", "data/planeright.png", "data/plane2.png", width/2, height/2);
}

void draw()
{
  spawn--;
  if (spawn<0)
  {
    float spawnx=random(width-80), spawny=random(height-80);
    if (distance(craft.x, craft.y, spawnx, spawny)>100 && rocks.size()<14 && alien.size()<10)   //This part of the code ensures that the newly spawned rock or alien ship does not collide with the spacecraft
    {
      spawn=160-score*2; 
      if (spawn%4==0)
      {
        alien.add(new Rock("data/ufo.png", spawnx, 70, false));
      }
      else
        rocks.add(new Rock("data/rock.png", spawnx, spawny, true));
    }
  }
  if (start.buttonpress())
  {
    playing=true;
    abt=false;
    help=false;
    menu=false;
    volume=false;
    contact=false;
    hscr=false;
    health=2;
    score=0;
    atmbcount=0;
    click.play();
  }
  if (helpb.buttonpress())
  {

    playing=false;
    abt=false;
    help=true;
    menu=false;
    volume=false;
    contact=false;
    hscr=false;
    click.play();
  }
  if (about.buttonpress())
  {
    playing=false;
    abt=true;
    help=false;
    menu=false;
    volume=false;
    contact=true;
    hscr=false;
    click.play();
  }
  if (contactb.buttonpress())
  {
    playing=false;
    abt=true;
    help=false;
    menu=false;
    volume=false;
    contact=false;
    hscr=false;
    click.play();
    link("http://www.thebeautifullmind.com");
  }
  if (menub.buttonpress())
  {
    playing=false;
    abt=false;
    help=false;
    menu=true;
    volume=false;
    contact=false;
    gameover=false;
    hscr=false;
    click.play();
    intro.cue(0);
  }
  if (volb.buttonpress())
  {
    playing=false;
    abt=false;
    help=false;
    menu=false;
    volume=true;
    contact=false;
    hscr=false;
    click.play();
    intro.cue(0);
  }
  if (hscrb.buttonpress())
  {
    playing=false;
    abt=false;
    help=false;
    menu=false;
    volume=false;
    contact=false;
    gameover=false;
    hscr=true;
    click.play();
    intro.cue(0);
  }
  if (menu) //Menu to be displayed before the game starts
  {
    tint(255, 255, 255);
    intro.play();
    start.activate();
    helpb.activate();
    about.activate();
    volb.activate();
    hscrb.activate();
    contactb.deactivate();
    menub.deactivate();
    image(bg, width/2, height/2, width, height);
    image(logo, width/2, height/5, logo.width/2, logo.height/2);
    Disptext s=new Disptext("SCORE: ", width/2, height/8, 24);
    start.display();
    helpb.display();
    about.display();
    volb.display();
    hscrb.display();
    s.displayscore(score);
    accelerate.stop(); // stop the sounds
    side.stop();
    bigexp.stop();
    smallexp.stop();
    once=1;
  }
  else
    intro.stop();
  if (abt)
  {
    background(0);
    start.deactivate();
    helpb.deactivate();
    about.deactivate();
    volb.deactivate();
    hscrb.deactivate();
    contactb.activate();
    menub.activate();
    Disptext tex1=new Disptext("*****SKY RANGER*****", width/2, height/4, 16);
    Disptext tex2=new Disptext("Created by Vineeth Kartha", width/2, height/4+18, 16);
    Disptext tex3=new Disptext("Original idea borrowed from the game Rice Rocks", width/2, height/4+36, 16);
    Disptext tex4=new Disptext("The game is released under MIT License", width/2, height/4+72, 16);
    Disptext tex5=new Disptext("Copyright (c) 2013 Vineeth Kartha", width/2, height/4+90, 16);
    tex1.displaytext();
    tex2.displaytext();
    tex3.displaytext();
    tex4.displaytext();
    tex5.displaytext();
    menub.display();
    contactb.display();
  }
  if (help)
  {
    background(0);
    start.deactivate();
    helpb.deactivate();
    about.deactivate();
    volb.deactivate();
    hscrb.deactivate();
    contactb.deactivate();
    menub.activate();
    Disptext tex1=new Disptext("Use the Up, Down, left and right keysto steer the spacecraft.", width/2, height/4, 16);
    Disptext tex2=new Disptext("The key 'a' shoots normal bullets and 'd' drops bigger bombs.", width/2, height/4+18, 16);
    Disptext tex3=new Disptext("Press the SHIFT key to go back to the menu", width/2, height/4+36, 16);
    Disptext tex4=new Disptext("The remaining lives displayed on top right ", width/2, height/4+54, 16);
    Disptext tex5=new Disptext("And the remeaning b-Bombs are displayed on bottom right", width/2, height/4+72, 16);
    tex1.displaytext();
    tex2.displaytext();
    tex3.displaytext();
    tex4.displaytext();
    tex5.displaytext();
    menub.display();
  }

  if (volume)
  {
    intro.play();
    background(0);
    start.deactivate();
    helpb.deactivate();
    about.deactivate();
    volb.deactivate();
    hscrb.deactivate();
    contactb.deactivate();
    menub.activate();
    vol.update();
    vol.display();

    shoot.volume(vol.getPos()/width);
    accelerate.volume(vol.getPos()/width);
    side.volume(vol.getPos()/width);
    smallexp.volume(vol.getPos()/width);
    bigexp.volume(vol.getPos()/width);
    click.volume(vol.getPos()/width);
    intro.volume(vol.getPos()/width);
    menub.display();
  }
  if (contact)
  {
    start.deactivate();
    helpb.deactivate();
    about.deactivate();
    volb.deactivate();
    hscrb.deactivate();
    contactb.activate();
    menub.activate();
    menub.display();
  }
  if (gameover)
  {
    //background(0);
    start.deactivate();
    helpb.deactivate();
    about.deactivate();
    volb.deactivate();
    hscrb.deactivate();
    contactb.deactivate();
    menub.activate();
    menub.display();
    background(255);
    fill(255, 0, 255);
    lines = loadStrings("data/scores.txt");
    for (i=0;i<lines.length;i++) 
    {
      String[] pieces = split(lines[i], ":");
      high=int(pieces[1]);
    }
    if (in && high<score)
    {
      if (keyCode==ENTER||keyCode==RETURN)
      {
        once=0;
        in=false;
      }
      text(playername+(frameCount/10 % 2 == 0 ? "_" : ""), width/2, height/8);
    }
    if (once==0&&high<score)
    {
      scrfile = createWriter("data/scores.txt");
      scrfile.println(playername+":"+score);
      scrfile.flush();
      scrfile.close();
      once++;
    }

    scrline = loadStrings("data/scores.txt");
    for (i=0;i<scrline.length;i++)
    {
      textSize(16);
      text(scrline[i], width/2, height/4+i*15);
    }
    menub.activate();
    menub.display();
  }
  if (hscr)
  {
    tint(0, 0, 124);
    image(bg, width/2, height/2);
    scrline = loadStrings("data/scores.txt");
    for (i=0;i<scrline.length;i++)
    {
      textSize(16);
      text(scrline[i], width/2, height/4+i*15);
    }
    start.deactivate();
    helpb.deactivate();
    about.deactivate();
    volb.deactivate();
    contactb.deactivate();
    hscrb.deactivate();
    menub.activate();
    menub.display();
  }
  if (playing)
  {
    in=true;
    playername = "Enter your name";
    gameover=false;
    start.deactivate();
    helpb.deactivate();
    about.deactivate();
    volb.deactivate();
    menub.deactivate();
    if (!keyPressed)
    {
      accelerate.stop();
      side.stop();
      if (accx>0)
        accx-=friction;
      else if (accx<0)
        accx+=friction;
      else
        accx=0;
      if (accy>0)
        accy-=friction;
      else if (accy<0)
        accy+=friction;
      else
        accy=0;
    }

    image(bg, width/2, height/2, width, height);

    for (i=0;i<health;i++)   //show the remaining lives at top right of the screen
    {
      image(planenormal, width/2+width/8+i*planenormal.width/2, planenormal.height/2, planenormal.width/2, planenormal.height/2);
    }

    for (i=0;i<5-atmbcount;i++)   //show the remaining Big Bombs that you have at the bottom right corner of the screen
    {
      image(bmnos, width/2+width/4+i*bmnos.width*3, height-bmnos.height/2, bmnos.width*2, bmnos.height*2);
    }


    /*collison of ufo and rocks*/
    for (i=rocks.size()-1;i>=0;i--)
    {
      Rock r=rocks.get(i);
      for (int j=alien.size()-1;j>=0;j--)
      {
        Rock a=alien.get(j);
        if (r.collideuforock(a))       //collision of alien ship with asteroids is detected and alien ship bounces off it
        {
          a.xacc=-a.xacc;
          a.yacc=-a.yacc;
        }
      }
    }

    /*Collison of rocks and space craft*/
    for (i=rocks.size()-1;i>=0;i--)
    {
      Rock r=rocks.get(i);
      r.display();
      if (r.collidecraft(craft.x, craft.y))
      {
        expx=r.rockx;
        expy=r.rocky;
        rocks.remove(i);
        craft.spawn();
        explosionsmall=true;
        health--;
      }
    }

    /*collison of UFO with spacecraft*/
    for (i=alien.size()-1;i>=0;i--)
    {
      Rock r=alien.get(i);
      r.display();
      if (r.collidecraft(craft.x, craft.y))
      {
        expx=r.rockx;
        expy=r.rocky;
        alien.remove(i);
        craft.spawn();
        explosionsmall=true;
        health--;
      }
    }
    craft.display(accx, accy);

    /*collison of bomb with rocks*/
    for (i=bombs.size()-1;i>=0;i--)
    {
      Bomb b=bombs.get(i);
      b.display();
      if (b.bombend())
        bombs.remove(i);
      for (int j=rocks.size()-1;j>=0;j--)
      {
        Rock r=rocks.get(j);
        if (r.collidebomb(b))
        {
          smallexp.play();
          explosionsmall=true;
          expx=r.rockx;
          expy=r.rocky;
          rocks.remove(j);
          bombs.remove(i);
          score++;
        }
      }

      for (int j=alien.size()-1;j>=0;j--)
      {
        Rock r=alien.get(j);
        if (r.collidebomb(b))
        {
          smallexp.play();
          explosionsmall=true;
          expx=r.rockx;
          expy=r.rocky;
          alien.remove(j);
          bombs.remove(i);
          score++;
        }
      }
    }

    //Atom Bomb
    for (i=atmbmbs.size()-1;i>=0;i--)
    {
      Atombomb b=atmbmbs.get(i);
      b.display();
      if (b.bombend())
        atmbmbs.remove(i);
      for (int j=rocks.size()-1;j>=0;j--)
      {
        Rock r=rocks.get(j);
        if (r.collidebomb(b))
        {
          bigexp.play();
          ax=b.bx;
          ay=b.by;
          explosionbig=true;
          expx=r.rockx;
          expy=r.rocky;
          atmbmbs.remove(i);
          score++;
        }
        if (explosionbig)
        {
          if (r.rocky>=ay)
          {
            rocks.remove(j);
            score++;
          }
          count=0;
        }
      }


      for (int j=alien.size()-1;j>=0;j--)
      {
        Rock r=alien.get(j);
        if (r.collidebomb(b))
        {
          bigexp.play();
          ax=b.bx;
          ay=b.by;
          explosionbig=true;
          expx=r.rockx;
          expy=r.rocky;
          atmbmbs.remove(i);
          score++;
        }
        if (explosionbig)
        {
          if (distance(ax, ay, r.rockx, r.rocky)<300)
          {
            alien.remove(j);
            score++;
          }
          count=0;
        }
      }
    }

    if (explosionsmall && count<explode.length)
    {
      image(explode[count], expx, expy, explode[count].width, explode[count].height);
      count+=1;
    }
    else if (explosionbig && count<atmexplode.length)
    {
      image(atmexplode[count], expx, expy, atmexplode[count].width*3, atmexplode[count].height*3);
      count+=1;
    }
    else if ((count>=explode.length || count>=atmexplode.length) && health<=0)
    {
      playing=false;
      menu=true;
      explosionsmall=false;
      explosionbig=false;
      count=0;
      bigexp.stop();
      gameover=true;
    }
    else
    {
      explosionsmall=false;
      explosionbig=false;
      count=0;
    }
  }
  scr.displayscore(score);
  image(debris, 0, 0+debanim, width+debanim, height);
  debanim++;

  if (debanim>height)  // to restart the background debris animation
    debanim=0;
}

void keyPressed()
{
  if (keyCode==LEFT)   //leftward movemnt of space craft
  {
    side.play();
    if (accx<2)
      accx-=0.5;
  }

  if (keyCode==RIGHT)  //rightward movement of space craft
  {
    side.play();
    if (accx<2)
      accx+=1;
  }
  if (keyCode==UP)  //upward movement of space craft
  {
    accelerate.play();
    if (accy<2)
      accy-=0.9;
  }

  if (keyCode==DOWN)  //downward movement of space craft
  {
    side.play();
    if (accy<5)
      accy+=0.5;
  }
  if (keyCode==SHIFT)  //downward movement of space craft
  {
    playing=false;
    abt=false;
    help=false;
    menu=true;
    volume=false;
    contact=false;
    click.play();
    intro.cue(0);
  }
  if (craft.shoot()==1) //shooting bombs
  {
    shoot.play();
    bombs.add(new Bomb("bomb1.png", craft.x, craft.y));
  }
  if (craft.shoot()==2&&atmbcount<5) //droping atombombs only 5 atom bombs are allowed
  {
    atmbcount++;
    shoot.play();
    atmbmbs.add(new Atombomb("atmbmb.png", craft.x, craft.y));
  }
}

void keyReleased() 
{
  if (key!=CODED&&in)
  {
    switch(key) 
    {
    case BACKSPACE:
      playername = playername.substring(0, max(0, playername.length()-1));
      break;
    case RETURN:
    case ENTER:
    case TAB:
      playername += "    ";
      break;
    default:
      playername += key;
    }
  }
}

