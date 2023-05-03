int escolha = 32; // escolha quantas cores terão na paleta
color[] cores = new color[escolha];
float[] red = new float[escolha];
float[] green = new float[escolha];
float[] blue = new float[escolha];

float[] r;
float[] g;
float[] b;

float[] distance= new float[escolha];
int dimension;
color guardacor;

int tamanho = 7;
int contador = 0;
int borda;

import processing.video.*;
Capture cam;

void setup() {
  size(640, 480); //referente à resolução da camera
  cameraStart();
  paleta();
  
}

void draw() {
  video();
  comparaCores();
  //cameraFiltro();
  image(cam, 0, 0); // Para aplicar o efeito de pixelização junto com a posterização, comentar essa linha e descomentar a linha acima.
}

void keyPressed() {
  if (keyCode==UP) {
    tamanho++;
  } else if (keyCode==DOWN && tamanho>1) {
    tamanho--;
  } else if (keyCode==' ') {
    contador++;
  }
}

void cameraStart() {
  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
}

void cameraFiltro(){
  for (int i=0; i<cam.width; i+=tamanho) {
    for (int j=0; j<cam.height; j+=tamanho) {
      color cor = cam.get(i, j);
      fill(cor);
      if (contador%2==0) {
        borda=cor;
      } else {
        borda=0;
      }
      stroke(borda);
      rect(i, j, tamanho, tamanho);
    }
  }
}

void video() {
  if (cam.available() == true) {
    cam.read();
  }
  dimension = cam.width * cam.height;
  r = new float[dimension];
  g = new float[dimension];
  b = new float[dimension];
  cam.loadPixels();
  for (int i=0; i<dimension; i++) {
    r[i]= red(cam.pixels[i]);
    g[i]= green(cam.pixels[i]);
    b[i]= blue(cam.pixels[i]);
  }
}

void comparaCores() {
  for (int i=0; i<dimension; i++) {
    for (int j=0; j<escolha; j++) {
      distance[j]= sqrt((sq(r[i]-red[j]))+(sq(g[i]-green[j]))+(sq(b[i]-blue[j])));
    }
    float min = min(distance);
    for (int j=0; j<escolha; j++) {
      if (distance[j]==min) {
        guardacor = cores[j];
      }
    }
    cam.pixels[i] = guardacor;
  }
}

void paleta() {
  for (int i=0; i<escolha; i++) {
    cores[i]= color(random(256), random(256), random(256));
    red[i]= red(cores[i]);
    green[i]=green(cores[i]);
    blue[i]=blue(cores[i]);



    //fill(cores[i]);
    //rect(i*50, 500, 50, 200);
  }
}
