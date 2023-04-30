# -*- coding: utf-8 -*-
"""
Created on Sat Apr 29 11:26:13 2023

@author: Umt
"""

import pandas as pd

df_dict = {'scene': [i+1 for i in range(2000)],
           'power': ['./power/%i.txt'%i for i in range(2000)],
           'gps_bs': ['./gps_bs/0.txt' for i in range(2000)],
           'gps_ue': ['./gps_ue/%i.txt'%i for i in range(2000)],
           'radar': ['./radar/%i.mat'%i for i in range(2000)]
           }
for i in range(13):
    df_dict['cam_%i'%i] = ['./RGB_images/cam%i/%i.jpg'%(i, j) for j in range(2000)]
for i in range(4):
    df_dict['lidar_%i'%i] = ['./lidar/bs%i/%i.pcd'%(i, j) for j in range(2000)]

x = pd.DataFrame(df_dict)
x.to_csv('dataset.csv')