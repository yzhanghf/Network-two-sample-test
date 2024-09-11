function [output] = ReducedMomentIndeterDegen(A,B, alpha_A,alpha_B, MotifName)

	m = size(A,1);
	n = size(B,1);

	switch MotifName
	case 'Triangle'
		r = 3; s = 3;
	case 'Vshape'
		r = 3; s = 2;
	end

	% Generate the randomly selected reduced index set JMA, its size being jma
	jma = floor(m^alpha_A);
	% JMA = zeros(jma, r);
	% for (ii = 1:jma)
	% 	JMA(ii, :) = datasample(1:m, r, 'Replace', false);
	% end
	count_valid = 0;
	JMA = [];
	while(count_valid<jma)
		temp_mat = randi([1,m], floor(jma/10), r);
		unique_columns = logical(ones(floor(jma/10),1));
		for(rr1 = 1:(r-1))
			for(rr2 = (rr1+1):r)
				unique_columns = unique_columns & (temp_mat(:,rr1)~=temp_mat(:,rr2));
			end
		end
		count_valid = count_valid + sum(unique_columns);
		JMA = [JMA; temp_mat(unique_columns,:)];
	end
	JMA = JMA(1:jma,:);

	jnb = floor(n^alpha_B);
	% JNB = zeros(jnb, r);
	% for (jj = 1:jnb)
	% 	JNB(jj, :) = datasample(1:n, r, 'Replace', false);
	% end
	count_valid = 0;
	JNB = [];
	while(count_valid<jnb)
		temp_mat = randi([1,n], floor(jnb/10), r);
		unique_columns = logical(ones(floor(jnb/10),1));
		for(rr1 = 1:(r-1))
			for(rr2 = (rr1+1):r)
				unique_columns = unique_columns & (temp_mat(:,rr1)~=temp_mat(:,rr2));
			end
		end
		count_valid = count_valid + sum(unique_columns);
		JNB = [JNB; temp_mat(unique_columns,:)];
	end
	JNB = JNB(1:jnb,:);


	% Compute statistics for output
	switch MotifName
	case 'Triangle'
		% Compute point estimator and variance estimator for data A
		% idx_list_A_12 = sub2ind(size(A),JMA(:,1),JMA(:,2));
		% idx_list_A_23 = sub2ind(size(A),JMA(:,2),JMA(:,3));
		% idx_list_A_31 = sub2ind(size(A),JMA(:,3),JMA(:,1));
		idx_list_A_12 = JMA(:,1)+(JMA(:,2)-1)*m;
		idx_list_A_23 = JMA(:,2)+(JMA(:,3)-1)*m;
		idx_list_A_31 = JMA(:,3)+(JMA(:,1)-1)*m;
		A_list_12 = A(idx_list_A_12);
		A_list_23 = A(idx_list_A_23);
		A_list_31 = A(idx_list_A_31);
		ga_list_1 = A_list_12.*A_list_23.*A_list_31;
		% ga_list_2 = A_list_23.*A_list_31.*A_list_12;
		% ga_list_3 = A_list_31.*A_list_12.*A_list_23;
		u_mhat    = mean(ga_list_1);
		rho_ahat  = mean([A_list_12]);
		% ua = [JMA(:,1)];  ua_freq = histcounts(ua, 0.5:1:(m+0.5));  ua_freq = ua_freq(:)+1e-10;  %ua_freq = histc(ua, [1:m]);
		% ga_list   = accumarray(ua, [ga_list_1], [m,1])./ua_freq;%, [m,1], @mean, 0);
		% grhoa_list= sum(A,2)/(m-1);%, [m,1], @mean, 0);
		A_sq = A*A/(m-1);
		A_3 = A*A_sq/(m-2);
		ga_list = diag(A_3);
		grhoa_list= sum(A,2)/(m-1);

		a1 = r*rho_ahat ^(-s).*(ga_list-mean(ga_list)) - 2*s*rho_ahat ^(-s-1)*u_mhat.*(grhoa_list-mean(grhoa_list));
		var_source_A1 = mean(a1.^2)/m;

		% coef_list_A_12 = A_list_23.*A_list_31;
		% % coef_list_A_23 = A_list_31.*A_list_12;
		% % coef_list_A_31 = A_list_12.*A_list_23;
		% LL = [[JMA(:,1:2)]];
		% % swapIndices = LL(:,1) > LL(:,2);
		% % LL(swapIndices, :) = LL(swapIndices, [2, 1]);
		% % coef_list_A = accumarray(sub2ind(size(A),LL(:,1),LL(:,2)), [coef_list_A_12;coef_list_A_23;coef_list_A_31], [m^2,1], @sum,0);
		% coef_list_A = accumarray(LL(:,1)+(LL(:,2)-1)*m, [coef_list_A_12], [m^2,1]);
		% coef_list_A = reshape(coef_list_A,[m,m]);
		% coef_list_A = (coef_list_A + coef_list_A')/sqrt(2);
		% var_source_A2 = rho_ahat ^(-2*s) * sum(sum( (coef_list_A.^2).*A )) / (jma^2);
		% if(alpha_A<2)
			% Theta_list = A_sq(JMA(:,1)+(JMA(:,2)-1)*m);
			% var_source_A2 = rho_ahat ^(-2*s) * sum( A_list_12.*(Theta_list.^2) ) / (jma^2);
		% else
		% 	var_source_A2 = rho_ahat ^(-2*s) * sum(sum((A_sq.^2) .* A)) / (m*(m-1));
		% end
		if(alpha_A<=2)
			var_source_A2 = 0;
		else
			% temp_idx_list_A = JMA(:,1)+(JMA(:,2)-1)*m;
			% Coef_mat_A = zeros(m,m);
			% Ceof_mat_A(temp_idx_list_A) = A_sq(temp_idx_list_A);
			% Coef_mat_A = Coef_mat_A + Coef_mat_A';
			% Coef_mat_A = Coef_mat_A./(rho_ahat^s * m^alpha_A) - 2*s/(rho_ahat*m*(m-1));
			% Coef_mat_A = triu(Coef_mat_A,1);
			% var_source_A2 = sum(sum(  Coef_mat_A.^2 .* A  ));

			Theta_list = A_sq(JMA(:,1)+(JMA(:,2)-1)*m) / (rho_ahat^s*jma) - s/(rho_ahat*jma);
			var_source_A2 =  sum( A_list_12.*(Theta_list.^2) );
		end


		var_source_A3 = rho_ahat ^(-2*s) * u_mhat / jma;


		% Compute point estimator and variance estimator for data B
		% idx_list_B_12 = sub2ind(size(B),JNB(:,1),JNB(:,2));
		% idx_list_B_23 = sub2ind(size(B),JNB(:,2),JNB(:,3));
		% idx_list_B_31 = sub2ind(size(B),JNB(:,3),JNB(:,1));
		idx_list_B_12 = JNB(:,1)+(JNB(:,2)-1)*n;
		idx_list_B_23 = JNB(:,2)+(JNB(:,3)-1)*n;
		idx_list_B_31 = JNB(:,3)+(JNB(:,1)-1)*n;
		B_list_12 = B(idx_list_B_12);
		B_list_23 = B(idx_list_B_23);
		B_list_31 = B(idx_list_B_31);
		gb_list_1 = B_list_12.*B_list_23.*B_list_31;
		% gb_list_2 = B_list_23.*B_list_31.*B_list_12;
		% gb_list_3 = B_list_31.*B_list_12.*B_list_23;
		v_nhat    = mean(gb_list_1);
		rho_bhat  = mean([B_list_12]);
		% ub = [JNB(:,1)];  ub_freq = histcounts(ub, 0.5:1:(n+0.5));  ub_freq = ub_freq(:)+1e-10;%  ub_freq = histc(ub, [1:n]);
		% gb_list   = accumarray(ub, [gb_list_1], [n,1])./ub_freq;% , @mean, 0);
		% grhob_list= accumarray(ub, [B_list_12], [n,1])./ub_freq;% , @mean, 0);
		B_sq = B*B/(n-1);
		B_3 = B*B_sq/(n-2);
		gb_list = diag(B_3);
		grhob_list= sum(B,2)/(n-1);

		b1 = r*rho_bhat ^(-s).*(gb_list-mean(gb_list)) -2*s*rho_bhat ^(-s-1)*v_nhat.*(grhob_list-mean(grhob_list));
		var_source_B1 = mean(b1.^2)/n;


		% coef_list_B_12 = B_list_23.*B_list_31;
		% coef_list_B_23 = B_list_31.*B_list_12;
		% coef_list_B_31 = B_list_12.*B_list_23;
		% LL = [[JNB(:,1:2)]];
		% % swapIndices = LL(:,1) > LL(:,2);
		% % LL(swapIndices, :) = LL(swapIndices, [2, 1]);
		% coef_list_B = accumarray(LL(:,1)+(LL(:,2)-1)*n, [coef_list_B_12], [n^2,1]);
		% coef_list_B = reshape(coef_list_B,[n,n]);
		% coef_list_B = (coef_list_B + coef_list_B')/sqrt(2);
		% var_source_B2 = rho_bhat ^(-2*s) * sum(sum( (coef_list_B.^2).*B )) / (jnb^2);
		% if(alpha_B<2)
			% Theta_B_list = B_sq(JNB(:,1)+(JNB(:,2)-1)*n);
			% var_source_B2 = rho_bhat ^(-2*s) * sum( B_list_12.*(Theta_B_list.^2) ) / (jnb^2)  * n^(max(alpha_B-2,0));
		% else
		% 	var_source_B2 = rho_bhat ^(-2*s) * sum(sum((B_sq.^2) .* B)) / (n*(n-1));
		% end
		if(alpha_B<=2)
			var_source_B2 = 0;
		else
			% temp_idx_list_B = JNB(:,1)+(JNB(:,2)-1)*n;
			% Coef_mat_B = zeros(n,n);
			% Ceof_mat_B(temp_idx_list_B) = B_sq(temp_idx_list_B);
			% Coef_mat_B = Coef_mat_B + Coef_mat_B';
			% Coef_mat_B = Coef_mat_B./(rho_bhat^s * n^alpha_B) - 2*s/(rho_bhat*n*(n-1));
			% Coef_mat_B = triu(Coef_mat_B,1);
			% var_source_B2 = sum(sum(  Coef_mat_B.^2 .* B  ));

			Theta_list = B_sq(JNB(:,1)+(JNB(:,2)-1)*n) / (rho_bhat^s*jnb) - s/(rho_bhat*jnb);
			var_source_B2 =  sum( B_list_12.*(Theta_list.^2) );
		end

		var_source_B3 = rho_bhat ^(-2*s) * v_nhat / jnb;


	case 'Vshape'

		% Compute point estimator and variance estimator for data A
		% idx_list_A_12 = sub2ind(size(A),JMA(:,1),JMA(:,2));
		% idx_list_A_23 = sub2ind(size(A),JMA(:,2),JMA(:,3));
		% idx_list_A_31 = sub2ind(size(A),JMA(:,3),JMA(:,1));
		idx_list_A_12 = JMA(:,1)+(JMA(:,2)-1)*m;
		idx_list_A_23 = JMA(:,2)+(JMA(:,3)-1)*m;
		idx_list_A_31 = JMA(:,3)+(JMA(:,1)-1)*m;
		A_list_12 = A(idx_list_A_12);
		A_list_23 = A(idx_list_A_23);
		A_list_31 = A(idx_list_A_31);
		ga_list_1 = A_list_12.*A_list_23 + A_list_23.*A_list_31 + A_list_31.*A_list_12;
		% ga_list_2 = A_list_23.*A_list_31;
		% ga_list_3 = A_list_31.*A_list_12;
		u_mhat    = mean(ga_list_1);
		rho_ahat  = mean([A_list_12;A_list_23;A_list_31]);
		% ga_list   = accumarray([JMA(:,1);JMA(:,2);JMA(:,3)], [ga_list_1;ga_list_2;ga_list_3], [m,1], @mean, 0)*3;
		% ua = [JMA(:,1)];  ua_freq = histcounts(ua, 0.5:1:(m+0.5));  ua_freq = ua_freq(:)+1e-10;
		% ga_list   = accumarray(ua, [ga_list_1], [m,1])./ua_freq;
		% grhoa_list= accumarray(ua, [A_list_12], [m,1])./ua_freq;
		A_sq = A*A/(m-1);  A_sq = A_sq - diag(diag(A_sq));
		vv = sum(A,2);
		y  = (vv.*(vv-1)/2 + sum(A_sq,2)) / ((m-1)*(m-2)/2);
		x  = mean(y);
		ga_list  = y - x;
		grhoa_list = vv/(m-1);

		a1 = r*rho_ahat ^(-s).*(ga_list - mean(ga_list)) -2*s*rho_ahat ^(-s-1)*u_mhat.*(grhoa_list - mean(grhoa_list));
		var_source_A1 = mean(a1.^2)/m;

		coef_list_A_12 = A_list_23+A_list_31;
		coef_list_A_23 = A_list_31+A_list_12;
		coef_list_A_31 = A_list_12+A_list_23;
		LL = [[JMA(:,1:2)]];
		% swapIndices = LL(:,1) > LL(:,2);
		% LL(swapIndices, :) = LL(swapIndices, [2, 1]);
		% coef_list_A = accumarray(sub2ind(size(A),LL(:,1),LL(:,2)), [coef_list_A_12;coef_list_A_23;coef_list_A_31], [m^2,1], @sum,0);
		% coef_list_A = reshape(coef_list_A,[m,m]);
		% coef_list_A = accumarray(LL(:,1)+(LL(:,2)-1)*m, [coef_list_A_12], [m^2,1]);
		% coef_list_A = reshape(coef_list_A,[m,m]);
		% coef_list_A = (coef_list_A + coef_list_A')/sqrt(2);
		% var_source_A2 = rho_ahat ^(-2*s) * sum(sum( (coef_list_A.^2).*A )) / (jma^2);
		% if(alpha_A<2)
			Theta_list = ( vv(JMA(:,1))+vv(JMA(:,2)) )/(m-1);
			var_source_A2 = rho_ahat ^(-2*s) * sum( A_list_12.*(Theta_list.^2) ) / (jma^2) * m^(max(alpha_A-2,0));
		% else
		% 	var_source_A2 = rho_ahat ^(-2*s) * sum(sum(  (vv*ones(1,m)+ones(m,1)*vv')/(m-1) .* A  )) / (m*(m-1));
		% end

		var_source_A3 = rho_ahat ^(-2*s) * u_mhat / jma;


		% Compute point estimator and variance estimator for data B
		% idx_list_B_12 = sub2ind(size(B),JNB(:,1),JNB(:,2));
		% idx_list_B_23 = sub2ind(size(B),JNB(:,2),JNB(:,3));
		% idx_list_B_31 = sub2ind(size(B),JNB(:,3),JNB(:,1));
		idx_list_B_12 = JNB(:,1)+(JNB(:,2)-1)*n;
		idx_list_B_23 = JNB(:,2)+(JNB(:,3)-1)*n;
		idx_list_B_31 = JNB(:,3)+(JNB(:,1)-1)*n;
		B_list_12 = B(idx_list_B_12);
		B_list_23 = B(idx_list_B_23);
		B_list_31 = B(idx_list_B_31);
		gb_list_1 = B_list_12.*B_list_23 + B_list_23.*B_list_31 + B_list_31.*B_list_12;
		% gb_list_2 = B_list_23.*B_list_31;
		% gb_list_3 = B_list_31.*B_list_12;
		v_nhat    = mean(gb_list_1);
		rho_bhat  = mean([B_list_12;B_list_23;B_list_31]);
		% gb_list   = accumarray([JNB(:,1);JNB(:,2);JNB(:,3)], [gb_list_1;gb_list_2;gb_list_3], [n,1], @mean, 0)*3;
		% ub = [JNB(:,1)];  ub_freq = histcounts(ub, 0.5:1:(n+0.5));  ub_freq = ub_freq(:)+1e-10;
		% gb_list   = accumarray([JNB(:,1)], [gb_list_1], [n,1])./ub_freq;
		% grhob_list= accumarray([JNB(:,1)], [B_list_12], [n,1])./ub_freq;
		B_sq = B*B/(n-1);  B_sq = B_sq - diag(diag(B_sq));
		vv = sum(B,2);
		y  = (vv.*(vv-1)/2 + sum(B_sq,2)) / ((n-1)*(n-2)/2);
		x  = mean(y);
		gb_list  = y - x;
		grhob_list = vv/(n-1);

		b1 = r*rho_bhat ^(-s).*(gb_list - mean(gb_list)) -2*s*rho_bhat ^(-s-1)*v_nhat.*(grhob_list - mean(grhob_list));
		var_source_B1 = mean(b1.^2)/n;



		coef_list_B_12 = B_list_23+B_list_31;
		coef_list_B_23 = B_list_31+B_list_12;
		coef_list_B_31 = B_list_12+B_list_23;
		LL = [[JNB(:,1:2)]];
		% swapIndices = LL(:,1) > LL(:,2);
		% LL(swapIndices, :) = LL(swapIndices, [2, 1]);
		% coef_list_B = accumarray(sub2ind(size(B),LL(:,1),LL(:,2)), [coef_list_B_12;coef_list_B_23;coef_list_B_31], [n^2,1], @sum,0);
		% coef_list_B = reshape(coef_list_B,[n,n]);
		% coef_list_B = accumarray(LL(:,1)+(LL(:,2)-1)*n, [coef_list_B_12], [n^2,1]);
		% coef_list_B = reshape(coef_list_B,[n,n]);
		% coef_list_B = (coef_list_B + coef_list_B')/sqrt(2);
		% var_source_B2 = rho_bhat ^(-2*s) * sum(sum( (coef_list_B.^2).*B )) / (jnb^2);
		% if(alpha_B<2)
			Theta_list = ( vv(JNB(:,1))+vv(JNB(:,2)) )/(n-1);
			var_source_B2 = rho_bhat ^(-2*s) * sum( B_list_12.*(Theta_list.^2) ) / (jnb^2) * n^(max(alpha_B-2,0));
		% else
		% 	var_source_B2 = rho_bhat ^(-2*s) * sum(sum(  (vv*ones(1,n)+ones(n,1)*vv')/(n-1) .* B  )) / (n*(n-1));
		% end

		var_source_B3 = rho_bhat ^(-2*s) * v_nhat / jnb;


	end


	% var_overall = var_source_A1+var_source_A2+var_source_A3 + var_source_B1+var_source_B2+var_source_B3;

	output = [	rho_ahat^(-s)*u_mhat, rho_bhat^(-s)*v_nhat, ...
				var_source_A1+var_source_A2+var_source_A3 + var_source_B1+var_source_B2+var_source_B3, ...
				var_source_A1, var_source_A2, var_source_A3, var_source_B1, var_source_B2, var_source_B3];

end