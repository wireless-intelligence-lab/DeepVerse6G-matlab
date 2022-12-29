# -*- coding: utf-8 -*-
"""
Created on Wed Oct 26 19:47:54 2022

@author: Umut Demirhan
"""
import os

import numpy as np
import scipy.io as scio

import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
import imageio

from tqdm import tqdm
import tensorflow as tf


from data_feeder import DataFeeder

# Load data
dataset_folder = r'C:\Users\udemirha\Desktop\WirelessVerse_Scenarios\Scenario 1'
data_path = r'..\output5paths.mat'

data = scio.loadmat(data_path)

beam_label = data['output']['beams'][0][0][:, :, 0] # Select the first BS
x_pos_bs = data['output']['pos_bs'][0][0][0] # Select the first BS
x_pos_ue = data['output']['pos'][0][0] # Only the first BS is available
x_id = data['output']['ids'][0][0] # User Index
x_images = [np.stack(data['output']['images_c%i'%i][0][0][0]).squeeze() for i in np.arange(3)+1]

for i in tqdm(range(len(x_images))):
    x_images[i] = list(x_images[i])
    for j in tqdm(range(len(x_images[i]))):
        x_images[i][j] = os.path.abspath(dataset_folder + x_images[i][j])
batch_size = 64

# ML data prep
n_beams = np.amax(beam_label)

diff = x_pos_ue - x_pos_bs

# plt.hist(beam_label.flatten()[beam_label.flatten().nonzero()[0]], bins=128)

num_veh = np.amax(x_id)+1
x_pos_ue_s = []
beam_label_s = []
scene_idx_list = []
for ue_id in range(num_veh):
    user_samples = x_id == ue_id
    scene_idx, user_order = user_samples.nonzero()
    x_pos_ue_s.append(diff[scene_idx, user_order, :])
    beam_label_s.append(beam_label[scene_idx, user_order])
    scene_idx_list.append(scene_idx)

x_pos_ue_s = np.vstack(x_pos_ue_s) # Stack only the available user positions
beam_label_s = np.hstack(beam_label_s) - 1 # Set beams from 0 to 127
scene_idx_list = np.hstack(scene_idx_list)


#%% ML Data Preparation
min_pos = np.min(x_pos_ue_s, axis=(0))
max_pos = np.max(x_pos_ue_s, axis=(0))
norm = max_pos - min_pos
x_pos_ue_s_n = (x_pos_ue_s - min_pos) / norm

#%% 
colors = plt.cm.rainbow(np.linspace(0, 1, n_beams))
plt.scatter(x_pos_ue_s_n[:, 0], x_pos_ue_s_n[:, 1], c=colors[beam_label_s])
los = ((np.arctan2(x_pos_ue_s[:, 1], x_pos_ue_s[:, 0])/np.pi)*n_beams).round()
plt.figure()
plt.scatter(los, beam_label_s, marker='x')
print('LoS path accuracy: %.4f' % np.mean(np.abs(los-beam_label_s)<=0))

#%%
# Data Split
num_train = int(0.8 * len(beam_label_s))
sample_idx = np.arange(len(beam_label_s))

np.random.seed(7)
np.random.shuffle(sample_idx)
train_idx = sample_idx[:num_train]
test_idx = sample_idx[num_train:]

# #%%
# df_train = DataFeeder(list_IDs=train_idx, 
#                         data_pos=x_pos_ue_s_n, data_img=x_images,
#                         labels=beam_label_s, n_classes=n_beams, 
#                         img_active=False,
#                         batch_size=batch_size, dim=(1920, 720), n_channels=3,
#                         shuffle=True)
# df_test = DataFeeder(list_IDs=test_idx, 
#                         data_pos=x_pos_ue_s_n, data_img=x_images,
#                         labels=beam_label_s, n_classes=n_beams, 
#                         img_active=False,
#                         batch_size=batch_size, dim=(1920, 720), n_channels=3,
#                         shuffle=True)

# #%%
# # ML Model
# model = tf.keras.models.Sequential([
#   tf.keras.layers.Dense(2, activation='relu'),
#   tf.keras.layers.Dense(256, activation='relu'),
#   tf.keras.layers.Dense(256, activation='relu'),
#   tf.keras.layers.Dense(256, activation='relu'),
#   tf.keras.layers.Dense(64)
# ])

# # Training
# loss_fn = tf.keras.losses.CategoricalCrossentropy(from_logits=True)
# opt = tf.keras.optimizers.Adam(learning_rate=1e-3)
# model.compile(optimizer=opt,
#               loss=loss_fn,
#               metrics=['accuracy'] + [tf.keras.metrics.TopKCategoricalAccuracy(k=k, name='Top-%i'%k) for k in [3, 5]])
# model.fit(df_train, batch_size=batch_size, epochs=200)

