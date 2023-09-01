import cv2
import numpy as np
from PIL import Image, ImageOps


# Make tiny palette Image, one black pixel
palIm = Image.new('P', (1,1))

# Make your desired B&W palette containing only 1 pure white and 255 pure black entries
palette = np.random.randint(0, 255, size=(32, 3))

# Push in our lovely B&W palette and save just for debug purposes
palIm.putpalette(palette)


def quantize_to_palette(image, palette):
    X_query = image.reshape(-1, 3).astype(np.float32)
    X_index = palette.astype(np.float32)

    knn = cv2.ml.KNearest_create()
    knn.train(X_index, cv2.ml.ROW_SAMPLE, np.arange(len(palette)))
    ret, results, neighbours, dist = knn.findNearest(X_query, 1)

    quantized_image = np.array([palette[idx] for idx in neighbours.astype(int)])
    quantized_image = quantized_image.reshape(image.shape)
    return quantized_image

cap = cv2.VideoCapture(0)
# image_path= "E:\Processing\Sketchs\ImagePoster\Klaus.png"
# actual = Image.open(image_path)
# actual.show()
while cap.isOpened():
    ret,frame = cap.read()
    frameRGB = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    actual = Image.fromarray(np.uint8(frameRGB)).convert('RGB')
    quantize = actual.quantize(palette=palIm, dither=Image.NONE)
    posterize= ImageOps.posterize(actual, 4) 
    
    open_cv_image = np.array(actual)
    open_cv_image1 = np.array(quantize)
    
    open_cv_imageBGR = open_cv_image1[:,: :-1]
    
    #actual.show()
    #output = quantize_to_palette(frame, palette).astype(np.uint8)
    cv2.imshow('Imagem Quantizada', open_cv_imageBGR)
    #cv2.imshow('window-name', frame)
    
    if cv2.waitKey(10) & 0xFF == ord('q'):
        break
quantize.show()
print(type(open_cv_image))
print(type(open_cv_image1))
cap.release()
cv2.destroyAllWindows() # destroy all opened windows