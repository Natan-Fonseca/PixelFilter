int tamanhoPixel = 7;
int contador = 0;
PImage imgResult;

import processing.video.*;
Capture cam;

int escolha = 32;
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


void setup() {
  size(640, 480); //referente à resolução da camera
  cameraStart();
  paleta();
  imgResult = createImage(cam.width, cam.height, RGB);// cria uma imagem resultado
}

void draw() {
  cameraFiltro();
  video();
  compara();
  grid();
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

void grid() {
  // loop para percorrer todos os blocos
  for (int i=0; i<cam.width; i+=tamanhoPixel) {
    for (int j=0; j<cam.height; j+=tamanhoPixel) {
      // caso contador seja par, cria um rect sem fill do mesmo tamanho que o pixel
      if (contador%2==0) {
        noFill();
        rect(i, j, tamanhoPixel, tamanhoPixel);
      }
    }
  }
}

void cameraFiltro() {
  if (cam.available() == true) {
    cam.read();
  }
  // loop para percorrer todos os blocos
  for (int x = 0; x < cam.width; x += tamanhoPixel) {
    for (int y = 0; y < cam.height; y += tamanhoPixel) {

      // variáveis para armazenar as médias de R, G e B
      float mediaR = 0;
      float mediaG = 0;
      float mediaB = 0;

      // loop para percorrer todos os pixels dentro do bloco
      for (int i = x; i < x + tamanhoPixel; i++) {
        for (int j = y; j < y + tamanhoPixel; j++) {
          // obtém a cor do pixel (i,j)
          color pixelCor = cam.get(i, j);
          mediaR += red(pixelCor); // soma a componente vermelha
          mediaG += green(pixelCor); // soma a componente verde
          mediaB += blue(pixelCor); // soma a componente azul
        }
      }

      // calcula as médias de R, G e B para o bloco
      mediaR /= sq(tamanhoPixel);
      mediaG /= sq(tamanhoPixel);
      mediaB /= sq(tamanhoPixel);

      // loop para preencher todo o bloco com a cor média
      for (int i = x; i < x + tamanhoPixel; i++) {
        for (int j = y; j < y + tamanhoPixel; j++) {
          // define a cor média para o pixel (i,j)
          imgResult.set(i, j, color(mediaR, mediaG, mediaB));
        }
      }
    }
  }
  
}

void keyPressed() {
  if (keyCode==UP) {
    tamanhoPixel++; // caso aperte a seta para cima, aumenta o tamanho do pixel
  } else if (keyCode==DOWN && tamanhoPixel>1) {
    tamanhoPixel--; // caso aperte a seta para baixo, diminui o tamanho do pixel
  } else if (keyCode==' ') {
    contador++; // caso aperte espaço, aparece ou desaparece o grid
  }
}

void video() {
  dimension = imgResult.width * imgResult.height;
  r = new float[dimension];
  g = new float[dimension];
  b = new float[dimension];
  for (int i=0; i<dimension; i++) {
    r[i]= red(imgResult.pixels[i]);
    g[i]= green(imgResult.pixels[i]);
    b[i]= blue(imgResult.pixels[i]);
  }
}

void compara() {
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
    imgResult.pixels[i] = guardacor;
  }
  image(imgResult, 0, 0);
}


void paleta() {
  for (int i=0; i<escolha; i++) {
    cores[i]= color(random(256), random(256), random(256));
    red[i]= red(cores[i]);
    green[i]=green(cores[i]);
    blue[i]=blue(cores[i]);
  }
}