# results = model.evaluate(df_test)

#%%

df_train_mixed = DataFeeder(list_IDs=train_idx, 
                        data_pos=x_pos_ue_s_n, data_img=x_images,
                        labels=beam_label_s, n_classes=n_beams, 
                        img_active=True, scene_idx_list=scene_idx_list,
                        batch_size=batch_size, dim=(256, 256), n_channels=3,
                        shuffle=True)
df_test_mixed = DataFeeder(list_IDs=test_idx, 
                        data_pos=x_pos_ue_s_n, data_img=x_images,
                        labels=beam_label_s, n_classes=n_beams, 
                        img_active=True, scene_idx_list=scene_idx_list,
                        batch_size=batch_size, dim=(256, 256), n_channels=3,
                        shuffle=False)

input_pos = tf.keras.layers.Input(shape=(2))

#%%
model_pos = tf.keras.models.Sequential([
  tf.keras.layers.Dense(2, activation='relu'),
  tf.keras.layers.Dense(256, activation='relu'),
  tf.keras.layers.Dense(256, activation='relu'),
  tf.keras.layers.Dense(256, activation='relu'),
  tf.keras.layers.Dense(64)
])
pos_out = model_pos(input_pos)

#%%
filters = 16
dropout = 0.2
kernel_size = (3, 3)
input_img_o = tf.keras.layers.Input(shape=(256, 256, 3))
input_img = tf.keras.layers.Conv2D(filters=filters, kernel_size=kernel_size, activation='relu', padding='same')(input_img_o)
input_img = tf.keras.layers.MaxPooling2D(pool_size=(2, 2))(input_img)
for _ in range(4):
    input_img = tf.keras.layers.Conv2D(filters=filters, kernel_size=kernel_size, activation='relu', padding='same')(input_img)
    input_img = tf.keras.layers.MaxPooling2D(pool_size=(2, 2))(input_img)
    
input_img = tf.keras.layers.Conv2D(filters=1, kernel_size=kernel_size, activation='relu', padding='same')(input_img)
input_img = tf.keras.layers.MaxPooling2D()(input_img)
input_img = tf.keras.layers.Flatten()(input_img)
input_img = tf.keras.layers.Dense(256, activation='relu')(input_img)
input_img = tf.keras.layers.Dropout(dropout)(input_img)
input_img = tf.keras.layers.Dense(192, activation='relu')(input_img)
input_img = tf.keras.layers.Dropout(dropout)(input_img)
img_out = tf.keras.layers.Dense(128, activation='relu')(input_img)

model_image1 = tf.keras.models.Model(inputs=input_img_o, outputs=img_out)


#%%
input_img1 = tf.keras.layers.Input(shape=(256, 256, 3))
input_img2 = tf.keras.layers.Input(shape=(256, 256, 3))
input_img3 = tf.keras.layers.Input(shape=(256, 256, 3))
out_imgs = [model_image1(input_img1), 
            model_image1(input_img2), 
            model_image1(input_img3)]

x_in = tf.keras.layers.Concatenate(axis=1)([*out_imgs, pos_out])
x_in = tf.keras.layers.Dense(n_beams*4, activation='relu')(x_in)
for _ in range(3):
    x_in = tf.keras.layers.Dense(n_beams*2, activation='relu')(x_in)
x_out = tf.keras.layers.Dense(n_beams)(x_in)

model_mixed = tf.keras.models.Model(inputs=[input_img1, input_img2, input_img3, input_pos], outputs=x_out)

model_mixed.summary()

# Training
loss_fn = tf.keras.losses.CategoricalCrossentropy(from_logits=True)
opt = tf.keras.optimizers.Adam(learning_rate=1e-3)
model_mixed.compile(optimizer=opt,
              loss=loss_fn,
              metrics=['accuracy'] + [tf.keras.metrics.TopKCategoricalAccuracy(k=k, name='Top-%i'%k) for k in [3, 5]])

#%%
model_mixed.fit(df_train_mixed, batch_size=batch_size, epochs=200)
results = model_mixed.evaluate(df_test_mixed) 

#%%
y_hat = model.predict(df_test_mixed)
y_hat_idx = y_hat.argmax(axis=1)
y_orig = beam_label_s[test_idx][:-2]
acc = y_orig == y_hat_idx
acc_list = []
for i in range(64):
    acc_list.append(acc[y_orig == i].mean())