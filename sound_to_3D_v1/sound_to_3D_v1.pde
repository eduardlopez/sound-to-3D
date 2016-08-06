/*
  CREATED BY EDUARD LOPEZ GARCIA
  CREADO POR EDUARD LOPEZ GARCIA
  
  eduardlopez.com
  info@eduardlopez.com
  github.com/eduardlopez
  twitter.com/eduardlopez
  fb.com/eduardlopez
  youtube.com/c/eduardlopezg
*/


import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioPlayer jingle;
FFT         fft;



int largadaPista = 500;
int anchuraPista = -200;
int alturaMaximPista = -200;

int separacion = 20;
int separacionAcumulada = 0;
int alturaElementoIntermedio = -40;


int numDeMuestras = 500;
float[][] valores = new float[numDeMuestras][2];

void setup() {
  size(1920, 1080, P3D); 
  //lights();


  for (int i = 0; i < valores.length-1; i++) {
    valores[i][0] = map(i, 0, numDeMuestras-1, 0, largadaPista);
    valores[i][1] = 0;//random(20, 150);
  }
  valores[valores.length-1][0] = largadaPista;
  valores[valores.length-1][1] = 0;//random(20, 150);
  smooth(8);
  //noSmooth();

  minim = new Minim(this);
  jingle = minim.loadFile("a.mp3");
  jingle.loop();
  fft = new FFT( jingle.bufferSize(), jingle.sampleRate() );
}




int j = 0;

float rotationY = 0;
boolean rotationYInverse = false;

boolean rotacionXHaciaAtras = false;
float rotacionXvalor = -0.2;

boolean rotacionYHaciaAtras = false;
float rotacionYvalor = -0.2;





void draw() {


  float incremento = 0;
  fft.forward( jingle.mix );
  /*
  background(0);
   lights();
   noStroke();
   pushMatrix();
   translate(width/2, height/2, 0);
   rotateY(rotationY);
   rotateX(-0.2);
   box(200, 100, 250);
   popMatrix();
   rotationY = rotationY+0.01;
   */

  background(230);
  
  lights();

  pushMatrix();

  
  translate(width/3, height/2, 600);
  stroke(0);
  //rotateX(mouseX/250);
  //rotateY(mouseY/100);
  //rotateX(-0.2);
  //rotateY(-0.3);
  //scale(1.25);
  fill(255);

  if (rotacionXHaciaAtras==false) {
    rotacionXvalor -= 0.002;
    rotateX(rotacionXvalor);
    if (rotacionXvalor < -0.6) {
      rotacionXHaciaAtras = true;
    }
  } else {
    rotacionXvalor += 0.002;
    rotateX(rotacionXvalor);
    if (rotacionXvalor > 0.10) {
      rotacionXHaciaAtras = false;
    }
  }
  
  
  if (rotacionYHaciaAtras==false) {
    rotacionYvalor -= 0.002;
    rotateY(rotacionXvalor);
    if (rotacionXvalor < -0.4) {
      rotacionXHaciaAtras = true;
    }
  } else {
    rotacionYvalor += 0.002;
    rotateY(rotacionYvalor);
    if (rotacionYvalor > 1) {
      rotacionXHaciaAtras = false;
    }
  }


  beginShape();  
  vertex( 0, 0, 0);
  vertex( 0, 0, anchuraPista);
  vertex( largadaPista, 0, anchuraPista);
  vertex( largadaPista, 0, 0);
  endShape();


  
  for (int i = 0; i < fft.specSize (); i++)
  {
    incremento += fft.getBand(i);
    //line( i, height, i, height - fft.getBand(i)*8 );
    
  }

  incremento = incremento / 10; /* ############################ MODIFICAR EL NUMERO PARA CAMBIAR LA ALTURA DE LA VISUALIZACION */

  float x, y;

  /*
  anchuraPista = 0;
  for (int i = 0; i < valores.length; i++) {
    y = -valores[i][1]; 
    anchuraPista += y; 
  }
  
  anchuraPista = anchuraPista /50;
  */  
  
  
  for (int i = 0; i < valores.length; i++) {
    //valores[i][1] = incremento;//random(20, 100);
    x = valores[i][0];
    y = -valores[i][1]; 
   
    beginShape(); 
    valores[i][1] = lerp(valores[i][1], 0, 0.005);
    //fill(valores[i][1]);
    vertex( x, 0, 0);
    vertex( x, y, 0);
    vertex( x, y, anchuraPista);
    vertex( x, 0, anchuraPista);
    endShape();

  
  }
  
  
  


  valores[j][1] = incremento;

  //rotationY += 0.02;

  //print(rotationY );

  //vertex( 0, alturaMaximPista, anchuraPista);

  popMatrix();

  stroke(255, 0, 0);
  line( j, height, j, height - incremento );
  //println(frameRate);
  j++;

  if (j>=valores.length) {
    j = 0;
  }
}