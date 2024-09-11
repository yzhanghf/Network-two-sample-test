require(nonparGraphTesting)
library(MASS)


args <- commandArgs(trailingOnly = TRUE)
filename1 <- args[1]
filename2 <- args[2]
set.seed(1)

directory = "/home/zhang.7824/Meijia-two-sample-test-Revision-1/temp_R_data_nonparGT/"
R_filename1 = paste(directory, filename1, ".csv", sep="")
R_filename2 = paste(directory, filename2, ".csv", sep="")
A = as.matrix(read.csv(R_filename1, header = FALSE))
B = as.matrix(read.csv(R_filename2, header = FALSE))


start_time <- Sys.time()
result = nonpar(A,B)
end_time <- Sys.time()
time_cost = end_time - start_time

t_stat 	= result$`test statistic`
p_value = result$`estimated p-value`

output_filename = paste(directory, "R_temp_", filename1, filename2, ".csv", sep="")

write.table(c(t_stat,p_value,time_cost), output_filename, row.names=FALSE, col.names=FALSE)


############################################################################
#############################  Meijia's code  ##############################
############################################################################

# args <- commandArgs(trailingOnly = TRUE)
# set.seed(1)
# n = as.numeric(args[1])
# example = "SmoothGraphon1"
# names_database = list.files(paste("/home/shao.390/two_sample_network_inference/new_submission/datasimulation/data_simulation_",n,sep = ""), pattern = "*.mat",full.names = TRUE)
# names_query = list.files(paste("/home/shao.390/two_sample_network_inference/new_submission/datasimulation/example_",n,sep = ""), pattern = "*.mat",full.names = TRUE)
# truth_label  = ifelse(grepl(example,names_database),1,0)
# run_query = length(names_query)
# time_query = rep(0,run_query)
# distance_all = rep(0, run_query*length(names_database))
# dim(distance_all) = c(run_query,length(names_database))
# for (i in 1:run_query){
# 	data_query = readMat(names_query[i])$A
# 	start_time <- Sys.time()
# 	for (j in 1:length(names_database)){
# 		data_all = readMat(names_database[j])$A
# # 		res_single = nonpar.test(data_query,data_all)
# 		res_single = nonpar(data_query,data_all)
# 		distance_all[i,j] = res_single$`estimated p-value`
# 		}
# 	p_final = order(distance_all[i,])
# 	end_time <- Sys.time()
# 	time_query[i] = difftime(end_time, start_time, units = "secs")
# 	}
# write.matrix(distance_all, file = paste("/home/shao.390/two_sample_network_inference/new_submission/ROC_result/comparison2_non_R_",n,example,"1.csv",sep = ""))
# write.matrix(truth_label, file = paste("/home/shao.390/two_sample_network_inference/new_submission/ROC_result/truth_label2_R_",n,example,"1.csv",sep = ""))
# write.matrix(time_query, file = paste("/home/shao.390/two_sample_network_inference/new_submission/ROC_result/time_query2_R_",n,example,"1.csv",sep = ""))
