import cv2

class ImageStreamServer:
    def __init__(self, image_path):
        self.image = cv2.imread(image_path)

    def __iter__(self):
        return self

    def __next__(self):
        # Codifique a imagem como bytes
        image_bytes = cv2.imencode('.jpg', self.image)[1].tobytes()

        return image_bytes
