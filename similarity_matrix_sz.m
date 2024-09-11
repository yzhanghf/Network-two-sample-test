
% PREAMBLE
MotifNameList = {'Triangle', 'Vshape'};


% READ IN DATA
load('./data/TwoSampleNetwork/Final_data.mat');
l_NC = size(cor_NC_fisherZ_correct, 3);
l_SZ = size(cor_SZ_fisherZ_correct, 3);
m = size(cor_NC_fisherZ_correct, 1);


l_idx = size(idx_mat, 2);
idxList = {};
for(ii = 1:l_idx)
	idxList{ii} = find(idx_mat(:,ii)==1);
end

All_networks = cat(3, cor_SZ_fisherZ_correct, cor_NC_fisherZ_correct);
l_all = size(All_networks, 3);

mkdir(strcat("./hash_data_sz"));
%% total network set
l_all = size(All_networks, 3);
dir1 = strcat("./hash_data_sz/");
for ll = 1:l_all
	Net = All_networks(:,:,ll);
	Our_method_NetHashing(...
		Net,...
		MotifNameList,...
		strcat(dir1,sprintf('All_%d.mat', ll))...
		);
end
p_all = zeros(l_all,l_all);
pesti = zeros(l_all,l_all);
conf_level = 0.05;
for ll1 = 1:l_all
    for ll2 = 1:l_all 
        [p_value, conf_int] = Our_method_FastTest(strcat(dir1,sprintf('All_%d.mat', ll1)), strcat(dir1,sprintf('All_%d.mat', ll2)), conf_level);
        p_all(ll1,ll2) =  min(p_value);
        pesti(ll1,ll2) =  max(abs(mean(conf_int,2)));
    end
end
save('pvalue_allnet',"p_all");
save('confi2_allnet',"pesti");

