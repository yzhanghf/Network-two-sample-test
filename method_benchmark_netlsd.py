"""
NetLSD, but uses the inference:
https://arxiv.org/pdf/1904.07414.pdf,  Section 2.6.1
"""

import os 
from mat4py import loadmat 
import netlsd
import scipy.io
import numpy as np
import time
import sys

import scipy.stats as stats
from subroutine_resample_matrix import resample_matrix


N_resample = 10;




filename1, filename2 = sys.argv[1], sys.argv[2]
directory = "/home/zhang.7824/Meijia-two-sample-test-Revision-1/temp_py_data_netlsd/"
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
        desc1 = netlsd.heat(A_list[ii1])
        desc2 = netlsd.heat(A_list[ii2])
        distance_matrix_AA[ii1,ii2] = netlsd.compare(desc1, desc2)

for ii1 in range(N_resample):
    for ii2 in range(N_resample):
        desc1 = netlsd.heat(A_list[ii1])
        desc2 = netlsd.heat(B_list[ii2])
        distance_matrix_AB[ii1,ii2] = netlsd.compare(desc1, desc2)

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
# roc_input_nlsd_all = []
# truth = []
# os.chdir(path_database)
# all_database = os.listdir()
# for j in range(len(all_database)):
#     if example in all_database[j]:
#         truth.append(1)
#     else:
#         truth.append(0)

# time_netlsd = []  

# for i in range(len(all_query)):
#     file_path = f"{path_query}/{all_query[i]}"
#     data_query = loadmat(file_path)['A']
#     data_query = np.array(data_query)
#     os.chdir(path_database)
#     all_database = os.listdir()
#     roc_input_nlsd = []
#     start_time = datetime.now()
#     for j in range(len(all_database)):
#         file_path2 = f"{path_database}/{all_database[j]}"
#         data_base = np.array(loadmat(file_path2)['A'])
#         desc1 = netlsd.heat(data_query)
#         desc2 = netlsd.heat(data_base)
#         distance = netlsd.compare(desc1, desc2)
#         roc_input_nlsd.append(distance)
#     st_nlsd = np.array(roc_input_nlsd)
#     st_nlsd  = np.sort(st_nlsd)
#     end_time = datetime.now()
#     delta = end_time - start_time
#     time_netlsd.append(delta.total_seconds())
#     roc_input_nlsd_all.append(roc_input_nlsd)

    
# result = {'netlsd':roc_input_nlsd_all,'true_label':truth,'time_netlsd':time_netlsd}
# scipy.io.savemat("/home/shao.390/two_sample_network_inference/new_submission/ROC_result/python_result1_netlsd_{}_{}".format(n,example),result)


        