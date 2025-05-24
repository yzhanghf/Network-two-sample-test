addpath('subroutines')

% Preamble: set network sizes and motif types.

mnall = [40,80,160,320];
null_prop_all = 0.1:0.1:0.9;
N_networks = 300;
MotifNameall = ["Triangle","Vshape"];
calA_set_quantile = 0.05;
sig_level = 0.1;


if (strcmp(GraphonName1, GraphonName2))
	error('Must be different graphons!\n')
end

iterc = 100;

fprintf('Ntests = %d\n\n',N_networks);

for MotifName = MotifNameall
	fprintf('Motif = %s\n', MotifName);
	for mn_idx = 1:length(mnall)
		m = mnall(mn_idx);
		n = mnall(mn_idx);
		fprintf('m,n=%d\n', m);
			
		if strcmp(MotifName,"Triangle")
			s = 3;
		else
			s = 2;
		end				
		rng(1);

		FDR_mean_record = [];
		FDR_sd_record = [];
		power_mean_record = [];
		power_sd_record = [];

		for null_prop_idx = 1:length(null_prop_all)

			null_prop = null_prop_all(null_prop_idx);

			fprintf('%2d%% ', 100*null_prop);

			N_null = floor(null_prop*N_networks);

			mu_m = graphon_mean(GraphonName1, MotifName);
			mu_n = graphon_mean(GraphonName2, MotifName);
            true_D = mu_m - mu_n;
			r = 3;
			coverage = zeros(iterc,1);
			coverage2 = zeros(iterc,1);
			t_mc = zeros(iterc,1);

			time_cost_temp = zeros(iterc,1);

			FDP_vec = [];
			power_vec = [];

			for i = 1:iterc

				% smooth = randn(1)*sqrt(cdelta*(log(m)*m^(-1/2)+log(n)*n^(-1/2)));
				smooth = 0;

				X = rand(m,1);
				W1 = graphon(X,X,sparsity_parameters_a,GraphonName1);  W1 = W1-diag(diag(W1));
				A = generate_A(W1);

				time_cost_temp(i) = 0;

				t_vec = [];
				smn_vec = [];
				alpha1_vec = [];
				p_value_hat_vec = [];

				for query_index = 1:N_networks

					Y = rand(n,1);

					if query_index <= N_null
						W2 = graphon(Y,Y,sparsity_parameters_b,GraphonName1);  
					else
						W2 = graphon(Y,Y,sparsity_parameters_b,GraphonName2);
						W2 = W2 + graphon_shift;
					end

					W2 = W2-diag(diag(W2));
					B = generate_A(W2);

					tic;
					zzz = Our_method_classic(A,B,MotifName,sig_level);
					time_cost_temp(i) = time_cost_temp(i)+toc;

					t_mn = zzz(4);
					t_vec(query_index,1) = t_mn;
					smn_vec(query_index,1) = zzz(5);
					alpha1_vec(query_index,1) = sqrt(zzz(6));
					p_value_hat_vec(query_index,1) = zzz(3);

				end
				
				gamma_vec = alpha1_vec ./ smn_vec;
				ak_vec = 1./sqrt(1-gamma_vec.^2);  ak_vec = ak_vec(:);
				calA_set = find( t_vec <= quantile(t_vec,calA_set_quantile) );
				omega_est = sum( t_vec(calA_set).*gamma_vec(calA_set) ) / sum( gamma_vec(calA_set).^2 );
				eta_vec = omega_est * gamma_vec;

				% grid search t
				t_grid = 0.005:0.005:(3*sig_level);
				LHS_grid_num = sum( ...
							  normcdf(ak_vec*norminv(t_grid/2)+(ak_vec.*eta_vec)*ones(1,length(t_grid))) ...
							+ normcdf(ak_vec*norminv(t_grid/2)-(ak_vec.*eta_vec)*ones(1,length(t_grid))) ...
							, 1);
				LHS_grid_denom = sum( (p_value_hat_vec*ones(1,length(t_grid))<=ones(N_networks,1)*t_grid), 1 );
				LHS_grid = LHS_grid_num ./ LHS_grid_denom;
				cut_idx = find(LHS_grid <= sig_level, 1, 'last');

				Reject_set = find( p_value_hat_vec <= t_grid(cut_idx) );
				FDP_vec(i,1) = sum(Reject_set <= N_null) / (length(Reject_set)+1e-10);
				power_vec(i,1) = sum(Reject_set > N_null) / (N_networks - N_null);

			end % end for i

			FDR_mean_record(null_prop_idx,1) = mean(FDP_vec);
			FDR_sd_record(null_prop_idx,1) = std(FDP_vec);
			power_mean_record(null_prop_idx,1) = mean(power_vec);
			power_sd_record(null_prop_idx,1) = std(power_vec);

			
		end % end for null_prop

		writematrix(FDR_mean_record,strcat("./results/query_FDR_mean_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				'Ntests_',sprintf('%d',N_networks), ...
				'_CalAquant_', sprintf('%2d', 100*calA_set_quantile), ...
				'_shift_', sprintf('%2d', 100*graphon_shift), ...
				"_mn_", string(m),".csv"))

		writematrix(FDR_sd_record,strcat("./results/query_FDR_sd_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				'Ntests_',sprintf('%d',N_networks), ...
				'_CalAquant_', sprintf('%2d', 100*calA_set_quantile), ...
				'_shift_', sprintf('%2d', 100*graphon_shift), ...
				"_mn_", string(m),".csv"))

		writematrix(power_mean_record,strcat("./results/query_power_mean_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				'Ntests_',sprintf('%d',N_networks), ...
				'_CalAquant_', sprintf('%2d', 100*calA_set_quantile), ...
				'_shift_', sprintf('%2d', 100*graphon_shift), ...
				"_mn_", string(m),".csv"))

		writematrix(power_sd_record,strcat("./results/query_power_sd_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				'Ntests_',sprintf('%d',N_networks), ...
				'_CalAquant_', sprintf('%2d', 100*calA_set_quantile), ...
				'_shift_', sprintf('%2d', 100*graphon_shift), ...
				"_mn_", string(m),".csv"))


		fprintf('\n');

	end % end for m

end % end for MotifName