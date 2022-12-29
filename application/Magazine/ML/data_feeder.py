# -*- coding: utf-8 -*-
"""
Created on Fri Oct 28 09:04:33 2022

@author: Umut Demirhan
"""

import numpy as np
import keras
import imageio
import tensorflow as tf

class DataFeeder(keras.utils.Sequence):
    'Generates data for Keras'
    def __init__(self, list_IDs, 
                 data_pos, data_img,
                 labels, n_classes=10, 
                 img_active=False,
                 scene_idx_list=None,
                 batch_size=32, dim=(1920, 720), n_channels=3,
                 shuffle=True
                 ):
        'Initialization'
        self.dim = dim
        self.batch_size = batch_size
        self.labels = labels
        self.list_IDs = list_IDs
        self.n_channels = n_channels
        self.n_classes = n_classes
        self.shuffle = shuffle
        self.on_epoch_end()
        
        self.img_active = img_active
        self.data_pos = data_pos
        self.data_img = data_img
        self.num_cams = len(data_img)
        self.scene_idx_list = scene_idx_list
        
    def set_image_activity(self, img_activity):
        self.img_active = img_activity
        
    def __len__(self):
        'Denotes the number of batches per epoch'
        return int(np.floor(len(self.list_IDs) / self.batch_size))

    def __getitem__(self, index):
        'Generate one batch of data'
        # Generate indexes of the batch
        indexes = self.indexes[index*self.batch_size:(index+1)*self.batch_size]

        # Find list of IDs
        list_IDs_temp = [self.list_IDs[k] for k in indexes]

        # Generate data
        X, y = self.__data_generation(list_IDs_temp)

        return X, y

    def on_epoch_end(self):
        'Updates indexes after each epoch'
        self.indexes = np.arange(len(self.list_IDs))
        if self.shuffle == True:
            np.random.shuffle(self.indexes)

    def __data_generation(self, list_IDs_temp):
        'Generates data containing batch_size samples' # X : (n_samples, *dim, n_channels)
        # Initialization
        if self.img_active:
            X_img = np.empty((self.num_cams, self.batch_size, *self.dim, self.n_channels))
        X_pos = np.empty((self.batch_size, 2))
        y = np.empty((self.batch_size), dtype=int)

        # Generate data
        for i, ID in enumerate(list_IDs_temp):
            # Store sample
            if self.img_active:
                for j in range(self.num_cams):
                    X_img[j, i,] = tf.keras.preprocessing.image.load_img(self.data_img[j][self.scene_idx_list[ID]], target_size=self.dim)
                
            X_pos[i, :] = self.data_pos[ID, :]
            
            # Store class
            y[i] = self.labels[ID]
            
        if self.img_active:
            return (*X_img, X_pos), keras.utils.to_categorical(y, num_classes=self.n_classes)
        else:
            return X_pos, keras.utils.to_categorical(y, num_classes=self.n_classes)
