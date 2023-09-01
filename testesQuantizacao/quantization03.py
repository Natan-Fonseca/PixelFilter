import cv2
import random
from time import time

import matplotlib.pyplot as plt
import numpy as np


from sklearn.cluster import KMeans
from sklearn.datasets import load_sample_image
from sklearn.metrics import pairwise_distances_argmin
from sklearn.utils import shuffle


def quantize(image):
    # Load Image and transform to a 2D numpy array.
    w, h, d = original_shape = tuple(image.shape)
    assert d == 3
    image_array = np.reshape(image, (w * h, d))
    
    
    
    codebook_random = shuffle(image_array, random_state=seed, n_samples=n_colors)
    labels_random = pairwise_distances_argmin(codebook_random, image_array, axis=0)
    
    def recreate_image(codebook, labels, w, h):
        """Recreate the (compressed) image from the code book & labels"""
        return codebook[labels].reshape(w, h, -1)

    return recreate_image(codebook_random, labels_random, w, h)
    #cv2.imshow('random',recreate_image(codebook_random, labels_random, w, h))
    
seed = random.getrandbits(8)
n_colors = 8


cap = cv2.VideoCapture(0)

while cap.isOpened():
    ret,frame = cap.read()
    output = quantize(frame)
    cv2.imshow('Imagem Quantizada', output)
    #cv2.imshow('window-name', frame)
    
    if cv2.waitKey(10) & 0xFF == ord('q'):
        break


cap.release()
cv2.destroyAllWindows() # destroy all opened windows

