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
path_database = "./results/data_simulation_{}".format(n)
path_query = "./results/example_{}".format(n)
os.chdir(path_query)
all_query = os.listdir()
roc_input_ncomp_all = []
truth = []
os.chdir(path_database)
all_database = os.listdir()
for j in range(len(all_database)):
    if example in all_database[j]:
        truth.append(1)
    else:
        truth.append(0)


time_netcomp = []  

for i in range(len(all_query)):
    file_path = f"{path_query}/{all_query[i]}"
    data_query = loadmat(file_path)['A']
    data_query = np.array(data_query)
    os.chdir(path_database)
    all_database = os.listdir()
    roc_input_ncomp = []
    start_time = datetime.now()
    for j in range(len(all_database)):
        file_path2 = f"{path_database}/{all_database[j]}"
        data_base = np.array(loadmat(file_path2)['A'])
        distance2 = nc.lambda_dist(data_query,data_base,kind='laplacian',k=10)
        roc_input_ncomp.append(distance2)
    st_ncomp = np.array(roc_input_ncomp)
    st_ncomp = np.sort(st_ncomp)
    end_time = datetime.now()
    delta = end_time - start_time
    time_netcomp.append(delta.total_seconds())
    roc_input_ncomp_all.append(roc_input_ncomp)
    
    
result = {'netcomp':roc_input_ncomp_all,'true_label':truth,'time_netcomp':time_netcomp}
scipy.io.savemat("./results/python_result1_netcomp_{}_{}".format(n,example),result)


        