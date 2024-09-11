
% mall = [20,40,80];
% nall = [20,40,80];
mnall = [40,80,160,320];
% mnall = [80];
null_prop_all = 0.1:0.1:0.9;
N_networks = 300;
MotifNameall = ["Triangle","Vshape"];
LegendOn = [true, false];
% calA_set_quantile = 0.1;
sig_level = 0.1;

graphon_shift_list = [0,0.01,0.02,0.03,0.04,0.05];

font_size = 15;
line_width = 3;



GraphonNameArray = {{'NewBlockModel1', 'NewBlockModel2'},...
					{'NewBlockModel1', 'NewSmoothGraphon2'},...
					{'NewBlockModel1', 'NewSmoothGraphon4'},...
					{'NewBlockModel2', 'NewSmoothGraphon2'},...
					{'NewBlockModel2', 'NewSmoothGraphon4'},...
					{'NewSmoothGraphon2', 'NewSmoothGraphon4'}};

for LegendIndicator = LegendOn


for MotifName = MotifNameall
	for GraphonNameIndex = 1:length(GraphonNameArray)
		GraphonName1 = GraphonNameArray{GraphonNameIndex}{1};
		GraphonName2 = GraphonNameArray{GraphonNameIndex}{2};

		for mn_idx = 1:length(mnall)
			m = mnall(mn_idx);


			numColumns = length(graphon_shift_list);
			rainbowColors = jet(numColumns);

	        fig = figure('visible','off');

	        legends = cell(1, 2*numColumns);
	        lines = zeros(1, 2*numColumns);

	        hold on;

			for graphon_shift_idx = 1:length(graphon_shift_list)

				graphon_shift = graphon_shift_list(graphon_shift_idx);

				FDR_mean_record 	= readmatrix(strcat("./new-result-FDR/query_FDR_mean_",...
					MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
					'Ntests_',sprintf('%d',N_networks), ...
					'_CalAquant_', sprintf('%2d', 100*calA_set_quantile), ...
					'_shift_', sprintf('%2d', 100*graphon_shift), ...
					"_mn_", string(m),".csv"));

				% FDR_sd_record 		= readmatrix(strcat("./new-result-FDR/query_FDR_sd_",...
				% 	MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				% 	'Ntests_',sprintf('%d',N_networks), ...
				% 	'_CalAquant_', sprintf('%2d', 100*calA_set_quantile), ...
				% 	'_shift_', sprintf('%2d', 100*graphon_shift), ...
				% 	"_mn_", string(m),".csv"));

				power_mean_record 	= readmatrix(strcat("./new-result-FDR/query_power_mean_",...
					MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
					'Ntests_',sprintf('%d',N_networks), ...
					'_CalAquant_', sprintf('%2d', 100*calA_set_quantile), ...
					'_shift_', sprintf('%2d', 100*graphon_shift), ...
					"_mn_", string(m),".csv"));

				% power_sd_record 	= readmatrix(strcat("./new-result-FDR/query_power_sd_",...
				% 	MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
				% 	'Ntests_',sprintf('%d',N_networks), ...
				% 	'_CalAquant_', sprintf('%2d', 100*calA_set_quantile), ...
				% 	'_shift_', sprintf('%2d', 100*graphon_shift), ...
				% 	"_mn_", string(m),".csv"));

				lines(graphon_shift_idx) = plot(null_prop_all, FDR_mean_record, ...
					'LineStyle', '--', 'Color', rainbowColors(graphon_shift_idx, :), 'LineWidth', line_width);
				lines(length(graphon_shift_list)+graphon_shift_idx) = plot(null_prop_all, power_mean_record, ...
					'LineStyle', '-', 'Color',  rainbowColors(graphon_shift_idx, :), 'LineWidth', line_width);

				legends{graphon_shift_idx} = ['FDR,shift=' num2str(sprintf('%1.2f', graphon_shift))];
				legends{length(graphon_shift_list)+graphon_shift_idx}   = ['Power,shift=' num2str(sprintf('%1.2f', graphon_shift))];

			end

			if LegendIndicator
				legend(lines, legends, 'NumColumns', 2, 'Location', 'west', 'FontSize', font_size);
				xlabel('Proportion of null hypotheses', 'FontSize', font_size);
				ylabel('Rejection rate', 'FontSize', font_size);
				title({strcat('FDR and power of multiple testing'), ...
					strcat(MotifName, {', '}, GraphonName1, {' vs '}, GraphonName2), ...
					strcat(sprintf('%d',N_networks), ' networks; m=', sprintf('%d',m), '; zeta=', sprintf('%1.1f',calA_set_quantile), '; alpha=', sprintf('%1.1f', sig_level))}, 'FontSize', font_size);
				yline(sig_level, ':', 'Target FDR', 'HandleVisibility', 'off');

				ylim([0 1]);
				ax = gca;
				ax.FontSize = font_size; 
				set(gcf, 'PaperSize', [12 12]);


				hold off;

				saveas(fig, strcat("./plots/query_FDR_",...
						MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
						'Ntests_',sprintf('%d',N_networks), ...
						'_CalAquant_', sprintf('%2d', 100*calA_set_quantile), ...
						"_mn_", string(m),".png"));
			else
				xlabel('Proportion of null hypotheses', 'FontSize', font_size);
				ylabel('Rejection rate', 'FontSize', font_size);
				title({strcat('FDR and power of multiple testing'), ...
					strcat(MotifName, {', '}, GraphonName1, {' vs '}, GraphonName2), ...
					strcat(sprintf('%d',N_networks), ' networks; m=', sprintf('%d',m), '; zeta=', sprintf('%1.1f',calA_set_quantile), '; alpha=', sprintf('%1.1f', sig_level))}, 'FontSize', font_size);
				yline(sig_level, ':', 'Target FDR', 'HandleVisibility', 'off');

				ylim([0 1]);
				ax = gca;
				ax.FontSize = font_size; 
				set(gcf, 'PaperSize', [12 12]);


				hold off;

				saveas(fig, strcat("./plots/query_FDR_LegendOff_",...
						MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
						'Ntests_',sprintf('%d',N_networks), ...
						'_CalAquant_', sprintf('%2d', 100*calA_set_quantile), ...
						"_mn_", string(m),".png"));
			end

		end % end for mn_idx

	end
end



end

