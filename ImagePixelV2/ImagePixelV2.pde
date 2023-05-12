PImage img; // variável que armazena a imagem a ser processada
PImage imgResult; // variável que armazena a imagem resultante com o filtro já aplicado
int tamanhoPixel = 7; // tamanho dos blocos em pixels por lado
int contador = 0; // variável contador que ativa ou desativa o grid

void setup() {
  size(1599, 854);
  img = loadImage("Klaus.png"); // carrega a imagem
  imgResult = createImage(img.width, img.height, RGB);// cria uma imagem resultado
}

void draw() {
  pixelate(); // chama a função pixelate para processar a imagem
  grid(); // chama a função grid para criar um grid por cima da imagem
}

void grid() {
  // loop para percorrer todos os blocos
  for (int i=0; i<img.width; i+=tamanhoPixel) {
    for (int j=0; j<img.height; j+=tamanhoPixel) {
      // caso contador seja par, cria um rect sem fill do mesmo tamanho que o pixel
      if (contador%2==0) {
        noFill();
        rect(i, j, tamanhoPixel, tamanhoPixel);
      }
    }
  }
}

void pixelate() {
  // loop para percorrer todos os blocos
  for (int x = 0; x < img.width; x += tamanhoPixel) {
    for (int y = 0; y < img.height; y += tamanhoPixel) {

      // variáveis para armazenar as médias de R, G e B
      float mediaR = 0;
      float mediaG = 0;
      float mediaB = 0;

      // loop para percorrer todos os pixels dentro do bloco
      for (int i = x; i < x + tamanhoPixel; i++) {
        for (int j = y; j < y + tamanhoPixel; j++) {
          // obtém a cor do pixel (i,j)
          color pixelCor = img.get(i, j);
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
  image(imgResult, 0, 0); // exibe a imagem processada na tela
}

// essa função serve para controlar algumas variáveis para pode mudar o resultado na tela
void keyPressed() {
  if (keyCode==UP) {
    tamanhoPixel++; // caso aperte a seta para cima, aumenta o tamanho do pixel
  } else if (keyCode==DOWN && tamanhoPixel>1) {
    tamanhoPixel--; // caso aperte a seta para baixo, diminui o tamanho do pixel
  } else if (keyCode==' ') {
    contador++; // caso aperte espaço, aparece ou desaparece o grid
  }
}
