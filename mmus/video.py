import cv2
import imutils 

class VideoStreamServer:
    def __init__(self):
        self.cap = cv2.VideoCapture(0)
        self.dim_x =  640#tamanho padrão, apenas para o código iniciar
        self.compression_format = '.jpg' #formato padrão, apenas para o código iniciar
        
    def __iter__(self):
        return self

    def __next__(self):
        ret, frame = self.cap.read()
        # Codificar o quadro como JPEG antes de enviá-lo
        frame = imutils.resize(frame, self.dim_x) #aqui é onde realmente muda o tamanho da imagem
        _, buffer = cv2.imencode(self.compression_format, frame)
        
        return buffer.tobytes()

    def configure_stream(self, message):
        # Interpretar a mensagem no formato 'DIM_X COMPRESSION_FORMAT'
        parts = message.split()  
        self.dim_x = int((parts[0]))
        self.compression_format = str(parts[1])
