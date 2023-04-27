int tamanho = 7;
int contador = 0;
int borda;

import processing.video.*;
Capture cam;

void setup() {
  size(640, 480); //referente à resolução da camera
  cameraStart();
}

void draw() {
  cameraFiltro();
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
  if (cam.available() == true) {
    cam.read();
  }
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
