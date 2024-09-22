require(R.matlab)
library(R.matlab)
require(nonparGraphTesting)
library(nonparGraphTesting)
library(MASS)


args <- commandArgs(trailingOnly = TRUE)
set.seed(1)
n = as.numeric(args[1])
example = "SmoothGraphon1"
names_database = list.files(paste("./datasimulation/data_simulation_",n,sep = ""), pattern = "*.mat",full.names = TRUE)
names_query = list.files(paste("./datasimulation/example_",n,sep = ""), pattern = "*.mat",full.names = TRUE)
truth_label  = ifelse(grepl(example,names_database),1,0)
run_query = length(names_query)
time_query = rep(0,run_query)
distance_all = rep(0, run_query*length(names_database))
dim(distance_all) = c(run_query,length(names_database))
for (i in 1:run_query){
	data_query = readMat(names_query[i])$A
	start_time <- Sys.time()
	for (j in 1:length(names_database)){
		data_all = readMat(names_database[j])$A
# 		res_single = nonpar.test(data_query,data_all)
		res_single = nonpar(data_query,data_all)
		distance_all[i,j] = res_single$`estimated p-value`
		}
	p_final = order(distance_all[i,])
	end_time <- Sys.time()
	time_query[i] = difftime(end_time, start_time, units = "secs")
	}
write.matrix(distance_all, file = paste("./ROC_result/comparison2_non_R_",n,example,"1.csv",sep = ""))
write.matrix(truth_label, file = paste("./ROC_result/truth_label2_R_",n,example,"1.csv",sep = ""))
write.matrix(time_query, file = paste("./ROC_result/time_query2_R_",n,example,"1.csv",sep = ""))
