/* //<>//
  CREATED BY EDUARD LOPEZ GARCIA
  CREADO POR EDUARD LOPEZ GARCIA
  
  eduardlopez.com
  info@eduardlopez.com
  github.com/eduardlopez
  twitter.com/eduardlopez
  fb.com/eduardlopez
  youtube.com/c/eduardlopezg
*/


import ddf.minim.*; //<>//
import ddf.minim.analysis.*;

import unlekker.modelbuilder.*;
UGeometry model = new UGeometry();
UGeometry sector = new UGeometry();

Minim minim;
AudioPlayer song;
FFT fft;


void setup()
{
  size(1920, 1080, P3D);

  // always start Minim first!
  minim = new Minim(this);

  // specify 512 for the length of the sample buffers
  // the default buffer size is 1024
  song = minim.loadFile("a.mp3", 512);

  

  // an FFT needs to know how 
  // long the audio buffers it will be analyzing are
  // and also needs to know 
  // the sample rate of the audio it is analyzing
  fft = new FFT(song.bufferSize(), song.sampleRate());
  background(255);
  frameRate(50);


  smooth(8);

  /*UVec3 ptA = new UVec3(0, 0, 0);
  UVec3 ptB = new UVec3(0, 100, 0);
  UVec3 ptC = new UVec3(100, 100, 0);
  UVec3 ptD = new UVec3(100, 0, 0);

  UVec3[][] face = { {ptA, ptB, ptC, ptD} };
*/
  
  
  
  
   
  

  
  
}



int zoomX = 0;

float[][] freq = new float[8400][256];
float[][] freqRes = new float[8400][60];
int frame = 0;
float amplitud = 1;

float space = width/58;
void draw()
{

  background(255, 200);
  // first perform a forward fft on one of song's buffers
  // I'm using the mix buffer
  //  but you can use any one you like
  fft.forward(song.mix);

  stroke(0);
  strokeWeight(3);
  // draw the spectrum as a series of vertical lines
  // I multiple the value of getBand by 4 
  // so that we can see the lines better
  int pos = (128);
  int turn = 1;
  //println(fft.specSize());

  freq[frame][pos] = int( fft.getBand(0)*2 );
  for (int i = 1; i < 128-1; i=i+1)
  {
    freq[frame][pos+i] = int( fft.getBand(i)*2 );
    freq[frame][pos-i] = int( fft.getBand(i+1)*2 );    
    //println(i);
  }


  for (int i = 0; i < 256-1; i++)
  {
    if (i==256-1-1) { 
      stroke(255, 0, 0);
    }
    point(i+space*i, height-10 - freq[frame][i]*amplitud-10 );
    line(i+space*i, height-10 - freq[frame][i]-50, i+space*(i+1), height-10 - freq[frame][i+1]*amplitud-10 );
  }




  strokeWeight(1);
  //freqRes[30] = freq[128];
  for (int i = 0; i < 60; i=i+1)
  {  
    int a = (256/2) - (60/2);
    freqRes[frame][i] = freq[frame][a+i];
    //freqRes[i] = freq[a-i];    
    //println(i);
  }

  stroke(0);

  pushMatrix();
  strokeWeight(0.5);
  //ortho();
  translate(width/3, (height/2)-70, 600); //translate(width/10, height/2, 0)

  //rotateX(map(mouseY, 0, height, -PI/2, PI/2));
  //rotateY(map(mouseX, 0, width, -PI/2, PI/2));
  rotateX(-PI/7);
  rotateY(PI/3);
  //for(int i = 0; i < 60-1; i++)
  for (int i = 0; i < 60-1; i++) {
    for (int j = 0; j < frame; j++) {

      line( i*space*2, -freqRes[j][i]*amplitud, j, i*space*2, -freqRes[j+1][i]*amplitud, j+1 );
    }
  }

  /*
  for(int j = 0; j < frame; j++){
   for(int i = 0; i < 60-1; i++)
   {
   //if(i==60-1-1){ stroke(255,0,0); }
   //point(i+space*i,  -freqRes[j][i], j);
   line(i+space*i, - freqRes[j][i], j,    i+space*(i+1), - freqRes[j][i+1], j );
   
   //point(i+space*i,  height-50 - freqRes[frame][i]);
   //line(i+space*i, height-50 - freqRes[frame][i], i+space*(i+1), height-50 - freqRes[frame][i+1] );
   }
   }*/

  hint(ENABLE_DEPTH_TEST);
  model.draw(this);
  hint(DISABLE_DEPTH_TEST);

   model.draw(this);

  popMatrix();
   model.draw(this);

  frame = frame + 1;
  
  if(frame>500){frame = 0;}
  
  if(song.isPlaying()==false){ song.play(); }
  println( song.isPlaying());
}




public void keyPressed() {
  if (key=='s') {
    /*model = new UGeometry();*/
    /*
    model.beginShape(TRIANGLE_FAN); //<>// //<>//

    model.vertex(0, 0, 0);
    model.vertex(0, 100, 0);
    model.vertex(100, 100, 0);
    //model.vertex(500, 100, 0);
    //model.vertex(50, 50, 0);
    //model.vertex(100, 0, 0);
    //model.vertex(0, 0, 0);
  
    sector.endShape();
    */
    
    //sector.beginShape(QUADS);

    sector.vertex(0, 0, 0);
    sector.vertex(100, -400, 0);
    model.add(sector);
    sector.vertex(200, -100, 0);
    model.add(sector);
    sector.vertex(300, -300, 0);
    model.add(sector);
    sector.vertex(400, -300, 0);
    model.add(sector);
    sector.vertex(500, 0, 0);
    model.add(sector);
    //
    //model.vertex(100, 0, 0);
    //model.vertex(0, 0, 0);
  
    //sector.endShape();
  
    
    model.add(sector);
    
    model.draw(this);
     
    model.writeSTL(this, "Pyramids.stl");
    println("STL written");
  
    
  }
}





void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e < 0) {
    zoomX = zoomX + 10;
  } else {
    zoomX = zoomX - 10;
  }
  //println(e);
}