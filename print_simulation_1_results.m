% Print type-I error comparison with benchmarks

clear
% N = [10,20,40,80,160];
N = [20,40,80];
MotifNameall   = ["Triangle","Vshape"];
coverage = zeros(length(N),length(MotifNameall));
coverage2 = zeros(length(N),length(MotifNameall));

GraphonName1 =  'NewSmoothGraphon2';
GraphonName2 =  'NewSmoothGraphon2';
coveragemean = zeros(length(N),length(N));
coverage2mean = zeros(length(N),length(N));
coveragestd = zeros(length(N),length(N));
coverage2std = zeros(length(N),length(N));
for mf = 1:length(MotifNameall)
    for k = 1:length(N)
        for l = 1:length(N)
            m = N(k);
            n = N(l);
            MotifName = MotifNameall(mf);
            cover = readtable(strcat("./results/MC_t_cover_edge_",string(m),"_",string(n),"_",MotifName,"_",GraphonName1,"_",GraphonName2,"_mn.csv"));
            cover = table2array(cover);
            coveragemean(k,l) = nanmean(cover);
            coveragestd(k,l) = nanstd(cover,0);
            cover = readtable(strcat("./results/MC_t_cover_norm_",string(m),"_",string(n),"_",MotifName,"_",GraphonName1,"_",GraphonName2,"_mn.csv"));
            cover = table2array(cover);
            coverage2mean(k,l) = nanmean(cover);
            coverage2std(k,l) = nanstd(cover,0);
        end
    end
    fig = figure("visible","on");
    % start setting color map
    mm = 101;
    half_mm = floor(mm/2);
    cmp = zeros(mm,3);
    portions = (0:(half_mm-1))/half_mm;  portions = portions(:);
    cmp = [...
        portions * [1 1 1] + (1-portions) * [0 0 1]; ...
        [1 1 1]; ...
        (1-portions) * [1 1 1] + portions * [1 0 0]; ...
        ];
    cp = colormap( cmp );
    diff = abs(coveragemean-0.90)-abs(coverage2mean-0.90);
    imagesc(diff);
    colorbar;
    title(['|(Cover. Prob.) - (1-\alpha)|',strcat("Our method vs N(0,1), ",MotifName)]);
    pbaspect([1 1 1])                                           % Original 'XTick' Values
    xt = 1:1:5;
    xtlbl = N;                     % New 'XTickLabel' Vector
    set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   % Label Ticks
    set(gca, 'YTick',xt, 'YTickLabel',xtlbl)   % Label Ticks
    ax = gca;
    ax.TitleFontSizeMultiplier = 1;
    set(gca, 'FontSize', 18)
    caxis([-0.1, 0.1]);
    ylabel('# of nodes');
    set(gcf, 'Units', 'Inches',  'Position', [0, 0,4.7, 4.1],'PaperUnits', 'Inches', 'PaperSize', [5, 5])
    saveas(fig,strcat('heatmap_coverage_'+MotifName+'.png'))
end


% Print power comparison with benchmarks

N = [20,40,80,160, 320,640];

sig_level = 0.10;

MotifNameall   = ["Triangle","Vshape"];
coverage = zeros(length(N),length(MotifNameall));
coverage2 = zeros(length(N),length(MotifNameall));

% GraphonName1 =  'SmoothGraphon4';
% GraphonName2 =  'SmoothGraphon4';
GraphonNameArray = {{'SmoothGraphon2', 'SmoothGraphon2'},...
                    {'SmoothGraphon4', 'SmoothGraphon4'},...
                    {'NewSmoothGraphon2', 'NewSmoothGraphon2'},...
                    {'NewSmoothGraphon4', 'NewSmoothGraphon4'}};

                    
coveragemean = zeros(length(N),length(N));
coverage2mean = zeros(length(N),length(N));
coveragestd = zeros(length(N),length(N));
coverage2std = zeros(length(N),length(N));

coverage_netcomp_mean   = zeros(length(N),length(N));
coverage_netcomp_std    = zeros(length(N),length(N));

coverage_netlsd_mean    = zeros(length(N),length(N));
coverage_netlsd_std     = zeros(length(N),length(N));

