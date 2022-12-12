# -*- coding: utf-8 -*-
"""
Created on Fri Oct 28 22:33:59 2022

@author: udemirha
"""

import glob
import os

lof = glob.glob(r"C:\Users\udemirha\Desktop\WirelessVerse_Scenarios\Scenario 1\LiDAR\*\*")

for l in lof:
    fplist = l.split('\\')
    fpname = fplist[-1]
    fpname_1 = fpname.split('_')
    fpname_2 = fpname_1[-1].split('.')
    fpname_2[0] = fpname_2[0][4:]
    fpname_2[0] = str(int(fpname_2[0]))
    fpname_1[-1] = '.'.join(fpname_2)
    fpname = ''.join(fpname_1)
    fplist[-1] = fpname
    fp = "/".join(fplist)
    os.rename(l, fp)