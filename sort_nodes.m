function [Sorted_mat_list, ordered_indexes] = sort_nodes(Input_mat_list, in_whose_order)
	
	%% Input_mat_list should look like {A_1,A_2,A_3,...,A_{N_nets}}, where each A_k is an n by n matrix.  All matrices should be in the same dimensions.
	%% in_whose_order is an index within 1,...,N_nets and a coefficient like [k,0.5];
	%% output: this function will output a sorted version of {A_1,A_2,A_3,...,A_{N_nets}}, where all matrices have rows/columns sorted according to the estimated row/column order of the elemenet matrix Input_mat_list{in_whose_order}
	
	if(~exist('in_whose_order','var'))
		in_whose_order = 1;
	end
	
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
	
	ordered_indexes = [1];
	unordered_indexes = [0,ones(1,n-1)];
	for(iii = 2:n)
		D_slice = D(ordered_indexes(length(ordered_indexes)),:);
		D_slice = D_slice + (1-unordered_indexes)*D_MAX;
		[~,next_node] = min(D_slice);
		ordered_indexes(iii) = next_node;
		unordered_indexes(next_node) = 0;
	end
	
	Sorted_mat_list = {};
	for(NN = 1:N_nets)
		AA = Input_mat_list{NN};
		Sorted_mat_list{NN} = AA(ordered_indexes,ordered_indexes);
	end
	
end