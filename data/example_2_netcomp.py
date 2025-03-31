import os
from mat4py import loadmat
import netlsd
import netcomp as nc
import scipy.io
import numpy as np
from datetime import datetime


file_path = "Final_data_facsimile.mat"
data_base = scipy.io.loadmat(file_path)
data_NC = np.array(data_base['cor_NC_fisherZ_correct'])
data_SZ = np.array(data_base['cor_SZ_fisherZ_correct'])
data_all = np.concatenate((data_NC,data_SZ),axis = 2)
roc_input_nlsd_all = []
roc_input_ncomp_all = []
start_time = datetime.now()
comp_all = data_all.shape[2]
# comp_all = 2
for i in range(comp_all):
    roc_input_nlsd = []
    roc_input_ncomp = []
    data_query = data_all[:,:,i]
    print(i)
    for j in range(comp_all):
        data_base = data_all[:,:,j]
        distance2 = nc.lambda_dist(data_query, data_base, kind='laplacian', k=10)
        roc_input_ncomp.append(distance2)

    roc_input_ncomp_all.append(roc_input_ncomp)

end_time = datetime.now()
delta = end_time - start_time

result = {'netcomp': roc_input_ncomp_all,'time_cost':delta.total_seconds()}
scipy.io.savemat("sz_python_dissimilarity_netcomp",result)
