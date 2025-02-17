addpath('subroutines')

rng(1)
mall = [80,160,320,640];
nall = [80,160,320,640];
MotifNameall = ["Triangle","Vshape"];



iterc = 300;

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
			rng(2024);
			mu_m = graphon_mean(GraphonName1, MotifName);
			mu_n = graphon_mean(GraphonName2, MotifName);
            true_D = mu_m - mu_n;
			r = 3;
			coverage = zeros(iterc,1);
			coverage2 = zeros(iterc,1);
			t_mc = zeros(iterc,1);

			time_cost_temp = zeros(iterc,1);
			for i = 1:iterc

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
				zzz = ReducedMomentIndeterDegen(A,B,alpha,alpha,MotifName);
				time_cost_temp(i) = toc;

				D_mn = zzz(1)-zzz(2);
				D_mc(i,1) = D_mn;
				s_mn = sqrt(zzz(3));
				t_mc(i,1) = (D_mn-true_D)/s_mn;

				% calculating confidence interval 
				sig_level = 0.1;
				q_l = norminv(1-sig_level/2);
				q_u = norminv(sig_level/2);
				d_l = D_mn - s_mn*(q_l-smooth);
				d_u = D_mn - s_mn*(q_u-smooth);
				if true_D < d_u && true_D > d_l
					coverage(i,1) = 1;
				else
					coverage(i,1) = 0;
				end

			end

			time_cost_mean(m_idx, n_idx) = mean(time_cost_temp);
			time_cost_sd(m_idx, n_idx)   = std(time_cost_temp);

			writematrix(coverage,strcat("./results/cover_edge_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				'100UstatReduPow_',sprintf('%03d',100*alpha), ...
				'_100sparA_',sprintf('%03d',1000*abs(A_sparse_power)), ...
				'_100sparB_',sprintf('%03d',1000*abs(B_sparse_power)), ...
				"_m_", string(m), "n_", string(n),".csv"))
			writematrix(t_mc,strcat("./results/MC_t_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				'100UstatReduPow_',sprintf('%03d',100*alpha), ...
				'_100sparA_',sprintf('%03d',1000*abs(A_sparse_power)), ...
				'_100sparB_',sprintf('%03d',1000*abs(B_sparse_power)), ...
				"_m_", string(m), "n_", string(n),".csv"))

			if( strcmp(GraphonName1,GraphonName2) & (m>n) )
				time_cost_mean(n_idx, m_idx) = mean(time_cost_temp);
				time_cost_sd(n_idx, m_idx)   = std(time_cost_temp);
				writematrix(coverage,strcat("./results/cover_edge_",...
					MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
					'100UstatReduPow_',sprintf('%03d',100*alpha), ...
					'_100sparA_',sprintf('%03d',1000*abs(A_sparse_power)), ...
					'_100sparB_',sprintf('%03d',1000*abs(B_sparse_power)), ...
					"_m_", string(n), "n_", string(m),".csv"))
				writematrix(t_mc,strcat("./results/MC_t_",...
					MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
					'100UstatReduPow_',sprintf('%03d',100*alpha), ...
					'_100sparA_',sprintf('%03d',1000*abs(A_sparse_power)), ...
					'_100sparB_',sprintf('%03d',1000*abs(B_sparse_power)), ...
					"_m_", string(n), "n_", string(m),".csv"))
			end
			
		end % end for n
		fprintf('\n\n');
	end % end for m

	writematrix(time_cost_mean,strcat("./results/time_cost_mean_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				'100UstatReduPow_',sprintf('%03d',100*alpha),...
				'_100sparA_',sprintf('%03d',1000*abs(A_sparse_power)), ...
				'_100sparB_',sprintf('%03d',1000*abs(B_sparse_power)), ...
				".csv"))
	writematrix(time_cost_sd,strcat("./results/time_cost_sd_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				'100UstatReduPow_',sprintf('%03d',100*alpha),...
				'_100sparA_',sprintf('%03d',1000*abs(A_sparse_power)), ...
				'_100sparB_',sprintf('%03d',1000*abs(B_sparse_power)), ...
				".csv"))

end % end for MotifName