coverage_nonparGT_mean  = zeros(length(N),length(N));
coverage_nonparGT_std   = zeros(length(N),length(N));

coverage_resample_mean  = zeros(length(N),length(N));
coverage_resample_std   = zeros(length(N),length(N));

coverage_subsample_mean = zeros(length(N),length(N));
coverage_subsample_std  = zeros(length(N),length(N));

for GraphonNameIndex = 1:length(GraphonNameArray)
    GraphonName1 = GraphonNameArray{GraphonNameIndex}{1};
    GraphonName2 = GraphonNameArray{GraphonNameIndex}{2};

for shift_amount = [0.00,0.05,0.10,0.20,0.40]
    for mf = 1:length(MotifNameall)
        for k = 1:length(N)
            for l = 1:length(N)
                m = N(k);
                n = N(l);
                MotifName = MotifNameall(mf);
                cover = readtable(strcat("./results/cover_edge_",...
                    MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
                    "100shift_",sprintf('%03d',100*shift_amount),...
                    "m_", string(m), "n_", string(n),".csv"));
                cover = table2array(cover);
                coveragemean(k,l) = nanmean(cover);
                coveragestd(k,l)  = nanstd(cover,0);

                cover = readtable(strcat("./results/cover_norm_",...
                    MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
                    "100shift_",sprintf('%03d',100*shift_amount),...
                    "m_", string(m), "n_", string(n),".csv"));
                cover = table2array(cover);
                coverage2mean(k,l) = nanmean(cover);
                coverage2std(k,l)  = nanstd(cover,0);

                cover = readtable(strcat("./results/cover_netcomp_",...
                MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
                "100shift_",sprintf('%03d',100*shift_amount),...
                "m_", string(m), "n_", string(n),".csv"));
                cover = table2array(cover);
                coverage_netcomp_mean(k,l) = nanmean(cover);
                coverage_netcomp_std(k,l)  = nanstd(cover,0);

                cover = readtable(strcat("./results/cover_netlsd_",...
                MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
                "100shift_",sprintf('%03d',100*shift_amount),...
                "m_", string(m), "n_", string(n),".csv"));
                cover = table2array(cover);
                coverage_netlsd_mean(k,l) = nanmean(cover);
                coverage_netlsd_std(k,l)  = nanstd(cover,0);

                cover = readtable(strcat("./results/cover_nonparGT_",...
                MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
                "100shift_",sprintf('%03d',100*shift_amount),...
                "m_", string(m), "n_", string(n),".csv"));
                cover = table2array(cover);
                coverage_nonparGT_mean(k,l) = nanmean(cover);
                coverage_nonparGT_std(k,l)  = nanstd(cover,0);

                cover = readtable(strcat("./results/cover_resample_",...
                MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
                "100shift_",sprintf('%03d',100*shift_amount),...
                "m_", string(m), "n_", string(n),".csv"));
                cover = table2array(cover);
                coverage_resample_mean(k,l) = nanmean(cover);
                coverage_resample_std(k,l)  = nanstd(cover,0);

                cover = readtable(strcat("./results/cover_subsample_",...
                MotifName,"_",GraphonName1,"_",GraphonName2,"_",...
                "100shift_",sprintf('%03d',100*shift_amount),...
                "m_", string(m), "n_", string(n),".csv"));
                cover = table2array(cover);
                coverage_subsample_mean(k,l) = nanmean(cover);
                coverage_subsample_std(k,l)  = nanstd(cover,0);

            end
        end
        







