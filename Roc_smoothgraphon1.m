rng(1)
MotifName   = {'Triangle','Vshape'};
GraphonName =  ["SmoothGraphon1","SmoothGraphon2","SmoothGraphon3",...
    "SmoothGraphon4","SmoothGraphon5","BlockModel1","BlockModel2",...
    "BlockModel3","BlockModel4","BlockModel5"];
sparsity_parameters_a = 0.4;
ndata = 100;
example = "SmoothGraphon1";
total_MC= 30;
elapsedTime = zeros(total_MC,1);
auc_r = zeros(total_MC,1);
rec = zeros(ndata*length(GraphonName),2);
rndind = 1;
conf_level = 0.05;
Files = dir(strcat("./datasimulation/data_hash_",string(n)));
isdir = [Files.isdir];
indexf = isdir ==0;
Filesf = Files(indexf);
Nameallf = contains({Filesf.name},example);
Truthind = Nameallf';
filenamesave = strcat("./datasimulation/example_hash_",string(n),'/',example,'_',string(rndind));
p_all = zeros(length(Filesf),length(MotifName));
for i = 1:length(Filesf)
	[p_value, conf_int] = Our_method_FastTest(filenamesave, strcat(Filesf(i).folder,'/',Filesf(i).name), conf_level);
	p_all(i,:) =  p_value;
end
minmaxp = min(p_all,[],2);

rec(:,1) = minmaxp;
rec(:,2) = Truthind;
writematrix(rec,strcat("./ROC_result/minpv_truth_pval_",example,string(n),".csv"));





