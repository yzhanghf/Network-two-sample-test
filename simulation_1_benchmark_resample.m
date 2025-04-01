addpath('subroutines')

mall = [20,40,80,160, 320,640];
nall = [20,40,80,160, 320,640];
MotifNameall = ["Triangle","Vshape"];


iterc = 100;
cdelta = 0.01;
N_boot = 200;

for m = mall
	fprintf('m = %d\nn = ', m);
	for n = nall
		fprintf('%d, ', n);
		for MotifName = MotifNameall
			% generate data
			if MotifName == "Triangle"
				s = 3;
			else
				s = 2;
			end				
			rng(1);
			mu_m = graphon_mean(GraphonName1, MotifName);
			mu_n = graphon_mean(GraphonName2, MotifName);
            true_D = mu_m - mu_n;
			r = 3;
			coverage 	= zeros(iterc,1);
			coverage2 	= zeros(iterc,1);
			t_mc 		= zeros(iterc,1);
			time_cost 	= zeros(iterc,1);
			for i = 1:iterc
				smooth = randn(1)*sqrt(cdelta*(log(m)*m^(-1/2)+log(n)*n^(-1/2)));
				X = rand(m,1);
				W1 = graphon(X,X,sparsity_parameters_a,GraphonName1);  W1 = W1-diag(diag(W1));
				A = generate_A(W1);
				Y = rand(n,1);
				W2 = graphon(Y,Y,sparsity_parameters_b,GraphonName2);  W2 = W2-diag(diag(W2));
				B = generate_A(W2+shift_amount);
				
				tic;
				[t_stat, p_value] = method_benchmark_resample(A,B,MotifName,N_boot);
				time_cost(i,1) = toc;


				% calculating confidence interval 
				sig_level = 0.1;
				
				if sig_level < p_value
					coverage(i,1) = 1;
				else
					coverage(i,1) = 0;
				end
				

			end

			writematrix(coverage,strcat("./results/cover_resample_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				"100shift_",sprintf('%03d',100*shift_amount),...
				"m_", string(m), "n_", string(n),".csv"))

			writematrix(time_cost,strcat("./results/time_cost_resample_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				"100shift_",sprintf('%03d',100*shift_amount),...
				"m_", string(m), "n_", string(n),".csv"))
		end
	end % end for n
	fprintf('\n\n');
end