int escolha = 32; // escolha quantas cores terão na paleta //<>//
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

PImage img;
void setup() {
  size(800, 438);
  imagem();
  paleta();
  comparaCores();
  
}

void draw() {
  image(img, 0, 0, img.width/2, img.height/2);
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

void imagem() {
  img = loadImage("Klaus.png");
  dimension = img.width * img.height;
  r = new float[dimension];
  g = new float[dimension];
  b = new float[dimension];
  img.loadPixels();
  for (int i=0; i<dimension; i++) {
    r[i]= red(img.pixels[i]);
    g[i]= green(img.pixels[i]);
    b[i]= blue(img.pixels[i]);
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
    img.pixels[i] = guardacor;
  }
}
