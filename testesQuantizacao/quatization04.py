import cv2
import imutils
import random
from time import time

import matplotlib.pyplot as plt
import numpy as np
from skimage import io
from sklearn.cluster import KMeans
from sklearn.utils import shuffle

from sklearn.datasets import load_sample_image
from sklearn.metrics import pairwise_distances_argmin

n_colors = 8

# Load Image and transform to a 2D numpy array.
china = cv2.imread("china.jpg")
china= imutils.resize(china, width=1000)

# Convert to floats instead of the default 8 bits integer coding. Dividing by
# 255 is important so that plt.imshow behaves works well on float data (need to
# be in the range [0-1])
china = np.array(china, dtype=np.float64) / 255

# Load Image and transform to a 2D numpy array.
w, h, d = original_shape = tuple(china.shape)
assert d == 3
image_array = np.reshape(china, (w * h, d))

image_array_sample = shuffle(image_array, random_state=0, n_samples=1_000)
kmeans = KMeans(n_clusters=n_colors, n_init = "auto").fit(image_array_sample)
labels = kmeans.predict(image_array)

def recreate_image(codebook, labels, w, h):
    """Recreate the (compressed) image from the code book & labels"""
    return codebook[labels].reshape(w, h, -1)

image_out = recreate_image(kmeans.cluster_centers_, labels, w, h)        
plt.figure(1)
plt.clf()
plt.axis("off")
plt.title("quantized")
plt.imshow(image_out)

image_out = np.array(image_out*255, dtype=np.uint8)

image_path = cv2.imread("china.jpg")
image_path= imutils.resize(image_path, width=1000)
#open_cv_imageBGR = frameRGB[:,: :-1]
cv2.imshow("imagem2", image_path)
cv2.imshow("imagem", image_out)

cv2.waitKey(0)
cv2.destroyAllWindows()

# codebook_random = shuffle(image_array, random_state=0, n_samples=n_colors)
# labels_random = pairwise_distances_argmin(palette, image_array, axis=0)

# def recreate_image(codebook, labels, w, h):
#     """Recreate the (compressed) image from the code book & labels"""
#     return codebook[labels].reshape(w, h, -1)

# return recreate_image(codebook_random, labels_random, w, h)
# #cv2.imshow('random',recreate_image(codebook_random, labels_random, w, h))

# cap = cv2.VideoCapture(0)

# while cap.isOpened():
#     ret,frame = cap.read()
#     quantize(frame)
#     #cv2.imshow('Imagem Quantizada', output)
#     #cv2.imshow('window-name', frame)
    
#     if cv2.waitKey(10) & 0xFF == ord('q'):
#         break


