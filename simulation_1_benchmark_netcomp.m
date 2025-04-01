addpath('subroutines')

mall = [20,40,80,160, 320,640];
nall = [20,40,80,160, 320,640];
MotifNameall = ["Triangle","Vshape"];


iterc = 25;
cdelta = 0.01;

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
				
				% output to temp folder
				directory = "/home/Magpie/Network-two-sample-test/results/";
				filename1 = strcat("A_",...
						MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
						"100shift_",sprintf('%03d',100*shift_amount),...
						"m_", string(m), "n_", string(n));
				filename2 = strcat("B_",...
						MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
						"100shift_",sprintf('%03d',100*shift_amount),...
						"m_", string(m), "n_", string(n));
				py_filename1 = strcat(directory, filename1, ".csv");
				py_filename2 = strcat(directory, filename2, ".csv");
				writematrix(A,py_filename1);
				writematrix(B,py_filename2);
				commandStr = sprintf('python subroutines/method_benchmark_netcomp.py "%s" "%s"', filename1, filename2);
				[status, cmdout] = system(commandStr);
				if status ~= 0
				    disp('Error in executing Python script');
				    disp(cmdout);
				end
				py_output = readmatrix( strcat(directory, "py_temp_", filename1, filename2, ".csv") );
				py_output = py_output(:);


				% calculating confidence interval 
				sig_level = 0.1;
				
				if sig_level < py_output(2)
					coverage(i,1) = 1;
				else
					coverage(i,1) = 0;
				end
				
				time_cost(i,1) = py_output(3);

			end

			% output
			writematrix(coverage,strcat("./results/cover_netcomp_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				"100shift_",sprintf('%03d',100*shift_amount),...
				"m_", string(m), "n_", string(n),".csv"))

			writematrix(time_cost,strcat("./results/time_cost_netcomp_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				"100shift_",sprintf('%03d',100*shift_amount),...
				"m_", string(m), "n_", string(n),".csv"))
		end
	end % end for n
	fprintf('\n\n');
end