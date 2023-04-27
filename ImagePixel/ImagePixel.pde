int tamanho = 7; //<>//
int contador = 0;
int borda;
PImage img;

void settings() {
  img = loadImage("Klaus.png");
  size(img.width, img.height);
}

void draw() {
  for (int i=0; i<img.width; i+=tamanho) {
    for (int j=0; j<img.height; j+=tamanho) {
      color cor = img.get(i, j);
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

void keyPressed() {
  if (keyCode==UP) {
    tamanho++;
  } else if (keyCode==DOWN && tamanho>1) {
    tamanho--;
  } else if (keyCode==' ') {
    contador++;
  }
}
