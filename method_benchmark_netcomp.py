"""
https://arxiv.org/pdf/1904.07414.pdf
Section 2.6.1
"""

import os 
from mat4py import loadmat 
import netcomp as nc
import scipy.io
import numpy as np
import time
import sys

import scipy.stats as stats
from subroutine_resample_matrix import resample_matrix


N_resample = 10;




filename1, filename2 = sys.argv[1], sys.argv[2]
directory = "/home/zhang.7824/Meijia-two-sample-test-Revision-1/temp_py_data/"
py_filename1 = directory + filename1 + ".csv"
py_filename2 = directory + filename2 + ".csv"

A = np.loadtxt(py_filename1, delimiter=',')
B = np.loadtxt(py_filename2, delimiter=',')

start_time = time.time()


A_list = resample_matrix(A, N_resample)
B_list = resample_matrix(B, N_resample)

distance_matrix_AA = np.zeros((N_resample, N_resample))
distance_matrix_AB = np.zeros((N_resample, N_resample))

for ii1 in range(N_resample):
    for ii2 in range(ii1+1,N_resample):
        distance_matrix_AA[ii1,ii2] = nc.lambda_dist(A_list[ii1],A_list[ii2],kind='laplacian',k=10)

for ii1 in range(N_resample):
    for ii2 in range(N_resample):
        distance_matrix_AB[ii1,ii2] = nc.lambda_dist(A_list[ii1],B_list[ii2],kind='laplacian',k=10)

D0 = distance_matrix_AA[np.triu_indices(distance_matrix_AA.shape[0], k=1)]
D1 = distance_matrix_AB.flatten()

t_stat = (np.mean(D1) - np.mean(D0)) / np.std(D0)

p_value = 2*np.minimum( stats.norm.cdf(t_stat), 1-stats.norm.cdf(t_stat) )

end_time = time.time()
time_cost = end_time - start_time

output_filename = directory + "py_temp_" + filename1 + filename2 + ".csv"

with open(output_filename, 'w') as file:
    file.write('{}\n{}\n{}\n'.format(t_stat, p_value, time_cost))
# file.write(f'{t_stat}\n{p_value}\n{time_cost}\n')



############################################################################
#############################  Meijia's code  ##############################
############################################################################



# example = "SmoothGraphon1"
# n = int(float(sys.argv[1]))
# path_database = "/home/shao.390/two_sample_network_inference/new_submission/datasimulation/data_simulation_{}".format(n)
# path_query = "/home/shao.390/two_sample_network_inference/new_submission/datasimulation/example_{}".format(n)
# os.chdir(path_query)
# all_query = os.listdir()
# roc_input_ncomp_all = []
# truth = []
# os.chdir(path_database)
# all_database = os.listdir()
# for j in range(len(all_database)):
#     if example in all_database[j]:
#         truth.append(1)
#     else:
#         truth.append(0)


# time_netcomp = []  

# for i in range(len(all_query)):
#     file_path = f"{path_query}/{all_query[i]}"
#     data_query = loadmat(file_path)['A']
#     data_query = np.array(data_query)
#     os.chdir(path_database)
#     all_database = os.listdir()
#     roc_input_ncomp = []
#     start_time = datetime.now()
#     for j in range(len(all_database)):
#         file_path2 = f"{path_database}/{all_database[j]}"
#         data_base = np.array(loadmat(file_path2)['A'])
#         distance2 = nc.lambda_dist(data_query,data_base,kind='laplacian',k=10)
#         roc_input_ncomp.append(distance2)
#     st_ncomp = np.array(roc_input_ncomp)
#     st_ncomp = np.sort(st_ncomp)
#     end_time = datetime.now()
#     delta = end_time - start_time
#     time_netcomp.append(delta.total_seconds())
#     roc_input_ncomp_all.append(roc_input_ncomp)
    
    
# result = {'netcomp':roc_input_ncomp_all,'true_label':truth,'time_netcomp':time_netcomp}
# scipy.io.savemat("/home/shao.390/two_sample_network_inference/new_submission/ROC_result/python_result1_netcomp_{}_{}".format(n,example),result)


        