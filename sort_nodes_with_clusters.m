function [Sorted_mat_list, ordered_indexes] = sort_nodes_with_clusters(Input_mat_list, in_whose_order, cluster_structure)
	
	%% Input_mat_list should look like {A_1,A_2,A_3,...,A_{N_nets}}, where each A_k is an n by n matrix.  All matrices should be in the same dimensions.
	%% in_whose_order is an index within 1,...,N_nets and a coefficient like [k,0.5];
	%% cluster_structure should look like the output of a kmeans, like [1,3,2,3,1,3,2,3]...
	%% output: this function will output a sorted version of {A_1,A_2,A_3,...,A_{N_nets}}, where all matrices have rows/columns sorted according to the estimated row/column order of the elemenet matrix Input_mat_list{in_whose_order}
	
	if(~exist('in_whose_order','var'))
		in_whose_order = 1;
	end
	
	if(length(cluster_structure)~=size(Input_mat_list{1}))
		error('incorrect cluster length\n')
	end
	cluster_name_list = unique(cluster_structure);
	K = length(cluster_name_list);
	
	N_nets = length(Input_mat_list);
	n = size(Input_mat_list{1},1);
	% check size uniformity
	for(NN = 1:N_nets)
		if ( size(Input_mat_list{NN},1)~=n | size(Input_mat_list{NN},2)~=n )
			error('matrices in different sizes!\n');
		end
	end
	
	A_sq = zeros(n,n);
	D = zeros(n, n);
	for(iwo = 1:length(in_whose_order))
		tmp = in_whose_order{iwo};
		A0 = Input_mat_list{tmp(1)};
		A0 = A0 / mean(abs(A0(:)));
		A_sq = A_sq + tmp(2)*A0*A0/n;
	end
	for i = 1:n
		for j = i:n
			if(j>i)
				D(i, j) = max( abs(A_sq(i, :) - A_sq(j, :)) ); 
				D(j, i) = D(i, j);
			end
		end
	end
	D_MAX = max(D(:))+100;
	D = D + D_MAX*eye(n);

	
	ordered_indexes = zeros(1,n);
	for(k = 1:K)
		cluster_members = find(cluster_structure==k);
		nk = length(cluster_members);
		ordered_indexes_internal = [1];
		unordered_indexes_internal = [0,ones(1,nk-1)];
		for(iiii = 2:nk)
			D_slice = D(cluster_members(ordered_indexes_internal(length(ordered_indexes_internal))),cluster_members);
			D_slice = D_slice + (1-unordered_indexes_internal)*D_MAX;
			[~,next_node] = min(D_slice);
			ordered_indexes_internal(iiii) = next_node;
			unordered_indexes_internal(next_node) = 0;
		end
		ordered_indexes(cluster_members) = cluster_members(ordered_indexes_internal);
	end
	
	
	Sorted_mat_list = {};
	for(NN = 1:N_nets)
		AA = Input_mat_list{NN};
		Sorted_mat_list{NN} = AA(ordered_indexes,ordered_indexes);
	end
	
end