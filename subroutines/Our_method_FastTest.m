function [p_value, conf_int] = Our_method_FastTest(FileName1, FileName2, conf_level)
	% Higher-order accurate two-sample test for network comparison
	% This is the fast version of the method based on network summary statistics, produced by the hashing step
	% As a prerequisite, must run Our_method_NetHashing.m to output the hashing files for the networks before running this
	% Input list: 
	% 	FileName1, FileName2: two files containing the hashing (summary statistics) for the two networks to be compared
	% 	conf_level: confidence level
	% Output list:
	%	p_value: p-value
	%	conf_int: vector, lower and upper bounds of CI

	if(~exist('conf_level', 'var'))
		conf_level = 0.90;
	end

	StdNormal = makedist('normal', 'mu', 0, 'sigma', 1);

	load(FileName1);  NetStatList1 = NetStatList;
	load(FileName2);  NetStatList2 = NetStatList;

	% Read in list of motifs whose summary statistics have been recorded
	mList = length(NetStatList1);
	nList = length(NetStatList2);

	MotifNameList = {};

	nameList1 = {};  nameList2 = {};
	for(ml = 1:mList);  nameList1{ml} = NetStatList1{ml}.MotifName;  end;
	for(nl = 1:nList);  nameList2{nl} = NetStatList2{nl}.MotifName;  end;

	p_value = [];
	conf_int = [];
	count_index = 1;
	cdelta = 0.01;

	% for-loop over each motif
	for(ml = 1:mList)

		nl = (1:nList)*(contains(nameList2, nameList1{ml}))';
		if(nl == 0);  continue;  end;
		temp1 = NetStatList1{ml};
		temp2 = NetStatList2{nl};
		
		MotifName = temp1.MotifName;
		switch MotifName
			case 'Triangle'
				r = 3;  s = 3;
			case 'Vshape'
				r = 3;  s = 2;
			case 'ThreeStar'
				r = 4;  s = 3;
		end
		m = temp1.m;
		n = temp2.m;
		rho_A = temp1.rho_A;
		rho_B = temp2.rho_A;
		U = temp1.U;
		V = temp2.U;
		
		%%%%%%%%%%%%%%%%%%%%
		%%%%%%%%%%%%%%%%%%%%
		
		smn = sqrt(temp1.aa11/m + temp2.aa11/n);
		
		I_0 = ...
			smn^(-1)*(temp1.a0/m - temp2.a0/n);
		
		Q1 = ...
			1/2 * smn^(-3) *...
	        (-m^(-2)*temp1.aa41- ...
	                m^(-2)*temp1.aa13+n^(-2)*temp2.aa13+ ...
	                n^(-2)*temp2.aa41);
		Q2 = ...
			smn^(-3)*...
				(...
					m^(-2)*( temp1.aaa111/6 + temp1.aaa112 )...
					-n^(-2)*( temp2.aaa111/6 + temp2.aaa112 )...
				)...
			+ 1/2 * smn^(-5)*...
				(...
					(-m^(-3)*temp1.aa11 - m^(-2)*n^(-1)*temp2.aa11)*...
					( temp1.aa13 + temp1.aa41 )...
					+ (m^(-1)*n^(-2)*temp1.aa11 + n^(-3)*temp2.aa11)*...
					( temp2.aa13 + temp2.aa41 )...
				);
		smooth = randn(1)*sqrt(cdelta*(log(m)*m^(-1/2)+log(n)*n^(-1/2)));
		T_hat = (rho_A^(-s)*U - rho_B^(-s)*V)/smn+smooth;
		
		% compute CDF value
		GT = cdf(StdNormal, T_hat) - pdf(StdNormal, T_hat) * ( Q1 + Q2*((T_hat).^2 - 1)+I_0 );
		
		GT = max([min([GT,1]),0]);
		
		%%%%%%%%%%%%%%%%%%
		
		p_value(count_index) = 2*min(GT, 1-GT);
		
		alpha = conf_level;
	        D_mn = rho_A^(-s)*U - rho_B^(-s)*V;
	        q_l = norminv(1-alpha/2) + I_0 +Q1+Q2*(norminv(1-alpha/2)^2-1 );
	        q_u = norminv(alpha/2) + I_0 +Q1+Q2*(norminv(alpha/2)^2-1);
	        d_l = D_mn - smn*(q_l-smooth);;
	        d_u =  D_mn -smn*(q_u-smooth);
		
		conf_int(count_index,:) = [d_l,d_u];
		
		count_index = count_index + 1;
		
	end

end