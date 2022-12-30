# -*- coding: utf-8 -*-
"""
Created on Sun Oct 30 18:48:16 2022

@author: udemirha
"""

import torch
import scipy.io as scio
import numpy as np
import os
import pandas as pd
from tqdm import tqdm

# Load data
dataset_folder = r'../../DV_scenarios/Scenario 1'
data_path = r'./data/revised_output5paths.mat'

data = scio.loadmat(data_path)

beam_label = data['output']['beams'][0][0]
x_pos_bs = data['output']['pos_bs'][0][0]
x_pos_ue = data['output']['pos'][0][0]
x_id = data['output']['ids'][0][0] # User Index
x_images = [np.stack(data['output']['images_c%i'%i][0][0][0]).squeeze() for i in np.arange(3)+1]

#%%
# Model
model = torch.hub.load('ultralytics/yolov5', 'yolov5x')  # or yolov5n - yolov5x6, custom

objects = []
# Images
for j in tqdm(range(3)):
    objects.append([])
    for i in tqdm(range(2000)):
        img = os.path.abspath(dataset_folder + x_images[j][i])  # or file, Path, PIL, OpenCV, numpy, list
        
        # Inference
        results = model(img)
        
        # Results
        objects[j].append(results.pandas().xyxy[0])  # or .show(), .save(), .crop(), .pandas(), etc.

#%%
num_objects_max = 0
for j in range(3):
    for i in range(2000):
        num_objects = len(objects[j][i])
        if num_objects > num_objects_max:
            num_objects_max = num_objects
            
print(num_objects_max)

#%%
# vals = set()
cols = 4
obj_data = np.zeros((3, 2000, cols, 10))
for j in tqdm(range(3)):
    for i in tqdm(range(2000)):
        num_objects = len(objects[j][i])
        obj_data[j, i, :, :num_objects] = objects[j][i].iloc[:, :cols].T
        # vals = vals.union(set(objects[j][i].iloc[:, 4]))
            
obj_data[:, :, [0, 2], :] /= 1920
obj_data[:, :, [1, 3], :] /= 720

np.save('./data/revised_object_data.npy', obj_data)