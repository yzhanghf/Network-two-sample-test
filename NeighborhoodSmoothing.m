function [W_hat] = NeighborhoodSmoothing(A)
	% INPUT:
	% A: adjacency matrix
	% OUTPUT:
	% W_hat: estimated probaility matrix

	N = size(A, 1);
	h = sqrt(log(N)/N);
	
	% Compute disimilarity measures
	D = zeros(N, N);
	A_sq = A*A/N;
	for i = 1:N
		for j = i:N
			if(j>i)
				D(i, j) = max( abs(A_sq(i, :) - A_sq(j, :)) ); 
				D(j, i) = D(i, j);
			end
		end
	end
	
	for i = 1:N
		Kernel_mat(i, :) =  (D(i, :) < quantile(D(i, :), h));
	end
	
	Kernel_mat = Kernel_mat ./ (sum(Kernel_mat, 2)*ones(1, N) + 1e-10);  % Each row has been normalized(under L1)
	
	W_hat = Kernel_mat * A;
	W_hat = (W_hat + W_hat') / 2;
	
end