if(shift_amount > 0.0001)
    fig = figure("visible","off");

        
        % start setting color map
        mm = 101;
        half_mm = floor(mm/2);
        cmp = zeros(mm,3);
        portions = (0:(half_mm-1))/half_mm;  portions = portions(:);
        % cmp = [...
        %     portions * [1 1 1] + (1-portions) * [0 0 1]; ...
        %     [1 1 1]; ...
        %     (1-portions) * [1 1 1] + portions * [1 0 0]; ...
        %     ];
        cmp = [...
        portions * [1 1 1] + (1-portions) * [1 0 0]; ...
        [1 1 1]; ...
        (1-portions) * [1 1 1] + portions * [0 0 1]; ...
        ];

        % Apply the new colormap
    cp = colormap(cmp);

            diff = (1-coveragemean)-(1-coverage2mean);
            imagesc(diff);
            colorbar;
            title([strcat('Power diff.; shift=',string(shift_amount)),strcat("Our method vs N(0,1), ",MotifName)]);
            pbaspect([1 1 1])                                           % Original 'XTick' Values
            xt = 1:1:6;
            xtlbl = N;                     % New 'XTickLabel' Vector
            set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   % Label Ticks
            set(gca, 'YTick',xt, 'YTickLabel',xtlbl)   % Label Ticks
            ax = gca;
            ax.TitleFontSizeMultiplier = 1;
            set(gca, 'FontSize', 18)
            caxis([-1, 1]);
            xlabel('\# of networks $N_B$', 'Interpreter', 'latex');  ylabel('\# of networks $N_A$', 'Interpreter', 'latex');
            % set(gcf, 'Units', 'Inches',  'Position', [0, 0,4.7, 4.1],'PaperUnits', 'Inches', 'PaperSize', [5, 5])
            exportgraphics(fig,strcat('plots/NewSimu3_power_diff_ours_vs_norm_'+MotifName+'_'+GraphonName1+'_'+GraphonName2+'_100shift_'+sprintf('%03d',100*shift_amount)+'.png'))


    cp = colormap(cmp);

            diff = (1-coveragemean)-(1-coverage_netcomp_mean);
            imagesc(diff);
            colorbar;
            title([strcat('Power diff.; shift=',string(shift_amount)),strcat("Our method vs NetComp, ",MotifName)]);
            pbaspect([1 1 1])                                           % Original 'XTick' Values
            xt = 1:1:6;
            xtlbl = N;                     % New 'XTickLabel' Vector
            set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   % Label Ticks
            set(gca, 'YTick',xt, 'YTickLabel',xtlbl)   % Label Ticks
            ax = gca;
            ax.TitleFontSizeMultiplier = 1;
            set(gca, 'FontSize', 18)
            caxis([-1, 1]);
            xlabel('\# of networks $N_B$', 'Interpreter', 'latex');  ylabel('\# of networks $N_A$', 'Interpreter', 'latex');
            % set(gcf, 'Units', 'Inches',  'Position', [0, 0,4.7, 4.1],'PaperUnits', 'Inches', 'PaperSize', [5, 5])
            exportgraphics(fig,strcat('plots/NewSimu3_power_diff_ours_vs_netcomp_'+MotifName+'_'+GraphonName1+'_'+GraphonName2+'_100shift_'+sprintf('%03d',100*shift_amount)+'.png'))


    cp = colormap(cmp);

            diff = (1-coveragemean)-(1-coverage_netlsd_mean);
            imagesc(diff);
            colorbar;
            title([strcat('Power diff.; shift=',string(shift_amount)),strcat("Our method vs NetLSD, ",MotifName)]);
            pbaspect([1 1 1])                                           % Original 'XTick' Values
            xt = 1:1:6;
            xtlbl = N;                     % New 'XTickLabel' Vector
            set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   % Label Ticks
            set(gca, 'YTick',xt, 'YTickLabel',xtlbl)   % Label Ticks
            ax = gca;
            ax.TitleFontSizeMultiplier = 1;
            set(gca, 'FontSize', 18)
            caxis([-1, 1]);
            xlabel('\# of networks $N_B$', 'Interpreter', 'latex');  ylabel('\# of networks $N_A$', 'Interpreter', 'latex');
            % set(gcf, 'Units', 'Inches',  'Position', [0, 0,4.7, 4.1],'PaperUnits', 'Inches', 'PaperSize', [5, 5])
            exportgraphics(fig,strcat('plots/NewSimu3_power_diff_ours_vs_netlsd_'+MotifName+'_'+GraphonName1+'_'+GraphonName2+'_100shift_'+sprintf('%03d',100*shift_amount)+'.png'))


    cp = colormap(cmp);

            diff = (1-coveragemean)-(1-coverage_nonparGT_mean);
            imagesc(diff);
            colorbar;
            title([strcat('Power diff.; shift=',string(shift_amount)),strcat("Our method vs NonparGT, ",MotifName)]);
            pbaspect([1 1 1])                                           % Original 'XTick' Values
            xt = 1:1:6;
            xtlbl = N;                     % New 'XTickLabel' Vector
            set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   % Label Ticks
            set(gca, 'YTick',xt, 'YTickLabel',xtlbl)   % Label Ticks
            ax = gca;
            ax.TitleFontSizeMultiplier = 1;
            set(gca, 'FontSize', 18)
            caxis([-1, 1]);
            xlabel('\# of networks $N_B$', 'Interpreter', 'latex');  ylabel('\# of networks $N_A$', 'Interpreter', 'latex');
            % set(gcf, 'Units', 'Inches',  'Position', [0, 0,4.7, 4.1],'PaperUnits', 'Inches', 'PaperSize', [5, 5])
            exportgraphics(fig,strcat('plots/NewSimu3_power_diff_ours_vs_nonparGT_'+MotifName+'_'+GraphonName1+'_'+GraphonName2+'_100shift_'+sprintf('%03d',100*shift_amount)+'.png'))


    cp = colormap(cmp);

            diff = (1-coveragemean)-(1-coverage_resample_mean);
            imagesc(diff);
            colorbar;
            title([strcat('Power diff.; shift=',string(shift_amount)),strcat("Our method vs Resample, ",MotifName)]);
            pbaspect([1 1 1])                                           % Original 'XTick' Values
            xt = 1:1:6;
            xtlbl = N;                     % New 'XTickLabel' Vector
            set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   % Label Ticks
            set(gca, 'YTick',xt, 'YTickLabel',xtlbl)   % Label Ticks
            ax = gca;
            ax.TitleFontSizeMultiplier = 1;
            set(gca, 'FontSize', 18)
            caxis([-1, 1]);
            xlabel('\# of networks $N_B$', 'Interpreter', 'latex');  ylabel('\# of networks $N_A$', 'Interpreter', 'latex');
            % set(gcf, 'Units', 'Inches',  'Position', [0, 0,4.7, 4.1],'PaperUnits', 'Inches', 'PaperSize', [5, 5])
            exportgraphics(fig,strcat('plots/NewSimu3_power_diff_ours_vs_resample_'+MotifName+'_'+GraphonName1+'_'+GraphonName2+'_100shift_'+sprintf('%03d',100*shift_amount)+'.png'))


    cp = colormap(cmp);

            diff = (1-coveragemean)-(1-coverage_subsample_mean);
            imagesc(diff);
            colorbar;
            title([strcat('Power diff.; shift=',string(shift_amount)),strcat("Our method vs Subsample, ",MotifName)]);
            pbaspect([1 1 1])                                           % Original 'XTick' Values
            xt = 1:1:6;
            xtlbl = N;                     % New 'XTickLabel' Vector
            set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   % Label Ticks
            set(gca, 'YTick',xt, 'YTickLabel',xtlbl)   % Label Ticks
            ax = gca;
            ax.TitleFontSizeMultiplier = 1;
            set(gca, 'FontSize', 18)
            caxis([-1, 1]);
            xlabel('\# of networks $N_B$', 'Interpreter', 'latex');  ylabel('\# of networks $N_A$', 'Interpreter', 'latex');
            % set(gcf, 'Units', 'Inches',  'Position', [0, 0,4.7, 4.1],'PaperUnits', 'Inches', 'PaperSize', [5, 5])
            exportgraphics(fig,strcat('plots/NewSimu3_power_diff_ours_vs_subsample_'+MotifName+'_'+GraphonName1+'_'+GraphonName2+'_100shift_'+sprintf('%03d',100*shift_amount)+'.png'))


