import cv2
import numpy as np

palette = np.random.randint(0, 255, size=(2, 3))


def quantize_to_palette(image, palette):
    X_query = image.reshape(-1, 3).astype(np.float32)
    X_index = palette.astype(np.float32)

    knn = cv2.ml.KNearest_create()
    knn.train(X_index, cv2.ml.ROW_SAMPLE, np.arange(len(palette)))
    ret, results, neighbours, dist = knn.findNearest(X_query, 1)

    quantized_image = np.array([palette[idx] for idx in neighbours.astype(int)])
    quantized_image = quantized_image.reshape(image.shape)
    return quantized_image


image_path= "E:\Processing\Sketchs\ImagePoster\Klaus.png"
cap = cv2.VideoCapture(0)

while cap.isOpened():
    ret,frame = cap.read()
    output = quantize_to_palette(frame, palette).astype(np.uint8)
    cv2.imshow('Imagem Quantizada', output)
    #cv2.imshow('window-name', frame)
    
    if cv2.waitKey(10) & 0xFF == ord('q'):
        break


cap.release()
cv2.destroyAllWindows() # destroy all opened windows
#image = cap.read()
# image = cv2.imread(image_path)
# output = quantize_to_palette(image, palette).astype(np.uint8)
#cv2.imwrite("output.jpg", output)

# cv2.imshow('Imagem Original', image)
# cv2.imshow('Imagem Quantizada', output)
# cv2.waitKey(0)
# cv2.destroyAllWindows()