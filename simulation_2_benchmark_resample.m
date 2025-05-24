addpath('subroutines')

% Preamble: set network sizes, motif types and folder for temporary I/O files.
rng(1)
example = "SmoothGraphon1";
Files = dir(strcat("./results/data_simulation_",string(n)));
isdir = [Files.isdir];
indexf = isdir ==0;
Filesf = Files(indexf);
Nameallf = contains({Filesf.name},example);
Truthind = Nameallf';
total_database = length(Filesf);
MotifNameall   = {'Triangle','Vshape'};
total_query= 30;
elapsedTime = zeros(total_query,1);
auc_r = zeros(total_query,1);
rec = zeros(total_database,2);
r = 3;
booted = 200;
cdelta = 0.01;
for rndind = 1:total_query
    filesquery = strcat("./results/example_",string(n),'/',example,'_',string(rndind));
    load(filesquery);
    queryad = A;
    p_all = zeros(total_database,size(MotifNameall,2));
    tic;
    for i = 1:total_database
        for t = 1:size(MotifNameall,2)
            % generate data
            MotifName = MotifNameall{t};
            switch MotifName
                case 'Vshape'
                    s = 2;
                case 'Triangle'
                    s = 3;
            end
            load(strcat(Filesf(i).folder,'/',Filesf(i).name));
            datafind = A;
            A = queryad;
            B = datafind;
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
            smooth = randn(1)*sqrt(cdelta*(log(m)*m^(-1/2)+log(n)*n^(-1/2)));
            D_mn = rho_ahat ^(-s)*u_mhat - rho_bhat ^(-s)*v_nhat;
            T_hat = D_mn/s_mn+smooth;
            for q = 1:booted
                smoothindex = randn(1)*sqrt(cdelta*(log(m)*m^(-1/2)+log(n)*n^(-1/2)));
                indexa = datasample(1:m,m,'Replace',true);
                indexb = datasample(1:n,n,'Replace',true);
                A_new = queryad(indexa,indexa);
                B_new = datafind(indexb,indexb);
                % calculating t statistics
                rho_ahat = sum(A_new (:))/(m*(m-1));
                rho_bhat = sum(B_new (:))/(n*(n-1));
                u_mhat = Motif(A_new , 0, MotifName);
                v_nhat = Motif(B_new , 0, MotifName);
                g_ahat = Motif(A_new , 1, MotifName);
                g_bhat = Motif(B_new , 1, MotifName);
                g_rhoa_h = Motif(A_new , 1, 'Edge');
                g_rhob_h = Motif(B_new , 1, 'Edge');
                a1 = r*rho_ahat ^(-s).*g_ahat -2*s*rho_ahat ^(-s-1)*u_mhat.*g_rhoa_h;
                b1 = r*rho_bhat ^(-s).*g_bhat -2*s*rho_bhat ^(-s-1)*v_nhat.*g_rhob_h;
                s_mn2 = 1/m^2*sum(a1.^2)+1/n^2*sum(b1.^2);
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
            p_all(i,t) =  pvalue;
        end
    end
    minmaxp = min(p_all,[],2);
	psort = sort(minmaxp);
    elapsedTime(rndind,1) = toc;
    [x1,y1,T,AUC] = perfcurve(Truthind,minmaxp,1);
    auc_r(rndind,1) = AUC;
end
    
% output
rec(:,1) = minmaxp;
rec(:,2) = Truthind;
writematrix(rec,strcat("./results/minpv_truth_nores_",example,string(n),".csv"));
writematrix(elapsedTime,strcat("./results/querytime_pval_nores_",example,string(n),".csv"));
writematrix(auc_r,strcat("./results/auc_pval_nores_",example,string(n),".csv"));





