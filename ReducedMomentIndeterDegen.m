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
	JMA_plus = [];
	JMA_minus = [];
	jmaa = ceil(m^(alpha_A-1))*10;

	column_1 = repelem(1:m, jmaa)';
	column_diff = repmat((1:jmaa)', m, 1) * floor(sqrt(m));
	JMA_plus  = [column_1, column_1+column_diff, column_1+2*column_diff];
	JMA_minus = [column_1, column_1-column_diff, column_1-2*column_diff];
	JMA_plus  = mod(JMA_plus-1, m) + 1;
	JMA_minus = mod(JMA_minus-1, m) + 1;
	% jma = m*ceil(m^(alpha_A-1));



	jnb = floor(n^alpha_B);
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
	JNB_plus = [];
	JNB_minus = [];
	jnbb = ceil(n^(alpha_B-1))*10;
	
	column_1 = repelem(1:n, jnbb)';
	column_diff = repmat((1:jnbb)', n, 1) * floor(sqrt(n));
	JNB_plus  = [column_1, column_1+column_diff, column_1+2*column_diff];
	JNB_minus = [column_1, column_1-column_diff, column_1-2*column_diff];
	JNB_plus  = mod(JNB_plus-1, n)  + 1;
	JNB_minus = mod(JNB_minus-1, n) + 1;
	% jnb = n*ceil(n^(alpha_B-1));


	% Compute statistics for output
	switch MotifName
	case 'Triangle'

		% Compute point estimator and variance estimator for data A

		% Variance Part I
		idx_list_A_12_plus  = JMA_plus(:,1) +(JMA_plus(:,2)-1)*m;
		idx_list_A_23_plus  = JMA_plus(:,2) +(JMA_plus(:,3)-1)*m;
		idx_list_A_31_plus  = JMA_plus(:,3) +(JMA_plus(:,1)-1)*m;
		idx_list_A_12_minus = JMA_minus(:,1)+(JMA_minus(:,2)-1)*m;
		idx_list_A_23_minus = JMA_minus(:,2)+(JMA_minus(:,3)-1)*m;
		idx_list_A_31_minus = JMA_minus(:,3)+(JMA_minus(:,1)-1)*m;

		A_list_12_plus = A(idx_list_A_12_plus);
		A_list_23_plus = A(idx_list_A_23_plus);
		A_list_31_plus = A(idx_list_A_31_plus);
		ga_list_1_plus = A_list_12_plus.*A_list_23_plus.*A_list_31_plus;
		grhoa_list_plus = A_list_12_plus;
		A_list_12_minus = A(idx_list_A_12_minus);
		A_list_23_minus = A(idx_list_A_23_minus);
		A_list_31_minus = A(idx_list_A_31_minus);
		ga_list_1_minus = A_list_12_minus.*A_list_23_minus.*A_list_31_minus;
		grhoa_list_minus = A_list_12_minus;

		idx_list_A_12 = JMA(:,1)+(JMA(:,2)-1)*m;
		idx_list_A_23 = JMA(:,2)+(JMA(:,3)-1)*m;
		idx_list_A_31 = JMA(:,3)+(JMA(:,1)-1)*m;
		A_list_12 = A(idx_list_A_12);
		A_list_23 = A(idx_list_A_23);
		A_list_31 = A(idx_list_A_31);
		ga_list_1 = A_list_12.*A_list_23.*A_list_31;

		u_mhat    = mean(ga_list_1);
		rho_ahat  = (mean([A_list_12])+mean([A_list_23])+mean([A_list_31]))/3;
		% A_sq = A*A/(m-1);
		% A_3 = A*A_sq/(m-2);
		% ga_list = diag(A_3);
		% grhoa_list= sum(A,2)/(m-1);
		% for iii = 1:m
		% 	ga_list(iii) = mean([ga_list_1(JMA(:,1)==iii);ga_list_1(JMA(:,2)==iii);ga_list_1(JMA(:,3)==iii)], "omitnan") - u_mhat;
		% 	% grhoa_list(iii) = mean([A_list_12(JMA(:,1)==iii);A_list_23(JMA(:,2)==iii);A_list_23(JMA(:,3)==iii)], "omitnan") - rho_ahat;
		% end

		% a1 = r*rho_ahat ^(-s).*(ga_list-mean(ga_list)) - 2*s*rho_ahat ^(-s-1)*u_mhat.*(grhoa_list-mean(grhoa_list));
		% var_source_A1 = mean(a1.^2)/m;
		ga_list_1_plus  = mean( reshape(ga_list_1_plus,  jmaa, []), 1 )';
		ga_list_1_minus = mean( reshape(ga_list_1_minus, jmaa, []), 1 )';
		grhoa_list_plus  = mean( reshape(grhoa_list_plus,   jmaa, []), 1 )';
		grhoa_list_minus = mean( reshape(grhoa_list_minus,  jmaa, []), 1 )';
		a1_sq = (r*rho_ahat^(-s) * (ga_list_1_plus  - mean(ga_list_1_plus))  - 2*s*rho_ahat^(-s-1)*u_mhat * (grhoa_list_plus  - mean(grhoa_list_plus ))) ...
			.*  (r*rho_ahat^(-s) * (ga_list_1_minus - mean(ga_list_1_minus)) - 2*s*rho_ahat^(-s-1)*u_mhat * (grhoa_list_minus - mean(grhoa_list_minus)));
		var_source_A1 = mean(a1_sq)/m;
		var_source_A1 = max(var_source_A1,1e-10);

		% Variance Part II
		% if(alpha_A<=2)
			var_source_A2 = 0;
		% else
		% 	Theta_list = A_sq(JMA(:,1)+(JMA(:,2)-1)*m) / (rho_ahat^s*jma) - s/(rho_ahat*jma);
		% 	var_source_A2 =  sum( A_list_12.*(Theta_list.^2) );
		% end

		% Variance Part III
		var_source_A3 = rho_ahat ^(-2*s) * u_mhat / jma;





		% Compute point estimator and variance estimator for data B

		% Variance Part I
		idx_list_B_12_plus = JNB_plus(:,1)+(JNB_plus(:,2)-1)*n;
		idx_list_B_23_plus = JNB_plus(:,2)+(JNB_plus(:,3)-1)*n;
		idx_list_B_31_plus = JNB_plus(:,3)+(JNB_plus(:,1)-1)*n;
		idx_list_B_12_minus = JNB_minus(:,1)+(JNB_minus(:,2)-1)*n;
		idx_list_B_23_minus = JNB_minus(:,2)+(JNB_minus(:,3)-1)*n;
		idx_list_B_31_minus = JNB_minus(:,3)+(JNB_minus(:,1)-1)*n;

		B_list_12_plus = B(idx_list_B_12_plus);
		B_list_23_plus = B(idx_list_B_23_plus);
		B_list_31_plus = B(idx_list_B_31_plus);
		gb_list_1_plus = B_list_12_plus.*B_list_23_plus.*B_list_31_plus;
		grhob_list_plus = B_list_12_plus;
		B_list_12_minus = B(idx_list_B_12_minus);
		B_list_23_minus = B(idx_list_B_23_minus);
		B_list_31_minus = B(idx_list_B_31_minus);
		gb_list_1_minus = B_list_12_minus.*B_list_23_minus.*B_list_31_minus;
		grhob_list_minus = B_list_12_minus;


		idx_list_B_12 = JNB(:,1)+(JNB(:,2)-1)*n;
		idx_list_B_23 = JNB(:,2)+(JNB(:,3)-1)*n;
		idx_list_B_31 = JNB(:,3)+(JNB(:,1)-1)*n;
		B_list_12 = B(idx_list_B_12);
		B_list_23 = B(idx_list_B_23);
		B_list_31 = B(idx_list_B_31);
		gb_list_1 = B_list_12.*B_list_23.*B_list_31;

		v_nhat    = mean(gb_list_1);
		rho_bhat  = (mean([B_list_12])+mean([B_list_23])+mean([B_list_31]))/3;
		% B_sq = B*B/(n-1);
		% B_3 = B*B_sq/(n-2);
		% gb_list = diag(B_3);
		% grhob_list= sum(B,2)/(n-1);
		% for jjj = 1:n
		% 	gb_list(jjj) = mean([gb_list_1(JNB(:,1)==jjj);gb_list_1(JNB(:,2)==jjj);gb_list_1(JNB(:,3)==jjj)], "omitnan") - v_nhat;
		% 	% grhob_list(jjj) = mean([B_list_12(JNB(:,1)==jjj);B_list_23(JNB(:,2)==jjj);B_list_23(JNB(:,2)==jjj)], "omitnan") - rho_bhat;
		% end

		% b1 = r*rho_bhat ^(-s).*(gb_list-mean(gb_list)) -2*s*rho_bhat ^(-s-1)*v_nhat.*(grhob_list-mean(grhob_list));
		% var_source_B1 = mean(b1.^2)/n;
		gb_list_1_plus  = mean( reshape(gb_list_1_plus,  jnbb, []), 1 )';
		gb_list_1_minus = mean( reshape(gb_list_1_minus, jnbb, []), 1 )';
		grhob_list_plus  = mean( reshape(grhob_list_plus,   jnbb, []), 1 )';
		grhob_list_minus = mean( reshape(grhob_list_minus,  jnbb, []), 1 )';
		b1_sq = (r*rho_bhat^(-s) * (gb_list_1_plus  - mean(gb_list_1_plus))  - 2*s*rho_bhat^(-s-1)*v_nhat * (grhob_list_plus  - mean(grhob_list_plus))) ...
			.*  (r*rho_bhat^(-s) * (gb_list_1_minus - mean(gb_list_1_minus)) - 2*s*rho_bhat^(-s-1)*v_nhat * (grhob_list_minus - mean(grhob_list_minus)));
		var_source_B1 = mean(b1_sq)/n;
		var_source_B1 = max(var_source_B1,1e-10);

		% Variance Part II
		% if(alpha_B<=2)
			var_source_B2 = 0;
		% else
		% 	Theta_list = B_sq(JNB(:,1)+(JNB(:,2)-1)*n) / (rho_bhat^s*jnb) - s/(rho_bhat*jnb);
		% 	var_source_B2 =  sum( B_list_12.*(Theta_list.^2) );
		% end

		% Variance Part III
		var_source_B3 = rho_bhat ^(-2*s) * v_nhat / jnb;











	case 'Vshape'

		% Compute point estimator and variance estimator for data A

		% Compute point estimator and variance estimator for data A

		% Variance Part I
		idx_list_A_12_plus = JMA_plus(:,1)+(JMA_plus(:,2)-1)*m;
		idx_list_A_23_plus = JMA_plus(:,2)+(JMA_plus(:,3)-1)*m;
		idx_list_A_31_plus = JMA_plus(:,3)+(JMA_plus(:,1)-1)*m;
		idx_list_A_12_minus = JMA_minus(:,1)+(JMA_minus(:,2)-1)*m;
		idx_list_A_23_minus = JMA_minus(:,2)+(JMA_minus(:,3)-1)*m;
		idx_list_A_31_minus = JMA_minus(:,3)+(JMA_minus(:,1)-1)*m;

		A_list_12_plus = A(idx_list_A_12_plus);
		A_list_23_plus = A(idx_list_A_23_plus);
		A_list_31_plus = A(idx_list_A_31_plus);
		ga_list_1_plus = A_list_12_plus.*A_list_23_plus + A_list_23_plus.*A_list_31_plus + A_list_31_plus.*A_list_12_plus;
		grhoa_list_plus = A_list_12_plus;
		A_list_12_minus = A(idx_list_A_12_minus);
		A_list_23_minus = A(idx_list_A_23_minus);
		A_list_31_minus = A(idx_list_A_31_minus);
		ga_list_1_minus = A_list_12_minus.*A_list_23_minus + A_list_23_minus.*A_list_31_minus + A_list_31_minus.*A_list_12_minus;
		grhoa_list_minus = A_list_12_minus;


		idx_list_A_12 = JMA(:,1)+(JMA(:,2)-1)*m;
		idx_list_A_23 = JMA(:,2)+(JMA(:,3)-1)*m;
		idx_list_A_31 = JMA(:,3)+(JMA(:,1)-1)*m;
		A_list_12 = A(idx_list_A_12);
		A_list_23 = A(idx_list_A_23);
		A_list_31 = A(idx_list_A_31);
		ga_list_1 = A_list_12.*A_list_23.*A_list_31;

		u_mhat    = mean(ga_list_1);
		rho_ahat  = (mean([A_list_12])+mean([A_list_23])+mean([A_list_31]))/3;
		% A_sq = A*A/(m-1);
		% A_3 = A*A_sq/(m-2);
		% ga_list = diag(A_3);
		% grhoa_list= sum(A,2)/(m-1);
		% for iii = 1:m
		% 	ga_list(iii) = mean([ga_list_1(JMA(:,1)==iii);ga_list_1(JMA(:,2)==iii);ga_list_1(JMA(:,3)==iii)], "omitnan") - u_mhat;
		% 	% grhoa_list(iii) = mean([A_list_12(JMA(:,1)==iii);A_list_23(JMA(:,2)==iii);A_list_23(JMA(:,3)==iii)], "omitnan") - rho_ahat;
		% end

		% a1 = r*rho_ahat ^(-s).*(ga_list-mean(ga_list)) - 2*s*rho_ahat ^(-s-1)*u_mhat.*(grhoa_list-mean(grhoa_list));
		% var_source_A1 = mean(a1.^2)/m;
		ga_list_1_plus  = mean( reshape(ga_list_1_plus,  jmaa, []), 1 )';
		ga_list_1_minus = mean( reshape(ga_list_1_minus, jmaa, []), 1 )';
		grhoa_list_plus  = mean( reshape(grhoa_list_plus,   jmaa, []), 1 )';
		grhoa_list_minus = mean( reshape(grhoa_list_minus,  jmaa, []), 1 )';
		a1_sq = (r*rho_ahat^(-s) * (ga_list_1_plus - mean(ga_list_1_plus)) - 2*s*rho_ahat^(-s-1)*u_mhat * (grhoa_list_plus - mean(grhoa_list_plus))) ...
			.*  (r*rho_ahat^(-s) * (ga_list_1_minus - mean(ga_list_1_minus)) - 2*s*rho_ahat^(-s-1)*u_mhat * (grhoa_list_minus - mean(grhoa_list_minus)));
		var_source_A1 = mean(a1_sq)/m;
		var_source_A1 = max(var_source_A1,1e-10);

		% Variance Part II
		% if(alpha_A<=2)
			var_source_A2 = 0;
		% else
		% 	Theta_list = A_sq(JMA(:,1)+(JMA(:,2)-1)*m) / (rho_ahat^s*jma) - s/(rho_ahat*jma);
		% 	var_source_A2 =  sum( A_list_12.*(Theta_list.^2) );
		% end

		% Variance Part III
		var_source_A3 = rho_ahat ^(-2*s) * u_mhat / jma;
		


		% Compute point estimator and variance estimator for data B

		% Variance Part I
		idx_list_B_12_plus = JNB_plus(:,1)+(JNB_plus(:,2)-1)*n;
		idx_list_B_23_plus = JNB_plus(:,2)+(JNB_plus(:,3)-1)*n;
		idx_list_B_31_plus = JNB_plus(:,3)+(JNB_plus(:,1)-1)*n;
		idx_list_B_12_minus = JNB_minus(:,1)+(JNB_minus(:,2)-1)*n;
		idx_list_B_23_minus = JNB_minus(:,2)+(JNB_minus(:,3)-1)*n;
		idx_list_B_31_minus = JNB_minus(:,3)+(JNB_minus(:,1)-1)*n;

		B_list_12_plus = B(idx_list_B_12_plus);
		B_list_23_plus = B(idx_list_B_23_plus);
		B_list_31_plus = B(idx_list_B_31_plus);
		gb_list_1_plus = B_list_12_plus.*B_list_23_plus + B_list_23_plus.*B_list_31_plus + B_list_31_plus.*B_list_12_plus;
		grhob_list_plus = B_list_12_plus;
		B_list_12_minus = B(idx_list_B_12_minus);
		B_list_23_minus = B(idx_list_B_23_minus);
		B_list_31_minus = B(idx_list_B_31_minus);
		gb_list_1_minus = B_list_12_minus.*B_list_23_minus + B_list_23_minus.*B_list_31_minus + B_list_31_minus.*B_list_12_minus;
		grhob_list_minus = B_list_12_minus;


		idx_list_B_12 = JNB(:,1)+(JNB(:,2)-1)*n;
		idx_list_B_23 = JNB(:,2)+(JNB(:,3)-1)*n;
		idx_list_B_31 = JNB(:,3)+(JNB(:,1)-1)*n;
		B_list_12 = B(idx_list_B_12);
		B_list_23 = B(idx_list_B_23);
		B_list_31 = B(idx_list_B_31);
		gb_list_1 = B_list_12.*B_list_23.*B_list_31;

		v_nhat    = mean(gb_list_1);
		rho_bhat  = (mean([B_list_12])+mean([B_list_23])+mean([B_list_31]))/3;
		% B_sq = B*B/(n-1);
		% B_3 = B*B_sq/(n-2);
		% gb_list = diag(B_3);
		% grhob_list= sum(B,2)/(n-1);
		% for jjj = 1:n
		% 	gb_list(jjj) = mean([gb_list_1(JNB(:,1)==jjj);gb_list_1(JNB(:,2)==jjj);gb_list_1(JNB(:,3)==jjj)], "omitnan") - v_nhat;
		% 	% grhob_list(jjj) = mean([B_list_12(JNB(:,1)==jjj);B_list_23(JNB(:,2)==jjj);B_list_23(JNB(:,2)==jjj)], "omitnan") - rho_bhat;
		% end

		% b1 = r*rho_bhat ^(-s).*(gb_list-mean(gb_list)) -2*s*rho_bhat ^(-s-1)*v_nhat.*(grhob_list-mean(grhob_list));
		% var_source_B1 = mean(b1.^2)/n;
		gb_list_1_plus  = mean( reshape(gb_list_1_plus,  jnbb, []), 1 )';
		gb_list_1_minus = mean( reshape(gb_list_1_minus, jnbb, []), 1 )';
		grhob_list_plus  = mean( reshape(grhob_list_plus,   jnbb, []), 1 )';
		grhob_list_minus = mean( reshape(grhob_list_minus,  jnbb, []), 1 )';
		b1_sq = (r*rho_bhat^(-s) * (gb_list_1_plus - mean(gb_list_1_plus)) - 2*s*rho_bhat^(-s-1)*v_nhat * (grhob_list_plus - mean(grhob_list_plus))) ...
			.*  (r*rho_bhat^(-s) * (gb_list_1_minus - mean(gb_list_1_minus)) - 2*s*rho_bhat^(-s-1)*v_nhat * (grhob_list_minus - mean(grhob_list_minus)));
		var_source_B1 = mean(b1_sq)/n;
		var_source_B1 = max(var_source_B1,1e-10);

		% Variance Part II
		% if(alpha_B<=2)
			var_source_B2 = 0;
		% else
		% 	Theta_list = B_sq(JNB(:,1)+(JNB(:,2)-1)*n) / (rho_bhat^s*jnb) - s/(rho_bhat*jnb);
		% 	var_source_B2 =  sum( B_list_12.*(Theta_list.^2) );
		% end

		% Variance Part III
		var_source_B3 = rho_bhat ^(-2*s) * v_nhat / jnb;




	end


	% var_overall = var_source_A1+var_source_A2+var_source_A3 + var_source_B1+var_source_B2+var_source_B3;

	output = [	rho_ahat^(-s)*u_mhat, rho_bhat^(-s)*v_nhat, ...
				var_source_A1+var_source_A2+var_source_A3 + var_source_B1+var_source_B2+var_source_B3, ...
				var_source_A1, var_source_A2, var_source_A3, var_source_B1, var_source_B2, var_source_B3];

end