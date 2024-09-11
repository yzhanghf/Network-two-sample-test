function [zzz] = Our_method_classic(A, B, MotifName, alpha)
	
	zzz = [];

	m = size(A,1);  n = size(B,1);
	switch(MotifName)
	case 'Triangle'
		r=3;s=3;
	case 'Vshape'
		r=3;s=2;
	end

	smooth=0;

	% first calculate all statistics needed from A
	rho_ahat = sum(A(:))/(m*(m-1));
	u_mhat = Motif(A, 0, MotifName);
	g_ahat = Motif(A, 1, MotifName);
	g_rhoa_h = Motif(A, 1, 'Edge');
	g_rhoa2_h = Motif(A, 2, 'Edge');
	a1 = r*rho_ahat ^(-s).*g_ahat -2*s*rho_ahat ^(-s-1)*u_mhat.*g_rhoa_h;
	ksei_a2 = sum(g_ahat.^2)/m;
	g_a2hat = Motif(A, 2, MotifName);
	g_a = g_ahat'*ones(1,m);
	g1g1g2_a = mean(mean(g_a2hat.*g_a.*g_a'));
	ksei_a_rhoa = 1/m*sum(g_ahat.*g_rhoa_h);
	ksei_rhoa2 = sum(g_rhoa_h.^2)/m;
	% calculating all a0-a4
	% compute a0 to a4
	a0 = 2*s*(s+1)*rho_ahat^(-s-2)*u_mhat*ksei_rhoa2-2*r*s*rho_ahat^(-s-1)*ksei_a_rhoa;
	a2 = r*(r-1)/2*rho_ahat^(-s).*g_a2hat ...
		- s*rho_ahat^(-s-1)*u_mhat.*g_rhoa2_h...
		+ 2*rho_ahat^(-s)*u_mhat*s*(s+1)*rho_ahat^(-2).*g_rhoa_h'*g_rhoa_h...
		-2*r*s*rho_ahat^(-s-1).*g_rhoa_h'*g_ahat;
	a3 = -4*r^2*s*rho_ahat^(-(2*s+1))*ksei_a2.*g_rhoa_h+r^2*rho_ahat^(-2*s)*(g_ahat.^2-ksei_a2)...
		-16*s^2*(s+1)*rho_ahat^(-(2*s+3))*u_mhat^2*ksei_rhoa2.*g_rhoa_h...
		+8*r*s^2*rho_ahat^(-(2*s+2))*u_mhat.*g_ahat*ksei_rhoa2...
		+4*s^2*rho_ahat^(-(2*s+2))*u_mhat^2.*(g_rhoa_h.^2-ksei_rhoa2)...
		-4*r*s*(-(4*s+2)*rho_ahat^(-(2*s+2)).*g_rhoa_h*u_mhat*ksei_a_rhoa + ...
			r*rho_ahat^(-(2*s+1)).*g_ahat*ksei_a_rhoa+rho_ahat^(-(2*s+1))*u_mhat.*(g_ahat.*g_rhoa_h-ksei_a_rhoa));
	a4 = 2*r^2*(r-1)*rho_ahat^(-2*s).*(g_ahat'*ones(1,m).*g_a2hat)...
		+8*s^2*rho_ahat^(-(2*s+2))*u_mhat^2.*(g_rhoa_h'*ones(1,m).*g_rhoa2_h)...
		-4*r*(r-1)*s*rho_ahat^(-(2*s+1))*u_mhat.*(g_rhoa_h'*ones(1,m).*g_a2hat)...
		-4*r*s*rho_ahat^(-(2*s+1))*u_mhat.*(g_ahat'*ones(1,m).*g_rhoa2_h);
	
	% calculating statistics needed from B
	rho_bhat = sum(B(:))/(n*(n-1));
	v_nhat = Motif(B, 0, MotifName);
	g_bhat = Motif(B, 1, MotifName);
	g_rhob_h = Motif(B, 1, 'Edge');
	g_rhob2_h = Motif(B, 2, 'Edge');
	b1 = r*rho_bhat ^(-s).*g_bhat -2*s*rho_bhat ^(-s-1)*v_nhat.*g_rhob_h;
	ksei_b2 = sum(g_bhat.^2)/n;
	g_b2hat = Motif(B, 2, MotifName);
	g_b = g_bhat'*ones(1,n);
	g1g1g2_b = mean(mean(g_b2hat.*g_b.*g_b'));
	ksei_b_rhob = 1/n*sum(g_bhat.*g_rhob_h);
	ksei_rhob2 = sum(g_rhob_h.^2)/n;
	
	% calculating b0-b4
	b0 = 2*s*(s+1)*rho_bhat^(-s-2)*v_nhat*ksei_rhob2-2*r*s*rho_bhat^(-s-1)*ksei_b_rhob;
	b2 = r*(r-1)/2*rho_bhat^(-s).*g_b2hat ...
		- s*rho_bhat^(-s-1)*v_nhat.*g_rhob2_h...
		+ 2*rho_bhat^(-s)*v_nhat*s*(s+1)*rho_bhat^(-2).*g_rhob_h'*g_rhob_h...
		-2*r*s*rho_bhat^(-s-1).*g_rhob_h'*g_bhat;
	b3 = -4*r^2*s*rho_bhat^(-(2*s+1))*ksei_b2.*g_rhob_h+r^2*rho_bhat^(-2*s)*(g_bhat.^2-ksei_b2)...
		-16*s^2*(s+1)*rho_bhat^(-(2*s+3))*v_nhat^2*ksei_rhob2.*g_rhob_h...
		+8*r*s^2*rho_bhat^(-(2*s+2))*v_nhat.*g_bhat*ksei_rhob2...
		+4*s^2*rho_bhat^(-(2*s+2))*v_nhat^2.*(g_rhob_h.^2-ksei_rhob2)...
		-4*r*s*(-(4*s+2)*rho_bhat^(-(2*s+2)).*g_rhob_h*v_nhat*ksei_b_rhob + ...
			r*rho_bhat^(-(2*s+1)).*g_bhat*ksei_b_rhob+rho_bhat^(-(2*s+1))*v_nhat.*(g_bhat.*g_rhob_h-ksei_b_rhob));
	b4 = 2*r^2*(r-1)*rho_bhat^(-2*s).*(g_bhat'*ones(1,n).*g_b2hat)...
		+8*s^2*rho_bhat^(-(2*s+2))*v_nhat^2.*(g_rhob_h'*ones(1,n).*g_rhob2_h)...
		-4*r*(r-1)*s*rho_bhat^(-(2*s+1))*v_nhat.*(g_rhob_h'*ones(1,n).*g_b2hat)...
		-4*r*s*rho_bhat^(-(2*s+1))*v_nhat.*(g_bhat'*ones(1,n).*g_rhob2_h);
	
	% calculating t ststistics and t hat
	s_mn2 = 1/m^2*sum(a1.^2)+1/n^2*sum(b1.^2);
	s_mn = sqrt(s_mn2);
	D_mn = rho_ahat ^(-s)*u_mhat - rho_bhat ^(-s)*v_nhat;
	t_mn = D_mn/s_mn;
	
	% calculating expectation 
	e_a4a1 = mean(mean(a4.*(a1'*ones(1,m))'));
	e_a1a3 = mean(a1.*a3);
	e_a3 = sum(a1.^3)/m;
	e_a1a1a2 = mean(mean(a2.*(a1'*ones(1,m)).*(a1'*ones(1,m))'));
	
	e_b4b1 = mean(mean(b4.*(b1'*ones(1,n))'));
	e_b1b3 = mean(b1.*b3);
	e_b3 = sum(b1.^3)/n;
	e_b1b1b2 = mean(mean(b2.*(b1'*ones(1,n)).*(b1'*ones(1,n))'));
	ksei_bl2 = mean(b1.^2);
	ksei_al2 = mean(a1.^2);
	
	% calculating I and qm,n    
	I0 = s_mn^(-1)*(1/m*a0 -1/n*b0);
	q1 = 1/2*s_mn^(-3)*(-m^(-2)*e_a4a1- ...
		m^(-2)*e_a1a3+n^(-2)*e_b1b3+ ...
		n^(-2)*e_b4b1);
	q2 = s_mn^(-3)*(m^(-2)*(1/6*e_a3+e_a1a1a2)-n^(-2)*(1/6*e_b3+e_b1b1b2))+...
		1/2*s_mn^(-5)*((-m^(-3)*ksei_al2 -m^(-2)*n^(-1)*ksei_bl2)*(e_a1a3 + e_a4a1)+...
			(m^(-1)*n^(-2)*ksei_al2+n^(-3)*ksei_bl2)*(e_b1b3+e_b4b1));


	q_l = norminv(1-alpha/2) + I0 +q1+q2*(norminv(1-alpha/2)^2-1 );
	q_u = norminv(alpha/2) + I0 +q1+q2*(norminv(alpha/2)^2-1);
	d_l = D_mn - s_mn*(q_l-smooth);
	d_u = D_mn - s_mn*(q_u-smooth);

	p_value_1 = normcdf(t_mn) - normpdf(t_mn)*(q1+q2*(t_mn^2+1)+I0);
	p_value_2 = 1 - p_value_1;

	zzz(1) = d_l;
	zzz(2) = d_u;
	zzz(3) = 2*min([ p_value_1, p_value_2 ]);
	zzz(4) = t_mn;
	zzz(5) = s_mn;
	zzz(6) = 1/m^2*sum(a1.^2);
	zzz(7) = 1/n^2*sum(b1.^2);

	
end