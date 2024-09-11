

%% plot log p value comparison histogram plot with truncated x axis near 0 

nall = [100,200,400,800,1600];
example1 = "BlockModel1"; %% we compared "SmoothGraphon1" in the supplementary materials
example2 = "SmoothGraphoncomplex";
for i = 1:length(nall)   
    n = nall(i);
    min_truth1 = readtable(strcat("./ROC_result/minpv_truth_",example1,string(n),".csv"));
    min_truth1 = table2array(min_truth1);
    min_truth2 = readtable(strcat("./ROC_result/minpv_truth_",example2,string(n),".csv"));
    min_truth2 = table2array(min_truth2);
    min_truth = log(cat(2,min_truth1(:,1),min_truth2(:,1)));
    NameList = {'Found','Not found'};
    h = {};
    plot_order = [1,2];
    color_list = {'c','r'};
    alpha_list = [0.7, 0.7];
    fig = figure('visible','on');
    hax = axes;
    for h_idx = plot_order       
        edges = linspace(-10, 0, 11);
	    h{h_idx} = histogram(min_truth(:,h_idx),'FaceAlpha',alpha_list(h_idx),'BinEdges',edges,'Normalization','probability');
	    h{h_idx}.FaceColor = color_list{h_idx};
	    hold on;
    end
    xlim([-10, 0]);
    ylim([0 0.11])
    cutoff = log(0.05);
    x1 = xline(cutoff,'b:',{'log(5%) = −2.996'},'LineStyle','--','linewidth',2,'LabelVerticalAlignment','middle','FontSize', 15,'FontWeight','bold');
    hold off;
    legend(NameList{plot_order},'Location','northwest','FontSize', 15);
    title({sprintf('n = %d',n)})
    xlabel('log p-value')
    ylabel('Probability')
    set(gca, 'FontSize', 18)
    ax = gca;
    ax.TitleFontSizeMultiplier = 1.5;
    set(gca,'LooseInset',get(gca,'TightInset'));
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 5, 5], 'PaperUnits', 'Inches', 'PaperSize', [5, 5])
    pbaspect([1.2 1 1])
    saveas(fig, sprintf('p_value_roc_hist_%d_details.png',n))
end

%% plot log p value comparison histogram plot without truncated x axis
for i = 1:length(nall)   
    n = nall(i);
    min_truth1 = readtable(strcat("./ROC_result/minpv_truth_",example1,string(n),".csv"));
    min_truth1 = table2array(min_truth1);
    min_truth2 = readtable(strcat("./ROC_result/minpv_truth_",example2,string(n),".csv"));
    min_truth2 = table2array(min_truth2);
    min_truth = log(cat(2,min_truth1(:,1),min_truth2(:,1)));
    NameList = {'Found','Not found'};
    h = {};
    plot_order = [1,2];
    color_list = {'c','r'};
    alpha_list = [0.7, 0.7];
    fig = figure('visible','on');
    hax = axes;
    for h_idx = plot_order       
        edges = linspace(min(-600), 0, 61);
	    h{h_idx} = histogram(min_truth(:,h_idx),'FaceAlpha',alpha_list(h_idx),'BinEdges',edges,'Normalization','probability');
	    h{h_idx}.FaceColor = color_list{h_idx};
	    hold on;
    end
    hold off;
    legend(NameList{plot_order},'Location','northwest','FontSize', 15);
    title({sprintf('n = %d',n)})

    xlabel('log p-value')
    ylabel('Probability')
    set(gca, 'FontSize', 18)
    ax = gca;
    ax.TitleFontSizeMultiplier = 1.5;
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 5, 5], 'PaperUnits', 'Inches', 'PaperSize', [5, 5])
    pbaspect([1.2 1 1])
    saveas(fig, sprintf('p_value_roc_hist_%d.png',n))
end