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


from data_feeder_obj import DataFeeder

# Load data
dataset_folder = r'C:\Users\udemirha\Desktop\WirelessVerse_Scenarios\Scenario 1'
data_name = 'output'
data_path = r'..\%s.mat' % data_name

data = scio.loadmat(data_path)

beam_label = data['output']['beams'][0][0][:, :, 0] # Select the first BS
x_pos_bs = data['output']['pos_bs'][0][0][0] # Select the first BS
x_pos_ue = data['output']['pos'][0][0] # Only the first BS is available
x_id = data['output']['ids'][0][0] # User Index
x_images = np.load('object_data.npy')
x_images = np.dstack([x_images[:, :, [0, 2], :].mean(axis=2), x_images[:, :, [1, 3], :].mean(axis=2)]) # Compute the center

x_pos_ue_x = x_pos_ue[:, :, 0]
ind_sel = (x_pos_ue_x > -60) & (x_pos_ue_x < 260)
x_pos_ue_x = x_pos_ue_x[(x_pos_ue_x != 0) & ind_sel]
plt.hist(x_pos_ue_x, bins=100)

x_id[ind_sel] = -1

batch_size = 128

# ML data prep
n_beams = np.amax(beam_label)

# pos_ue_noise = np.random.randn(*x_pos_ue.shape)*2
# x_pos_ue += pos_ue_noise

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
print('LoS path accuracy: %.4f' % np.mean(np.abs(los-beam_label_s)<=1))
print('LoS path accuracy: %.4f' % np.mean(np.abs(los-beam_label_s)<=2))

#%%
# Data Split
num_train = int(0.8 * len(beam_label_s))
sample_idx = np.arange(len(beam_label_s))

np.random.seed(7)
np.random.shuffle(sample_idx)
train_idx = sample_idx[:num_train]
test_idx = sample_idx[num_train:]

#%%
df_train = DataFeeder(list_IDs=train_idx, 
                        data_pos=x_pos_ue_s_n, data_img=x_images,
                        labels=beam_label_s, n_classes=n_beams, 
                        img_active=False,
                        batch_size=batch_size,
                        shuffle=True)
df_test = DataFeeder(list_IDs=test_idx, 
                        data_pos=x_pos_ue_s_n, data_img=x_images,
                        labels=beam_label_s, n_classes=n_beams, 
                        img_active=False,
                        batch_size=batch_size,
                        shuffle=False)

#%%
# beam_label_s_oh = tf.one_hot(beam_label_s, n_beams, dtype=tf.int32).numpy()
# print('Number of samples: %i' % len(beam_label_s)) # Number of samples
# x_train, x_test, y_train, y_test = train_test_split(x_pos_ue_s_n, beam_label_s_oh, test_size=0.2, random_state=5)

# ML Model
model = tf.keras.models.Sequential([
  tf.keras.layers.Dense(2, activation='relu'),
  tf.keras.layers.Dense(256, activation='relu'),
  tf.keras.layers.Dense(256, activation='relu'),
  tf.keras.layers.Dense(256, activation='relu'),
  tf.keras.layers.Dense(64)
])

# Training
loss_fn = tf.keras.losses.CategoricalCrossentropy(from_logits=True)
opt = tf.keras.optimizers.Adam(learning_rate=1e-3)
model.compile(optimizer=opt,
              loss=loss_fn,
              metrics=['accuracy'] + [tf.keras.metrics.TopKCategoricalAccuracy(k=k, name='Top-%i'%k) for k in [3, 5]])
# model.fit(x_train, y_train, batch_size=128, epochs=200)
# model.fit(df_train, batch_size=batch_size, epochs=200)
# model.save_weights('./models/position_noise4')
model.load_weights('./models/position_noise3')
results = model.evaluate(df_test)

#%%

df_train_mixed = DataFeeder(list_IDs=train_idx, 
                        data_pos=x_pos_ue_s_n, data_img=x_images,
                        labels=beam_label_s, n_classes=n_beams, 
                        img_active=True, scene_idx_list=scene_idx_list,
                        batch_size=batch_size,
                        shuffle=True)
df_test_mixed = DataFeeder(list_IDs=test_idx, 
                        data_pos=x_pos_ue_s_n, data_img=x_images,
                        labels=beam_label_s, n_classes=n_beams, 
                        img_active=True, scene_idx_list=scene_idx_list,
                        batch_size=batch_size,
                        shuffle=False)


#%%
input_pos = tf.keras.layers.Input(shape=(2))
# model_pos = tf.keras.models.Sequential([
#   tf.keras.layers.Dense(2, activation='relu'),
#   tf.keras.layers.Dense(256, activation='relu'),
#   tf.keras.layers.Dropout(0.2),
#   tf.keras.layers.Dense(256, activation='relu'),
#   tf.keras.layers.Dropout(0.2),
#   tf.keras.layers.Dense(256, activation='relu'),
#   tf.keras.layers.Dropout(0.2),
#   tf.keras.layers.Dense(64)
# ])
pos_out = model(input_pos)

#%%
input_obj = [tf.keras.layers.Input(shape=(x_images.shape[-1])) for i in range(3)]
out_objs = []
for i in range(3):
    model_obj = tf.keras.models.Sequential([
      tf.keras.layers.Dense(x_images.shape[-1], activation='relu'),
      tf.keras.layers.Dense(64, activation='relu'),
     tf.keras.layers.BatchNormalization(),
       tf.keras.layers.Dropout(0.4),
      tf.keras.layers.Dense(128, activation='relu'),
     tf.keras.layers.BatchNormalization(),
       tf.keras.layers.Dropout(0.4),
      tf.keras.layers.Dense(128, activation='relu'),
     tf.keras.layers.BatchNormalization(),
       tf.keras.layers.Dropout(0.4),
      tf.keras.layers.Dense(64)
    ])
    
    out_objs.append(model_obj(input_obj[i]))

#%%
x_in = tf.keras.layers.Concatenate(axis=1)([*out_objs, pos_out])
x_in = tf.keras.layers.Dense(n_beams*4, activation='relu')(x_in)
for _ in range(3):
    x_in = tf.keras.layers.Dense(n_beams*2, activation='relu')(x_in)
x_out = tf.keras.layers.Dense(n_beams)(x_in)

model_mixed = tf.keras.models.Model(inputs=[*input_obj, input_pos], outputs=x_out)

model_mixed.summary()

# Training
loss_fn = tf.keras.losses.CategoricalCrossentropy(from_logits=True)
opt = tf.keras.optimizers.Adam(learning_rate=1e-3)
model_mixed.compile(optimizer=opt,
              loss=loss_fn,
              metrics=['accuracy'] + [tf.keras.metrics.TopKCategoricalAccuracy(k=k, name='Top-%i'%k) for k in [3, 5]])

#%%
# model_mixed.fit(df_train_mixed, validation_data=df_test_mixed, batch_size=batch_size, epochs=100)
#results = model_mixed.evaluate(df_test_mixed) 

#model_mixed.save_weights('./models/position_images4')
model_mixed.load_weights('./models/position_images3')
results = model_mixed.evaluate(df_test_mixed)