else


    fig = figure("visible","off");

        mm = 101;
        half_mm = floor(mm/2);
        cmp = zeros(mm,3);
        portions = (0:(half_mm-1))/half_mm;  portions = portions(:);
        cmp = [...
            portions * [1 1 1] + (1-portions) * [0 0 1]; ...
            [1 1 1]; ...
            (1-portions) * [1 1 1] + portions * [1 0 0]; ...
            ];


    cp = colormap(cmp);

            diff = abs(coveragemean-(1-sig_level)) - abs(coverage2mean-(1-sig_level));
            imagesc(diff);
            colorbar;
            title(['|(Type I err.) - (1-\alpha)|',strcat("Our method vs N(0,1), ",MotifName)]);
            pbaspect([1 1 1])                                           % Original 'XTick' Values
            xt = 1:1:6;
            xtlbl = N;                     % New 'XTickLabel' Vector
            set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   % Label Ticks
            set(gca, 'YTick',xt, 'YTickLabel',xtlbl)   % Label Ticks
            ax = gca;
            ax.TitleFontSizeMultiplier = 1;
            set(gca, 'FontSize', 18)
            caxis([-1, 1]);
            xlabel('\# of networks $N_B$', 'Interpreter', 'latex');  ylabel('\# of networks $N_A$', 'Interpreter', 'latex');
            % set(gcf, 'Units', 'Inches',  'Position', [0, 0,4.7, 4.1],'PaperUnits', 'Inches', 'PaperSize', [5, 5])
            exportgraphics(fig,strcat('plots/NewSimu3_typeI_diff_ours_vs_norm_'+MotifName+'_'+GraphonName1+'_'+GraphonName2+'_100shift_'+sprintf('%03d',100*shift_amount)+'.png'))


    cp = colormap(cmp);

            diff = abs(coveragemean-(1-sig_level)) - abs(coverage_netcomp_mean-(1-sig_level));
            imagesc(diff);
            colorbar;
            title(['|(Type I err.) - (1-\alpha)|',strcat("Our method vs NetComp, ",MotifName)]);
            pbaspect([1 1 1])                                           % Original 'XTick' Values
            xt = 1:1:6;
            xtlbl = N;                     % New 'XTickLabel' Vector
            set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   % Label Ticks
            set(gca, 'YTick',xt, 'YTickLabel',xtlbl)   % Label Ticks
            ax = gca;
            ax.TitleFontSizeMultiplier = 1;
            set(gca, 'FontSize', 18)
            caxis([-1, 1]);
            xlabel('\# of networks $N_B$', 'Interpreter', 'latex');  ylabel('\# of networks $N_A$', 'Interpreter', 'latex');
            % set(gcf, 'Units', 'Inches',  'Position', [0, 0,4.7, 4.1],'PaperUnits', 'Inches', 'PaperSize', [5, 5])
            exportgraphics(fig,strcat('plots/NewSimu3_typeI_diff_ours_vs_netcomp_'+MotifName+'_'+GraphonName1+'_'+GraphonName2+'_100shift_'+sprintf('%03d',100*shift_amount)+'.png'))


    cp = colormap(cmp);

            diff = abs(coveragemean-(1-sig_level)) - abs(coverage_netlsd_mean-(1-sig_level));
            imagesc(diff);
            colorbar;
            title(['|(Type I err.) - (1-\alpha)|',strcat("Our method vs NetLSD, ",MotifName)]);
            pbaspect([1 1 1])                                           % Original 'XTick' Values
            xt = 1:1:6;
            xtlbl = N;                     % New 'XTickLabel' Vector
            set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   % Label Ticks
            set(gca, 'YTick',xt, 'YTickLabel',xtlbl)   % Label Ticks
            ax = gca;
            ax.TitleFontSizeMultiplier = 1;
            set(gca, 'FontSize', 18)
            caxis([-1, 1]);
            xlabel('\# of networks $N_B$', 'Interpreter', 'latex');  ylabel('\# of networks $N_A$', 'Interpreter', 'latex');
            % set(gcf, 'Units', 'Inches',  'Position', [0, 0,4.7, 4.1],'PaperUnits', 'Inches', 'PaperSize', [5, 5])
            exportgraphics(fig,strcat('plots/NewSimu3_typeI_diff_ours_vs_netlsd_'+MotifName+'_'+GraphonName1+'_'+GraphonName2+'_100shift_'+sprintf('%03d',100*shift_amount)+'.png'))


    cp = colormap(cmp);

            diff = abs(coveragemean-(1-sig_level)) - abs(coverage_nonparGT_mean-(1-sig_level));
            imagesc(diff);
            colorbar;
            title(['|(Type I err.) - (1-\alpha)|',strcat("Our method vs NonparGT, ",MotifName)]);
            pbaspect([1 1 1])                                           % Original 'XTick' Values
            xt = 1:1:6;
            xtlbl = N;                     % New 'XTickLabel' Vector
            set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   % Label Ticks
            set(gca, 'YTick',xt, 'YTickLabel',xtlbl)   % Label Ticks
            ax = gca;
            ax.TitleFontSizeMultiplier = 1;
            set(gca, 'FontSize', 18)
            caxis([-1, 1]);
            xlabel('\# of networks $N_B$', 'Interpreter', 'latex');  ylabel('\# of networks $N_A$', 'Interpreter', 'latex');
            % set(gcf, 'Units', 'Inches',  'Position', [0, 0,4.7, 4.1],'PaperUnits', 'Inches', 'PaperSize', [5, 5])
            exportgraphics(fig,strcat('plots/NewSimu3_typeI_diff_ours_vs_nonparGT_'+MotifName+'_'+GraphonName1+'_'+GraphonName2+'_100shift_'+sprintf('%03d',100*shift_amount)+'.png'))


    cp = colormap(cmp);

            diff = abs(coveragemean-(1-sig_level)) - abs(coverage_resample_mean-(1-sig_level));
            imagesc(diff);
            colorbar;
            title(['|(Type I err.) - (1-\alpha)|',strcat("Our method vs Resample, ",MotifName)]);
            pbaspect([1 1 1])                                           % Original 'XTick' Values
            xt = 1:1:6;
            xtlbl = N;                     % New 'XTickLabel' Vector
            set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   % Label Ticks
            set(gca, 'YTick',xt, 'YTickLabel',xtlbl)   % Label Ticks
            ax = gca;
            ax.TitleFontSizeMultiplier = 1;
            set(gca, 'FontSize', 18)
            caxis([-1, 1]);
            xlabel('\# of networks $N_B$', 'Interpreter', 'latex');  ylabel('\# of networks $N_A$', 'Interpreter', 'latex');
            % set(gcf, 'Units', 'Inches',  'Position', [0, 0,4.7, 4.1],'PaperUnits', 'Inches', 'PaperSize', [5, 5])
            exportgraphics(fig,strcat('plots/NewSimu3_typeI_diff_ours_vs_resample_'+MotifName+'_'+GraphonName1+'_'+GraphonName2+'_100shift_'+sprintf('%03d',100*shift_amount)+'.png'))


    cp = colormap(cmp);

            diff = abs(coveragemean-(1-sig_level)) - abs(coverage_subsample_mean-(1-sig_level));
            imagesc(diff);
            colorbar;
            title(['|(Type I err.) - (1-\alpha)|',strcat("Our method vs Subsample, ",MotifName)]);
            pbaspect([1 1 1])                                           % Original 'XTick' Values
            xt = 1:1:6;
            xtlbl = N;                     % New 'XTickLabel' Vector
            set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   % Label Ticks
            set(gca, 'YTick',xt, 'YTickLabel',xtlbl)   % Label Ticks
            ax = gca;
            ax.TitleFontSizeMultiplier = 1;
            set(gca, 'FontSize', 18)
            caxis([-1, 1]);
            xlabel('\# of networks $N_B$', 'Interpreter', 'latex');  ylabel('\# of networks $N_A$', 'Interpreter', 'latex');
            % set(gcf, 'Units', 'Inches',  'Position', [0, 0,4.7, 4.1],'PaperUnits', 'Inches', 'PaperSize', [5, 5])
            exportgraphics(fig,strcat('plots/NewSimu3_typeI_diff_ours_vs_subsample_'+MotifName+'_'+GraphonName1+'_'+GraphonName2+'_100shift_'+sprintf('%03d',100*shift_amount)+'.png'))

end


    end
end


  
end



