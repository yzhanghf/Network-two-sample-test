
% mall = [20,40,80];
% nall = [20,40,80];
mall = [80,160,320,640];
nall = [80,160,320,640];
MotifNameall = ["Triangle","Vshape"];


% GraphonName1 =  'NewDegenGraphon1';  GraphonName2 =  'NewDegenGraphon1';  A_sparse_power = -0.25;  B_sparse_power=-0.25;




iterc = 500;
% cdelta = 0.01;

% alpha = 1.25;
% alpha = 1.5;
% alpha = 1.75;
% alpha = 2.0;
alpha = 2.25;
% alpha = 2.5;

fprintf('alpha = %1.3f\n\n',alpha);


for m = mall
	fprintf('m = %d\nn = ', m);
	for n = nall
		fprintf('%d, ', n);
		for MotifName = MotifNameall
			if MotifName == "Triangle"
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
				

				zzz = ReducedMomentIndeterDegen(A,B,alpha,alpha,'Triangle');
				D_mn = zzz(1)-zzz(2);
				s_mn = sqrt(zzz(3));
				t_mc(i,1) = (D_mn-true_D)/s_mn;


				% % first calculate all statistics needed from A
				% rho_ahat = sum(A(:))/(m*(m-1));
				% u_mhat = Motif(A, 0, MotifName);
				% g_ahat = Motif(A, 1, MotifName);
				% g_rhoa_h = Motif(A, 1, 'Edge');
				% a1 = r*rho_ahat ^(-s).*g_ahat -2*s*rho_ahat ^(-s-1)*u_mhat.*g_rhoa_h;

				% % var_source_2A = 
				
				% % calculating statistics needed from B
				% rho_bhat = sum(B(:))/(n*(n-1));
				% v_nhat = Motif(B, 0, MotifName);
				% g_bhat = Motif(B, 1, MotifName);
				% g_rhob_h = Motif(B, 1, 'Edge');
				% b1 = r*rho_bhat ^(-s).*g_bhat -2*s*rho_bhat ^(-s-1)*v_nhat.*g_rhob_h;
				
				
				% calculating t ststistics and t hat
				% var_source_1 = 1/m^2*sum(a1.^2)+1/n^2*sum(b1.^2);
				% var_source_2 = ;
				% var_source_3 = u_mhat/m + v_nhat/n;
				
				% D_mn = rho_ahat ^(-s)*u_mhat - rho_bhat ^(-s)*v_nhat;
				% t_mc(i,1) = (D_mn - true_D)/sqrt(var_overall);
				



				% calculating confidence interval 
				sig_level = 0.1;
				% q_l = norminv(1-alpha/2) + I0 +q1+q2*(norminv(1-alpha/2)^2-1 );
				% q_u = norminv(alpha/2) + I0 +q1+q2*(norminv(alpha/2)^2-1);
				% d_l = D_mn - s_mn*(q_l-smooth);
				% d_u = D_mn - s_mn*(q_u-smooth);
				% if true_D < d_u && true_D > d_l
				% 	coverage(i,1) = 1;
				% else
				% 	coverage(i,1) = 0;
				% end
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

			writematrix(coverage,strcat("./new-result-degenerate-CI-coverage/cover_edge_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				'100UstatReduPow_',sprintf('%03d',100*alpha), ...
				"m_", string(m), "n_", string(n),".csv"))
			% writematrix(coverage2,strcat("./new-result-degenerate-CI-coverage/cover_norm_",...
			% 	MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
			% 	"100shift_",sprintf('%03d',100*shift_amount),...
			% 	"m_", string(m), "n_", string(n),".csv"))
			writematrix(t_mc,strcat("./new-result-degenerate-CI-coverage/MC_t_",...
				MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				'100UstatReduPow_',sprintf('%03d',100*alpha), ...
				"m_", string(m), "n_", string(n),".csv"))
			% writematrix(t_mc,strcat("./new-result-degenerate-CI-coverage/MC_t_",...
			% 	MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
			% 	"100shift_",sprintf('%03d',100*shift_amount),...
			% 	"m_", string(m), "n_", string(n),".csv"))
		end
	end % end for n
	fprintf('\n\n');
end