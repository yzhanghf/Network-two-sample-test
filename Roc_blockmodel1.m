rng(1)
MotifName   = {'Triangle','Vshape'};
GraphonName =  ["SmoothGraphon1","SmoothGraphon2","SmoothGraphon3",...
    "SmoothGraphon4","SmoothGraphon5","BlockModel1","BlockModel2",...
    "BlockModel3","BlockModel4","BlockModel5"];
sparsity_parameters_a = 0.4;
ndata = 100;
example = "BlockModel1";
mkdir(strcat("./datasimulation/example_",example,string(n)));
mkdir(strcat("./datasimulation/example_hash_",example,string(n)));

total_MC= 30;
elapsedTime = zeros(total_MC,1);
auc_r = zeros(total_MC,1);
rec = zeros(ndata*length(GraphonName),2);
for rndind = 1:total_MC
    Files = dir(strcat("./datasimulation/data_hash_",string(n)));
    isdir = [Files.isdir];
    indexf = isdir ==0;
    Filesf = Files(indexf);

    Nameallf = contains({Filesf.name},example);
    Truthind = Nameallf';
    
    X = rand(n,1);
    W1 = graphon(X,X,sparsity_parameters_a,example);  W1 = W1-diag(diag(W1));%  W = W *sparsity_multiplier(n);
    A = generate_A(W1);
    conf_level = 0.05;
    filenamesave_ori = strcat("./datasimulation/example_",example,string(n),'/',example,'_',string(rndind));
    save(filenamesave_ori,'A');
    filenamesave = strcat("./datasimulation/example_hash_",example,string(n),'/',example,'_',string(rndind));
    tic; 
    Our_method_NetHashing(A, MotifName,filenamesave);
	p_all = zeros(length(Filesf),length(MotifName));
	for i = 1:length(Filesf)
		[p_value, conf_int] = Our_method_FastTest(filenamesave, strcat(Filesf(i).folder,'/',Filesf(i).name), conf_level);
		p_all(i,:) =  p_value;
	end
	minmaxp = min(p_all,[],2);
	psort = sort(minmaxp);
    elapsedTime(rndind,1) = toc;
end

rec(:,1) = minmaxp;
rec(:,2) = Truthind;
writematrix(rec,strcat("./ROC_result/minpv_truth_pval_",example,string(n),".csv"));
writematrix(elapsedTime,strcat("./ROC_result/querytime_pval_",example,string(n),".csv"));





