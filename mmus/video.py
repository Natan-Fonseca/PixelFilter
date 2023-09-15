import cv2

class VideoStreamServer:
    def __init__(self):
        self.cap = cv2.VideoCapture(0)
    def __iter__(self):
        return self

    def __next__(self):
        ret, frame = self.cap.read()

        # Codificar o quadro como JPEG antes de enviá-lo
        _, buffer = cv2.imencode('.jpg', frame)
        return buffer.tobytes()
