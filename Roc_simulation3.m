rng(1);
nall = [100,200,400,800,1600];
for n = nall
	GraphonName =  ["SmoothGraphon1","SmoothGraphon2","SmoothGraphon3",...
		"SmoothGraphon4","SmoothGraphon5","BlockModel1","BlockModel2",...
		"BlockModel3","BlockModel4","BlockModel5"];
	MotifName   = {'Triangle','Vshape'};
	sparsity_parameters_a = 0.4;
	ndata = 100;
	total_MC= 1;
	rec = zeros(ndata*length(GraphonName),2);

	for rndind = 1:total_MC
		mkdir(strcat("./data_simulation_",string(n)));
		mkdir(strcat("./data_hash_",string(n)));
		for i = 1:length(GraphonName)
			for j = 1:ndata
				graN = GraphonName(i);
				X = rand(n,1);
				W1 = graphon(X,X,sparsity_parameters_a,graN);  W1 = W1-diag(diag(W1));
				A = generate_A(W1);
				filenamesave = strcat("./data_simulation_",string(n),'/',graN,"_",string(j));
				save(filenamesave,'A');
			end
		end
		for i = 1:length(GraphonName)
			for j = 1:ndata
				graN = GraphonName(i);
				filenamesave = strcat("./data_hash_",string(n),'/',graN,"_",string(j));
				A = load(strcat("./data_simulation_",string(n),'/',graN,"_",string(j)));
				A = cell2mat(struct2cell(A));
				Our_method_NetHashing(A, MotifName,filenamesave);
			end
		end
		
		Files = dir(strcat("./data_hash_",string(n)));
		isdir = [Files.isdir];
		indexf = isdir ==0;
		Filesf = Files(indexf);
		example = "BlockModel1";  
		
		X = rand(n,1);
		W1 = graphon(X,X,sparsity_parameters_a,example);  W1 = W1-diag(diag(W1));
		A = generate_A(W1);
		conf_level = 0.05;
		filenamesave = strcat("./example",string(n));
		Our_method_NetHashing(A, MotifName,filenamesave);
		p_all = zeros(length(Filesf),length(MotifName));
		for i = 1:length(Filesf)
			[p_value, conf_int] = Our_method_FastTest(filenamesave, strcat(Filesf(i).folder,'/',Filesf(i).name), conf_level);
			p_all(i,:) =  p_value;
		end
		minmaxp = min(p_all,[],2);
		psort = sort(minmaxp);
		rmdir(strcat("./data_simulation_",string(n)),'s');
		rmdir(strcat("./data_hash_",string(n)),'s');
	end

	rec(:,1) = psort;
	writematrix(rec,strcat("./ROC_result/minpv_truth_",example,string(n),".csv"));

end




