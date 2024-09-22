import os 
from mat4py import loadmat 
import netlsd
import netcomp as nc
import scipy.io
import numpy as np
from datetime import datetime
import sys

example = "SmoothGraphon1"
n = int(float(sys.argv[1]))
path_database = "./datasimulation/data_simulation_{}".format(n)
path_query = "./datasimulation/example_{}".format(n)
os.chdir(path_query)
all_query = os.listdir()
roc_input_nlsd_all = []
truth = []
os.chdir(path_database)
all_database = os.listdir()
for j in range(len(all_database)):
    if example in all_database[j]:
        truth.append(1)
    else:
        truth.append(0)

time_netlsd = []  

for i in range(len(all_query)):
    file_path = f"{path_query}/{all_query[i]}"
    data_query = loadmat(file_path)['A']
    data_query = np.array(data_query)
    os.chdir(path_database)
    all_database = os.listdir()
    roc_input_nlsd = []
    start_time = datetime.now()
    for j in range(len(all_database)):
        file_path2 = f"{path_database}/{all_database[j]}"
        data_base = np.array(loadmat(file_path2)['A'])
        desc1 = netlsd.heat(data_query)
        desc2 = netlsd.heat(data_base)
        distance = netlsd.compare(desc1, desc2)
        roc_input_nlsd.append(distance)
    st_nlsd = np.array(roc_input_nlsd)
    st_nlsd  = np.sort(st_nlsd)
    end_time = datetime.now()
    delta = end_time - start_time
    time_netlsd.append(delta.total_seconds())
    roc_input_nlsd_all.append(roc_input_nlsd)

    
result = {'netlsd':roc_input_nlsd_all,'true_label':truth,'time_netlsd':time_netlsd}
scipy.io.savemat("./ROC_result/python_result1_netlsd_{}_{}".format(n,example),result)


        