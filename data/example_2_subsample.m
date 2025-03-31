
% PREAMBLE
MotifNameall = {'Triangle', 'Vshape'};
r = 3;
booted = 200;
cdelta = 0.01;
% READ IN DATA
load("Final_data_facsimile.mat");
l_NC = size(cor_NC_fisherZ_correct, 3);
l_SZ = size(cor_SZ_fisherZ_correct, 3);
m = size(cor_NC_fisherZ_correct, 1);


l_idx = size(idx_mat, 2);
idxList = {};
for(ii = 1:l_idx)
	idxList{ii} = find(idx_mat(:,ii)==1);
end

All_networks = cat(3, cor_SZ_fisherZ_correct, cor_NC_fisherZ_correct);
	% 1:103 = patients;
	% 104:227 (length:124) = healthy people;

%% total network set
tic;
l_all = size(All_networks, 3);
p_all_dist = zeros(l_all,l_all);
for ll1 = 1:l_all
    A = All_networks(:,:,ll1);
    for ll2 = 1:l_all 
        p_all = zeros(1,size(MotifNameall,2));
        B = All_networks(:,:,ll2);
        for t = 1:size(MotifNameall,2)
            MotifName = MotifNameall{t};
            switch MotifName
                case 'Vshape'
                    s = 2;
                case 'Triangle'
                    s = 3;
            end
            % calculating t statistics
            m = size(A,1);
            n = size(B,1);
            rho_ahat = sum(A (:))/(m*(m-1));
            rho_bhat = sum(B (:))/(n*(n-1));
            u_mhat = Motif(A, 0, MotifName);
            v_nhat = Motif(B , 0, MotifName);
            g_ahat = Motif(A , 1, MotifName);
            g_bhat = Motif(B , 1, MotifName);
            g_rhoa_h = Motif(A , 1, 'Edge');
            g_rhob_h = Motif(B , 1, 'Edge');
            a1 = r*rho_ahat ^(-s).*g_ahat -2*s*rho_ahat ^(-s-1)*u_mhat.*g_rhoa_h;
            b1 = r*rho_bhat ^(-s).*g_bhat -2*s*rho_bhat ^(-s-1)*v_nhat.*g_rhob_h;
            s_mn2 = 1/m^2*sum(a1.^2)+1/n^2*sum(b1.^2);
            s_mn = sqrt(s_mn2);
            D_mn = rho_ahat ^(-s)*u_mhat - rho_bhat ^(-s)*v_nhat;
            smooth = randn(1)*sqrt(cdelta*(log(m)*m^(-1/2)+log(n)*n^(-1/2)));
            T_hat = D_mn/s_mn+smooth;
            mboot = ceil(sqrt(m));
            nboot = ceil(sqrt(n));
            cdfboot = zeros(booted,1);
            for q = 1:booted
                smoothindex = randn(1)*sqrt(cdelta*(log(mboot)*mboot^(-1/2)+log(nboot)*nboot^(-1/2)));
                indexa = datasample(1:m,mboot,'Replace',false);
                indexb = datasample(1:n,nboot,'Replace',false);
                A_new = A(indexa,indexa);
                B_new = B(indexb,indexb);
                % calculating t statistics
                rho_ahat = sum(A_new (:))/(mboot*(mboot-1));
                rho_bhat = sum(B_new (:))/(nboot*(nboot-1));
                u_mhat = Motif(A_new , 0, MotifName);
                v_nhat = Motif(B_new , 0, MotifName);
                g_ahat = Motif(A_new , 1, MotifName);
                g_bhat = Motif(B_new , 1, MotifName);
                g_rhoa_h = Motif(A_new , 1, 'Edge');
                g_rhob_h = Motif(B_new , 1, 'Edge');
                a1 = r*rho_ahat ^(-s).*g_ahat -2*s*rho_ahat ^(-s-1)*u_mhat.*g_rhoa_h;
                b1 = r*rho_bhat ^(-s).*g_bhat -2*s*rho_bhat ^(-s-1)*v_nhat.*g_rhob_h;
                s_mn2 = 1/mboot^2*sum(a1.^2)+1/nboot^2*sum(b1.^2);
                s_mn_boot = sqrt(s_mn2);
                D_mn_boot = rho_ahat ^(-s)*u_mhat -rho_bhat ^(-s)*v_nhat;
                cdfboot(q,1) = (D_mn_boot-D_mn)/s_mn_boot+smoothindex;
            end
            cdfboot = cdfboot(cdfboot<10^5, :);
            cdfboot = cdfboot(cdfboot>-10^5, :);
            [f,X] = ecdf(cdfboot);
            X = X(2:end);     % Sample points, ECDF duplicates initial point, delete it
            f = f(2:end);     % Sample values, ECDF duplicates initial point, delete it
            boot_empri = interp1(X,f,T_hat ,'nearest'); % Nearest neighbor interpolation
            GT = max([min([boot_empri,1]),0]);
            pvalue =  2*min(GT, 1-GT);
            p_all(1,t) =  pvalue;

        end
        minmaxp = min(p_all);
        p_all_dist(ll1,ll2) = minmaxp;
    end
end
time_subsample = toc;
save("result_sz_subsample.mat","p_all_dist","time_subsample");












