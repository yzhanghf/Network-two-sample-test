
function [t_stat, p_value, test_stat_output_1, test_stat_output_2] = method_benchmark_resample(A,B,MotifName,N_boot)
	
	m = size(A,1);
	n = size(B,1);

	rng(1);

	switch MotifName
	case "Triangle"
		r=3;s=3;
	case "Vshape"
		r=3;s=2;
	end

	rho_A_list = [];
	u_m_list   = [];
	rho_B_list = [];
	v_n_list   = [];

	for(ii = 1:N_boot)
		A_idx = randi(m,m,1);
		A_temp = A(A_idx,A_idx);
		rho_A_list(ii) = sum(sum(A_temp))/(m*(m-1));
		u_m_list(ii) = Motif(A_temp,0,MotifName);

		B_idx = randi(n,n,1);
		B_temp = B(B_idx,B_idx);
		rho_B_list(ii) = sum(sum(B_temp))/(n*(n-1));
		v_n_list(ii) = Motif(B_temp,0,MotifName);

	end

	test_stat_list = rho_A_list.^(-s).*u_m_list - rho_B_list.^(-s).*v_n_list;

	rho_A_obs = sum(sum(A))/(m*(m-1));
	u_m_obs = Motif(A,0,MotifName);
	rho_B_obs = sum(sum(B))/(n*(n-1));
	v_n_obs = Motif(B,0,MotifName);


	t_stat = rho_A_obs^(-s)*u_m_obs - rho_B_obs^(-s)*v_n_obs;

	p_value = mean( test_stat_list<t_stat );
	p_value = 2*min([p_value, 1-p_value]);

	test_stat_output_1 = test_stat_list(1);
	test_stat_output_2 = std(test_stat_list);
	
end