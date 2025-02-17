% Print ROC curves for our method under different settings

nall = [100,200,400,800,1600];
total_MC= 30;
MarkerSize = 12;  LineWidth = 2;
exampleall = ["SmoothGraphon1"];
for example = exampleall
    time_hash = zeros(total_MC,length(nall));
    elapsedTime = zeros(total_MC,length(nall));
    auc_r = zeros(total_MC,length(nall));
    fig = figure('visible','on');
    box on
    for i = 1:length(nall)   
        n = nall(i);
        min_truth = readtable(strcat("./results/minpv_truth_pval_",example,string(n),".csv"));
        min_truth = table2array(min_truth);
        [x1,y1,T,AUC] = perfcurve(min_truth(:,2),min_truth(:,1),1);
        plot(x1,y1,"LineWidth",LineWidth);
        hold on;
    end
    xlabel('False positive rate')
    ylabel('True positive rate')
    title(strcat("ROC (our method)"),'interpreter','latex');
    legendCell = strcat('n=',string(num2cell(nall)));
    legend(legendCell,'FontSize', 20)
    hold off;
    set(gca, 'FontSize', 18)
    ax = gca;
    ax.TitleFontSizeMultiplier = 1.5;
    pbaspect([1.2 1 1])
    set(gca,'LooseInset',get(gca,'TightInset'));
    % set(gca,'LooseInset', [0,0,0,0])
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 5.8, 5], 'PaperUnits', 'Inches', 'PaperSize', [5.8, 5])
end



% Print comparison wtih benchmarks

nall = [100,200,400,800,1600];

for i = 1:length(nall)   
    n = nall(i);
    min_truth1 = readtable(strcat("./results/minpv_truth_pval_BlockModel1",string(n),".csv"));
    min_truth1 = table2array(min_truth1);
    min_truth2 = readtable(strcat("./results/minpv_truth_pval_SmoothGraphoncomplex",string(n),".csv"));
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
    title({sprintf('log p-value, N = %d',n)})
    title({sprintf('Query result, $n = %d$',n)},'interpreter','latex')

    xlabel('log p-value')
    ylabel('Probability')
    set(gca, 'FontSize', 18)
    ax = gca;
    ax.TitleFontSizeMultiplier = 1.5;
    set(gca,'LooseInset',get(gca,'TightInset'));
    % set(gca,'LooseInset', [0,0,0,0])
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 5, 5], 'PaperUnits', 'Inches', 'PaperSize', [5, 5])
    pbaspect([1.2 1 1])

end
