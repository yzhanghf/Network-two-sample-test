require(R.matlab)
library(R.matlab)
require(nonparGraphTesting)
library(nonparGraphTesting)
library(MASS)
library(abind)



set.seed(1)
names_database = "Final_data_facsimile.mat"
data_base = readMat(names_database)
data_NC = data_base$cor.NC.fisherZ.correct
data_SZ = data_base$cor.SZ.fisherZ.correct
data_all = abind(data_SZ,data_NC,along = 3)
time_cost = rep(0,1)
distance_all = rep(0, dim(data_all)[3]*dim(data_all)[3])
dim(distance_all) = c(dim(data_all)[3],dim(data_all)[3])
distance_all2 = rep(0, dim(data_all)[3]*dim(data_all)[3])
dim(distance_all2) = c(dim(data_all)[3],dim(data_all)[3])
distance_all3 = rep(0, dim(data_all)[3]*dim(data_all)[3])
dim(distance_all3) = c(dim(data_all)[3],dim(data_all)[3])
distance_all4 = rep(0, dim(data_all)[3]*dim(data_all)[3])
dim(distance_all4) = c(dim(data_all)[3],dim(data_all)[3])
start_time <- Sys.time()
for (i in 1:dim(data_all)[3]){
  data_query = data_all[,,i]
  for (j in 1:dim(data_all)[3]){
    data_query2 = data_all[,,j]
    #res_single = nonpar.test(data_query,data_query2)
    #distance_all[i,j] = res_single$'test statistic'
    #distance_all2[i,j] = res_single$`estimated p-value`
    res_single = nonpar(data_query,data_query2)
    #distance_all3[i,j] = res_single$'test statistic'
    distance_all4[i,j] = res_single$`estimated p-value`
  }
}
end_time <- Sys.time()
time_cost[1] = difftime(end_time, start_time, units = "secs")
write.matrix(distance_all4, file = paste("sz_R_dissimilarity_pvalue_ori.csv",sep = ""))
write.matrix(time_cost, file = paste("sz_R_dissimilarity_timecost.csv",sep = ""))

