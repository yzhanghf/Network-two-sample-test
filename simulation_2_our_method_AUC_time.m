addpath('subroutines')

% Preamble: set network sizes, motif types and folder for temporary I/O files.
rng(1)
GraphonName =  ["SmoothGraphon1","SmoothGraphon2","SmoothGraphon3",...
    "SmoothGraphon4","SmoothGraphon5","BlockModel1","BlockModel2",...
    "BlockModel3","BlockModel4","BlockModel5"];
MotifName   = {'Triangle','Vshape'};
sparsity_parameters_a = 0.4;
ndata = 100;
example = "SmoothGraphon1";
mkdir(strcat("./results/data_simulation_",string(n)));
mkdir(strcat("./results/data_hash_",string(n)));
mkdir(strcat("./results/example_",string(n)));
mkdir(strcat("./results/example_hash_",string(n)));
time_hash = zeros(1,1);
for i = 1:length(GraphonName)
    for j = 1:ndata
        graN = GraphonName(i);
        X = rand(n,1);
        W1 = graphon(X,X,sparsity_parameters_a,graN);  W1 = W1-diag(diag(W1));%  W = W *sparsity_multiplier(n);
        A = generate_A(W1);
        filenamesave = strcat("./results/data_simulation_",string(n),'/',graN,"_",string(j));
        save(filenamesave,'A');
    end
end
tic;
for i = 1:length(GraphonName)
    for j = 1:ndata
        graN = GraphonName(i);
        filenamesave = strcat("./results/data_hash_",string(n),'/',graN,"_",string(j));
        A = load(strcat("./results/data_simulation_",string(n),'/',graN,"_",string(j)));
        A = cell2mat(struct2cell(A));
        Our_method_NetHashing(A, MotifName,filenamesave);
    end
end
time_hash(1,1) = toc;
total_MC= 30;
elapsedTime = zeros(total_MC,1);
auc_r = zeros(total_MC,1);
rec = zeros(ndata*length(GraphonName),2);
for rndind = 1:total_MC
    Files = dir(strcat("./results/data_hash_",string(n)));
    isdir = [Files.isdir];
    indexf = isdir ==0;
    Filesf = Files(indexf);

    Nameallf = contains({Filesf.name},example);
    Truthind = Nameallf';
    
    X = rand(n,1);
    W1 = graphon(X,X,sparsity_parameters_a,example);  W1 = W1-diag(diag(W1));%  W = W *sparsity_multiplier(n);
    A = generate_A(W1);
    conf_level = 0.05;
    filenamesave_ori = strcat("./results/example_",string(n),'/',example,'_',string(rndind));
    save(filenamesave_ori,'A');
    filenamesave = strcat("./results/example_hash_",string(n),'/',example,'_',string(rndind));
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
    [x1,y1,T,AUC] = perfcurve(Truthind,minmaxp,1);
    auc_r(rndind,1) = AUC;
end

rec(:,1) = minmaxp;
rec(:,2) = Truthind;
writematrix(rec,strcat("./results/minpv_truth_pval_",example,string(n),".csv"));
writematrix(elapsedTime,strcat("./results/querytime_pval_",example,string(n),".csv"));
writematrix(time_hash,strcat("./results/hashtime_pval_",example,string(n),".csv"));
writematrix(auc_r,strcat("./results/auc_pval_",example,string(n),".csv"));






