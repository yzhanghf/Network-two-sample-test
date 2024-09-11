
function z = graphon(x,y,sparsity_parameters,GraphonName)
	
	x = x(:);  y = y(:);
	
	n = length(x);
    rho = sparsity_parameters;


	switch GraphonName

	% case 'NewBlockModel1'

	% 	z = 


	case 'NewSmoothGraphon2'	
		XX = x*ones(1,n);  YY = ones(n,1)*y';
        z = (XX+YY).^2/4;

    case 'NewSmoothGraphon4'	
		XX = x*ones(1,n);  YY = ones(n,1)*y';
        % z = (exp(5*XX)+exp(5*YY))/exp(5)/2;
        z = (exp(3*XX)+exp(3*YY))/(2*exp(3));

    case 'NewBlockModel1'
    	BB = [	0.1, 0.1, 0.2; ...
    			0.1, 0.4, 0.1; ...
    			0.2, 0.1, 0.9  ];
    	z = 	BB(1,1) * (x-1/3<0) 				* (y'-1/3<0) ...
    		+	BB(1,2) * (x-1/3<0) 				* ((y'-1/3>0).*(y'-2/3<0)) ...
    		+	BB(1,3) * (x-1/3<0) 				* (y'-2/3>0) ...
    		+	BB(2,1) * ((x-1/3>0).*(x-2/3<0)) 	* (y'-1/3<0) ...
    		+	BB(2,2) * ((x-1/3>0).*(x-2/3<0)) 	* ((y'-1/3>0).*(y'-2/3<0)) ...
    		+	BB(2,3) * ((x-1/3>0).*(x-2/3<0)) 	* (y'-2/3>0) ...
    		+	BB(3,1) * (x-2/3>0) 				* (y'-1/3<0) ...
    		+	BB(3,2) * (x-2/3>0) 				* ((y'-1/3>0).*(y'-2/3<0)) ...
    		+	BB(3,3) * (x-2/3>0) 				* (y'-2/3>0);


    case 'NewBlockModel2'
    	BB = [	0.1, 0.7, 0.2; ...
    			0.7, 0.5, 0.6; ...
    			0.2, 0.6, 0.3  ];
    	z = 	BB(1,1) * (x-1/3<0) 				* (y'-1/3<0) ...
    		+	BB(1,2) * (x-1/3<0) 				* ((y'-1/3>0).*(y'-2/3<0)) ...
    		+	BB(1,3) * (x-1/3<0) 				* (y'-2/3>0) ...
    		+	BB(2,1) * ((x-1/3>0).*(x-2/3<0)) 	* (y'-1/3<0) ...
    		+	BB(2,2) * ((x-1/3>0).*(x-2/3<0)) 	* ((y'-1/3>0).*(y'-2/3<0)) ...
    		+	BB(2,3) * ((x-1/3>0).*(x-2/3<0)) 	* (y'-2/3>0) ...
    		+	BB(3,1) * (x-2/3>0) 				* (y'-1/3<0) ...
    		+	BB(3,2) * (x-2/3>0) 				* ((y'-1/3>0).*(y'-2/3<0)) ...
    		+	BB(3,3) * (x-2/3>0) 				* (y'-2/3>0);


    case 'NewDegenGraphon1'
    	BB = [	0.5, 0.2; ...
    			0.2, 0.5];
    	z =		BB(1,1) * (x-1/2<0) * (y'-1/2<0) ...
    		+	BB(1,2) * (x-1/2<0) * (y'-1/2>0) ...
    		+	BB(2,1) * (x-1/2>0) * (y'-1/2<0) ...
    		+	BB(2,2) * (x-1/2>0) * (y'-1/2>0);


    case 'NewDegenGraphon2'
    	z = 0.3 * ones(n,n);

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%


	case 'BlockModel1'

		z =  0.0*(((x-1/2) * (y-1/2)')>0) + 0.4*((x-1/2)>0)*((y-1/2)>0)' + 0.2;
		z = z./0.3;

    case 'BlockModel2'
        z =  0.0*(((x-1/2) * (y-1/2)')>0) + 0.3*((x-1/2)>0)*((y-1/2)>0)' + 0.1;
        z = z./0.175;
        
    case 'BlockModel3'
        z =  0.0*(((x-1/4) * (y-1/4)')>0) + 0.4*((x-1/4)>0)*((y-1/4)>0)' + 0.2;
        z = z./0.425;

    case 'BlockModel4'
        z =  0.0*(((x-2/3) * (y-2/3)')>0) + 0.2*(1.*((x-2/3)>0)+1)*(1.*((y-2/3)>0)+1)';	
        z = z./0.355556;

    case 'BlockModel5'
        z =  0.0*(((x-1/3) * (y-1/3)')>0) + 0.6*((x-1/3)>0)*((y-1/3)>0)' + 0.2;
        z = z./0.466667;

	case 'SmoothGraphon1'		
		XX = x*ones(1,n);  YY = ones(n,1)*y';
        z = (XX+YY)./2./0.5;
		
	case 'SmoothGraphon2'	
		XX = x*ones(1,n);  YY = ones(n,1)*y';
        z = (XX+YY).^2/2/0.583333;

	case 'SmoothGraphon3'	
		XX = x*ones(1,n);  YY = ones(n,1)*y';
        z = exp(-(XX+YY)./2)./0.619272;
	case 'SmoothGraphon4'	
		XX = x*ones(1,n);  YY = ones(n,1)*y';
        z = exp(-(XX+YY)./3)/0.72319;

	case 'SmoothGraphon5'	
		XX = x*ones(1,n);  YY = ones(n,1)*y';
        z = cos((XX+YY)./2)/0.859451;
		
	case 'NonSmoothGraphon'
		XX = x*ones(1,n);  YY = ones(n,1)*y';
		z = 0.5*(cos(0.1./((XX-0.5).^2+(YY-0.5).^2+0.01))).*(max(XX.^(2/3),YY.^(2/3))) + 0.4;
	case 'SmoothGraphoncomplex'		
        XX = x*ones(1,n);  YY = ones(n,1)*y';
		z = ((XX.^2+YY.^2)/3 .* cos(1./(XX.^2+YY.^2)) + 0.15)/0.218893;
	end

	z = z*rho;
	
end
