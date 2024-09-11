nall = [100,200,400,800,1600];
MarkerSize = 12;  LineWidth = 2;
exampleall = ["BlockModel1"];
for example = exampleall
    time_hash = zeros(total_MC,length(nall));
    elapsedTime = zeros(total_MC,length(nall));
    auc_r = zeros(total_MC,length(nall));
   
    fig = figure('visible','on');
    box on
    for i = 1:length(nall)   
        n = nall(i);
        min_truth = readtable(strcat("./ROC_result/minpv_truth_", example, string(n),".csv"));
        min_truth = table2array(min_truth);
        [x1,y1,T,AUC] = perfcurve(min_truth(:,2),min_truth(:,1),1);
        plot(x1,y1,"LineWidth",LineWidth);
        hold on;
        
        time_hash(:,i) = log(table2array(readtable(strcat("./ROC_result/hashtime_", example,string(n),".csv"))));
        elapsedTime(:,i) = log(table2array(readtable(strcat("./ROC_result/querytime_", example,string(n),".csv"))));
        auc_r(:,i)  = table2array(readtable(strcat("./ROC_result/auc_", example,string(n),".csv")));
    end
    xlabel('False positive rate')
    ylabel('True positive rate')
    title(strcat("ROC"));
    legendCell = strcat('n=',string(num2cell(nall)));
    legend(legendCell,'FontSize', 15)
    hold off;
    set(gca, 'FontSize', 18)
    ax = gca;
    ax.TitleFontSizeMultiplier = 1.5;
    pbaspect([1.2 1 1])
    set(gca,'LooseInset',get(gca,'TightInset'));
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 5.8, 5], 'PaperUnits', 'Inches', 'PaperSize', [5.8, 5])
	saveas(fig,strcat("ROCwith", example,'.png'))
    
    fig1 = figure('visible','on');
    box on
    plot1 = shadedErrorBar(log(nall),nanmean(time_hash,1),nanstd(time_hash,0,1),'lineProps',{'r-o','color','r','linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);
    hold on;
    plot2 = shadedErrorBar(log(nall),nanmean(elapsedTime,1),nanstd(elapsedTime,0,1),'lineProps',{'r-s','color',[0 0.5 0],'linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);
    hold off; 
    xlim([log(nall(1))-0.1,log(nall(end))+0.1]);
    xticks(log(nall));  xticklabels(nall);  xlabel('# of nodes');  ylabel('Log(time)');	
    
    legend("hash time", "query time",'Location','northwest');
    set(gca, 'FontSize', 18)
    ax = gca;
    ax.TitleFontSizeMultiplier = 1.5;
    title(strcat('Time cost breakdown (sec)'));
    set(gca,'LooseInset',get(gca,'TightInset'));
    pbaspect([1.2 1 1])
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 5.8, 5], 'PaperUnits', 'Inches', 'PaperSize', [5.8, 5])   
    saveas(fig1,strcat('timecostcomparison',example,'.png'))
    
    fig2 = figure('visible','on');
    box on
    xlim([log(nall(1))-0.1,log(nall(end))+0.1]);
    plot1 = shadedErrorBar(log(nall),nanmean(auc_r,1),nanstd(auc_r,0,1),'lineProps',{'r-o','color','m','linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);
    xticks(log(nall));  xticklabels(nall);  xlabel('# of nodes');  ylabel('AUC');	ylim([0.6 1.05]);
    title(strcat('AUC'));
    set(gca, 'FontSize', 18)
    ax = gca;
    ax.TitleFontSizeMultiplier = 1.5;
    set(gca,'LooseInset',get(gca,'TightInset'));
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 5.8, 5], 'PaperUnits', 'Inches', 'PaperSize', [5.8, 5])
    pbaspect([1.2 1 1])
    saveas(fig2,strcat('auc',example,'.png'))
end