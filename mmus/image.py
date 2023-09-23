import cv2
import imutils

class ImageStreamServer:
    def __init__(self, image_path):
        self.image = cv2.imread(image_path)
        self.dim_x,_,_ = self.image.shape #tamanho padrão, apenas para o código iniciar
        self.compression_format = '.jpg' #formato padrão, apenas para o código iniciar
        
    def __iter__(self):
        return self

    def __next__(self):
        # Codifique a imagem como bytes
        image = imutils.resize(self.image, self.dim_x) #aqui é onde realmente muda o tamanho da imagem
        image_bytes = cv2.imencode(self.compression_format, image)[1].tobytes() # aqui é onde muda o formato
        
        return image_bytes
    
    def configure_stream(self, message):
        # Interpretar a mensagem no formato 'DIM_X COMPRESSION_FORMAT'
        parts = message.split()
        self.dim_x = int(parts[0])
        self.compression_format = str(parts[1])
