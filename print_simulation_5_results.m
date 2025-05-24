
% Configuration: motif types and graphon models

mall = [80,160,320,640];
nall = [80,160,320,640];
MotifNameall = ["Triangle","Vshape"];
alpha_all = [1.25,1.50,1.75,2.00,2.25];
GraphonNameArray = {{'NewDegenGraphon1', 'NewDegenGraphon1'},...
					{'NewDegenGraphon1', 'NewDegenGraphon2'},...
					{'NewDegenGraphon2', 'NewDegenGraphon2'},...
					{'NewDegenGraphon1', 'NewBlockModel1'},...
					{'NewDegenGraphon1', 'NewBlockModel2'},...
					{'NewDegenGraphon2', 'NewBlockModel1'},...
					{'NewDegenGraphon2', 'NewBlockModel2'},...
					{'NewDegenGraphon1', 'NewSmoothGraphon2'},...
					{'NewDegenGraphon1', 'NewSmoothGraphon4'},...
					{'NewDegenGraphon2', 'NewSmoothGraphon2'},...
					{'NewDegenGraphon2', 'NewSmoothGraphon4'}};
sparse_power_all = [0.125,0.25,0.33,0.50];


% Print results

for sparse_power = sparse_power_all
	A_sparse_power = sparse_power;
	B_sparse_power = sparse_power;
	for MotifName = MotifNameall
		for GraphonNameIndex = 1:length(GraphonNameArray)
			GraphonName1 = GraphonNameArray{GraphonNameIndex}{1};
			GraphonName2 = GraphonNameArray{GraphonNameIndex}{2};
			for alpha = alpha_all
				for m_idx = 1:length(mall)
					m = mall(m_idx);

					t_mat = [];
					for n_idx = 1:length(nall)
						n = nall(n_idx);
			            
			            if(strcmp(GraphonName1,GraphonName2) & (m>n))
			                
			                t_mat(:,n_idx) = readmatrix(strcat("./results/MC_t_",...
							    MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
							    '100UstatReduPow_',sprintf('%03d',100*alpha), ...
							    '_100sparA_',sprintf('%03d',1000*abs(A_sparse_power)), ...
							    '_100sparB_',sprintf('%03d',1000*abs(B_sparse_power)), ...
							    "_m_", string(n), "n_", string(m),".csv"));

			            else

						    t_mat(:,n_idx) = readmatrix(strcat("./results/MC_t_",...
							    MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
							    '100UstatReduPow_',sprintf('%03d',100*alpha), ...
							    '_100sparA_',sprintf('%03d',1000*abs(A_sparse_power)), ...
							    '_100sparB_',sprintf('%03d',1000*abs(B_sparse_power)), ...
							    "_m_", string(m), "n_", string(n),".csv"));
			            end

					end

					numColumns = length(nall);
					rainbowColors = jet(numColumns);



					switch GraphonName1
					case 'NewDegenGraphon1'
						ModelName1 = 'D1';
					case 'NewDegenGraphon2'
						ModelName1 = 'D2';
					case 'NewBlockModel1'
						ModelName1 = 'B1';
					case 'NewBlockModel2';
						ModelName1 = 'B2';
					case 'NewSmoothGraphon2';
						ModelName1 = 'S1';
					case 'NewSmoothGraphon4';
						ModelName1 = 'S2';
					end

					switch GraphonName2
					case 'NewDegenGraphon1'
						ModelName2 = 'D1';
					case 'NewDegenGraphon2'
						ModelName2 = 'D2';
					case 'NewBlockModel1'
						ModelName2 = 'B1';
					case 'NewBlockModel2';
						ModelName2 = 'B2';
					case 'NewSmoothGraphon2';
						ModelName2 = 'S1';
					case 'NewSmoothGraphon4';
						ModelName2 = 'S2';
					end





			        fig = figure('visible','off');

					hold on; % Keep the same plot for overlaying lines
					for i = 1:numColumns
					    % Extract data from the ith column
					    data1 = t_mat(:, i);
					    
					    % Generate Q-Q plot for the column
					    qqplot(data1);
					    xlim([-4 4]);  ylim([-4 4]);
					    
					    % Set the line color to the ith color in the rainbow
					    h = findobj(gca,'Type','line');
					    delete(h(2));
					    delete(h(3));
					    set(h(1),'Color',rainbowColors(i,:)); % Change line color
					    set(h(1),'MarkerEdgeColor',rainbowColors(i,:)); % Change marker color
					end

					plot([-4 4], [-4 4], '--k'); % Dashed line ('--') in black ('k')

					hold off;

					font_size = 20;

					legendStrings = arrayfun(@(n) ['$n=' num2str(n) '$'], nall, 'UniformOutput', false);
					legend(legendStrings{:}, 'Interpreter', 'latex', 'Location', 'southeast', 'FontSize', font_size);
					% legend('$n=80$', '$n=160$', '$n=320$', '$n=640$', 'Interpreter', 'latex', 'Location', 'best');
					xlabel('Theoretical Quantiles', 'FontSize', font_size);
					ylabel('Sample Quantiles', 'FontSize', font_size);
					% title({ ...
					% 	'Q-Q Plots of $\hat T_{m,n}$', ...
					% 	sprintf('%s, %s vs %s;',MotifName, GraphonName1, GraphonName2), ...
					% 	sprintf('$\\lambda=$%1.2f; $\\rho_A \\asymp n^{%1.3f}$; $\\rho_B \\asymp n^{%1.3f}$; $m=$%d', alpha, -abs(A_sparse_power), -abs(B_sparse_power), m) ...
					% 	}, 'Interpreter','latex');
					title({ ...
						sprintf('Q-Q Plots of $\\widehat T_{m,n}$, %s, $\\lambda=%1.2f$;',MotifName,alpha), ...
						sprintf('Model: %s vs %s;', ModelName1, ModelName2), ...
						sprintf('$\\rho_A \\asymp m^{%1.3f}$; $\\rho_B \\asymp n^{%1.3f}$; $m=%d$', -abs(A_sparse_power), -abs(B_sparse_power), m) ...
						}, 'Interpreter','latex', 'FontSize', font_size);

					ax = gca;
					ax.FontSize = font_size; 

					

			        exportgraphics(fig, strcat('plots/degen_',MotifName,'_',GraphonName1,'_',GraphonName2,'_alpha_',string(100*alpha),'_ABspar_',string(1000*abs(A_sparse_power)),'_m_',string(m),'.png'));

				end
			end
		end % end for motifname
	end % end for sparse_power
end


