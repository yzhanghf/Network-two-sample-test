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
        min_truth = readtable(strcat("./ROC_result/minpv_truth_pval_",example,string(n),".csv"));
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