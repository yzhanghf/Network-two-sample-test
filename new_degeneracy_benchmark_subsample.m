
% mall = [20,40,80];
% nall = [20,40,80];
mall = [80,160,320,640];
nall = [80,160,320,640];
MotifNameall = ["Triangle","Vshape"];

% GraphonName1 =  'NewDegenGraphon1';  GraphonName2 =  'NewDegenGraphon1';  A_sparse_power = -0.25;  B_sparse_power=-0.25;




iterc = 100;
N_boot = 200;
% cdelta = 0.01;

% alpha = 1.25;
% alpha = 1.5;
% alpha = 1.75;
% alpha = 2.0;
% alpha = 2.25;
% alpha = 2.5;

fprintf('alpha = %1.3f\n\n',alpha);

time_cost_mean = zeros(length(mall), length(nall));
time_cost_sd   = zeros(length(mall), length(nall));

for MotifName = MotifNameall
	fprintf('Motif = %s\n', MotifName);
	for m_idx = 1:length(mall)
		m = mall(m_idx);
		fprintf('m = %d\nn = ', m);
		for n_idx = 1:length(nall)
			n = nall(n_idx);
			fprintf('%d, ', n);

			if( strcmp(GraphonName1,GraphonName2) & (m>n) )
				fprintf('(skipped), ');
				continue;
			end
			
			if strcmp(MotifName,"Triangle")
				s = 3;
			else
				s = 2;
			end				
			rng(1);
			mu_m = graphon_mean(GraphonName1, MotifName);
			mu_n = graphon_mean(GraphonName2, MotifName);
% 			true_D = sparsity_parameters_a ^(-s)*sparsity_parameters_a ^s *mu_m - ...
% 				sparsity_parameters_b ^(-s)*sparsity_parameters_b ^s *mu_n;
            true_D = mu_m - mu_n;
			r = 3;
			coverage = zeros(iterc,1);
			coverage2 = zeros(iterc,1);
			t_mc = zeros(iterc,1);

			time_cost_temp = zeros(iterc,1);
			for i = 1:iterc

				% smooth = randn(1)*sqrt(cdelta*(log(m)*m^(-1/2)+log(n)*n^(-1/2)));
				smooth = 0;
				shift_amount = 0;

				X = rand(m,1);
				sparsity_parameters_a = m^A_sparse_power;
				W1 = graphon(X,X,sparsity_parameters_a,GraphonName1);  W1 = W1-diag(diag(W1));
				A = generate_A(W1);

				Y = rand(n,1);
				sparsity_parameters_b = n^B_sparse_power;
				W2 = graphon(Y,Y,sparsity_parameters_b,GraphonName2);  W2 = W2-diag(diag(W2));
				B = generate_A(W2+shift_amount);
				
				tic;
				[zzz1,zzz2,zzz3,zzz4] = method_benchmark_subsample(A,B,MotifName,N_boot);
				time_cost_temp(i) = toc;

				t_cm(i,1) = (zzz3-true_D)/zzz4;


				% calculating confidence interval 
				sig_level = 0.1;
				
				if zzz2 > sig_level
					coverage(i,1) = 1;
				else
					coverage(i,1) = 0;
				end

			end

			time_cost_mean(m_idx, n_idx) = mean(time_cost_temp);
			time_cost_sd(m_idx, n_idx)   = std(time_cost_temp);

			writematrix(coverage,strcat("./new-result-degenerate-CI-coverage/cover_subsample_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				'100UstatReduPow_',sprintf('%03d',100*alpha), ...
				'_100sparA_',sprintf('%03d',1000*abs(A_sparse_power)), ...
				'_100sparB_',sprintf('%03d',1000*abs(B_sparse_power)), ...
				"_m_", string(m), "n_", string(n),".csv"))
			% writematrix(coverage2,strcat("./new-result-degenerate-CI-coverage/cover_norm_",...
			% 	MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
			% 	"100shift_",sprintf('%03d',100*shift_amount),...
			% 	"m_", string(m), "n_", string(n),".csv"))
			writematrix(t_mc,strcat("./new-result-degenerate-CI-coverage/subsample_MC_t_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				'100UstatReduPow_',sprintf('%03d',100*alpha), ...
				'_100sparA_',sprintf('%03d',1000*abs(A_sparse_power)), ...
				'_100sparB_',sprintf('%03d',1000*abs(B_sparse_power)), ...
				"_m_", string(m), "n_", string(n),".csv"))
			% writematrix(t_mc,strcat("./new-result-degenerate-CI-coverage/MC_t_",...
			% 	MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
			% 	"100shift_",sprintf('%03d',100*shift_amount),...
			% 	"m_", string(m), "n_", string(n),".csv"))

			if( strcmp(GraphonName1,GraphonName2) & (m>n) )
				time_cost_mean(n_idx, m_idx) = mean(time_cost_temp);
				time_cost_sd(n_idx, m_idx)   = std(time_cost_temp);
				writematrix(coverage,strcat("./new-result-degenerate-CI-coverage/cover_subsample_",...
					MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
					'100UstatReduPow_',sprintf('%03d',100*alpha), ...
					'_100sparA_',sprintf('%03d',1000*abs(A_sparse_power)), ...
					'_100sparB_',sprintf('%03d',1000*abs(B_sparse_power)), ...
					"_m_", string(n), "n_", string(m),".csv"))
				writematrix(t_mc,strcat("./new-result-degenerate-CI-coverage/subsample_MC_t_",...
					MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
					'100UstatReduPow_',sprintf('%03d',100*alpha), ...
					'_100sparA_',sprintf('%03d',1000*abs(A_sparse_power)), ...
					'_100sparB_',sprintf('%03d',1000*abs(B_sparse_power)), ...
					"_m_", string(n), "n_", string(m),".csv"))
			end
			
		end % end for n
		fprintf('\n\n');
	end % end for m

	writematrix(time_cost_mean,strcat("./new-result-degenerate-CI-coverage/subsample_time_cost_mean_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				'100UstatReduPow_',sprintf('%03d',100*alpha),...
				'_100sparA_',sprintf('%03d',1000*abs(A_sparse_power)), ...
				'_100sparB_',sprintf('%03d',1000*abs(B_sparse_power)), ...
				".csv"))
	writematrix(time_cost_sd,strcat("./new-result-degenerate-CI-coverage/subsample_time_cost_sd_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				'100UstatReduPow_',sprintf('%03d',100*alpha),...
				'_100sparA_',sprintf('%03d',1000*abs(A_sparse_power)), ...
				'_100sparB_',sprintf('%03d',1000*abs(B_sparse_power)), ...
				".csv"))

end % end for MotifName