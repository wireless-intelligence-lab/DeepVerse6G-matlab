# -*- coding: utf-8 -*-
"""
Created on Sat May 14 14:58:07 2022

@author: nikhs
"""

import open3d as o3d
import os
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
#Change the path to the path of the extracted frames
path=r"C:\Users\udemirha\Desktop\WirelessVerse_Scenarios\Scenario 1\LiDAR\bs1"

address=[]

for filename in os.listdir(path):
    address.append(filename)
    

vis = o3d.visualization.Visualizer() 
vis.create_window(visible=True) 
cloud=o3d.io.read_point_cloud(path+"/"+ address[0])
geometry = o3d.geometry.PointCloud(cloud)
vis.add_geometry(geometry)
for i in range(325):#range(len(address)):
    print(i)
    cloud=o3d.io.read_point_cloud(path+"/"+ address[i])
    #Set field of view parameters,also zoom
    #please adjust this based on the visualisation from matlab
    geometry.points = cloud.points
    vis.update_geometry(geometry)
    vis.poll_events()
    vis.update_renderer()

    # front=[0.257, 0.1125, 24.9795]
    # lookat=[2.6172, 1.0475, 11.532]
    # up=[0.794, 0.4768, 0.2024]
    # zoom=0.23
    ##sets all the view_control parameters here,for the visualiser object
    # opt = vis.get_render_option()
    # opt.background_color = np.asarray([0, 0, 0])
    # o3d.visualization.ViewControl.set_zoom(vis.get_view_control(), zoom)
    # o3d.visualization.ViewControl.set_lookat(vis.get_view_control(), lookat)
    # o3d.visualization.ViewControl.set_front(vis.get_view_control(),front)
    # o3d.visualization.ViewControl.set_up(vis.get_view_control(),up)
    # o3d.visualization.ViewControl.rotate(vis.get_view_control(),10,-400)#change the x,y rotation here
    # color = vis.capture_screen_float_buffer(True) 
 
vis.destroy_window() 

    
#     {
# 	"class_name" : "ViewTrajectory",
# 	"interval" : 29,
# 	"is_loop" : false,
# 	"trajectory" : 
# 	[
# 		{
# 			"boundingbox_max" : [ 75.930367000000004, 3.9674670000000001, 103.30204000000001 ],
# 			"boundingbox_min" : [ -105.26327499999999, -12.899737, -91.611664000000005 ],
# 			"field_of_view" : 60.0,
# 			"front" : [ 0.76734976895026752, 0.57180857460406631, 0.29018836313890523 ],
# 			"lookat" : [ -12.471596952817391, -3.7026453187200428, 1.1158957647157166 ],
# 			"up" : [ -0.52940789649715259, 0.82029245753382207, -0.2164429791875529 ],
# 			"zoom" : 0.19999999999999982
# 		}
# 	],
# 	"version_major" : 1,
# 	"version_minor" : 0
# }
    
    
   
    