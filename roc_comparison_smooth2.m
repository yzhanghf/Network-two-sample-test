clear
% nall = [100,200,400,800,1600];
nall = [100, 200, 400,800,1600];
nall_R = [100, 200, 400];
nall_netcomp = [100, 200, 400];
nall_netlsd = [100, 200, 400,800];
nall_noderes = [100, 200];
total_MC= 30;
% total_MClist= 31:60;
MarkerSize = 12;  LineWidth = 2;
exampleall = ["SmoothGraphon1"];
for example = exampleall
    hashtime1 = zeros(length(nall),1);
    elapsedTime1 = zeros(total_MC,length(nall));
    elapsedTime2 = zeros(total_MC,length(nall));
    elapsedTime3 = zeros(total_MC,length(nall));
    elapsedTime4 = zeros(total_MC,length(nall_R));
    elapsedTime5 = zeros(total_MC,length(nall));
    elapsedTime6 = zeros(total_MC,length(nall));
    auc_r1 = zeros(total_MC,length(nall));
    auc_r2 = zeros(total_MC,length(nall));
    auc_r3 = zeros(total_MC,length(nall));
    auc_r4 = zeros(total_MC,length(nall_R));
    auc_r5 = zeros(total_MC,length(nall));
    auc_r6 = zeros(total_MC,length(nall));
    for i = 1:length(nall_R)   
        n = nall_R(i);
        if n == 800 || n == 1600
            true_label = table2array(readtable(strcat("./ROC_result/truth_label2_R_",string(n),example,"1.csv")));
            R_comp = table2array(readtable(strcat("./ROC_result/comparison2_non_R_",string(n),example,"1.csv")));
            timetemp = log(table2array(readtable(strcat("./ROC_result/time_query2_R_",string(n),example,"1.csv")))); 
            for iter_mc = 1
                [x1,y1,T,AUC] = perfcurve(true_label,R_comp(iter_mc,:),1);

            end 
            auc_r4(:,i) = AUC;
            elapsedTime4(:,i) = timetemp;
        elseif  n == 100 || n == 200 || n == 400
            true_label = table2array(readtable(strcat("./ROC_result/truth_label2_R_",string(n),example,"1.csv")));
            R_comp = table2array(readtable(strcat("./ROC_result/comparison2_non_R_",string(n),example,"1.csv")));
            for iter_mc = 1:total_MC
                [x1,y1,T,AUC] = perfcurve(true_label,R_comp(iter_mc,:),1);
                auc_r4(iter_mc,i) = AUC;
            end
            timetemp = log(table2array(readtable(strcat("./ROC_result/time_query2_R_",string(n),example,"1.csv")))); 
            elapsedTime4(:,i) = timetemp(iter_mc);
        end
    end
    for i = 1:length(nall)   
        n = nall(i);
        hashtime1(i) = log(table2array(readtable(strcat("./ROC_result/hashtime_pval_",example,string(n),".csv"))));
        elapsedTime1(:,i) = log(table2array(readtable(strcat("./ROC_result/querytime_pval_",example,string(n),".csv"))));
        auc_r1(:,i)  = table2array(readtable(strcat("./ROC_result/auc_pval_",example,string(n),".csv")));
        elapsedTime5(:,i) = log(table2array(readtable(strcat("./ROC_result/querytime_pval_subsamp_",example,string(n),".csv"))));
        auc_r5(:,i)  = table2array(readtable(strcat("./ROC_result/auc_pval_subsamp_",example,string(n),".csv")));
        elapsedTime6(:,i) = log(table2array(readtable(strcat("./ROC_result/querytime_pval_nores_",example,string(n),".csv"))));
        auc_r6(:,i)  = table2array(readtable(strcat("./ROC_result/auc_pval_nores_",example,string(n),".csv")));
    end
    for i = 1:length(nall_netcomp)
        n = nall_netcomp(i);
        load(strcat("./ROC_result/python_result1_netcomp_",string(n),"_SmoothGraphon1.mat"))
        for iter_mc = 1:size(netcomp,1)
            [x1,y1,T,AUC] = perfcurve(true_label,exp(-netcomp(iter_mc,:)),1);
            auc_r2(iter_mc,i) = AUC;
        end
        elapsedTime2(:,i) = log(time_netcomp)'; 
    end
    for i = 1:length(nall_netlsd)
        n = nall_netlsd(i);
        load(strcat("./ROC_result/python_result1_netlsd_",string(n),"_SmoothGraphon1.mat"))
        %         true_label = table2array(readtable(strcat("C:\unity\two_sample_network\ROC_comparison\truth_label_python_",string(n),example,".csv")));

        for iter_mc = 1:size(netlsd,1)
            [x1,y1,T,AUC] = perfcurve(true_label,exp(-netlsd(iter_mc,:)),1);
            auc_r3(iter_mc,i) = AUC;
        end
        elapsedTime3(:,i) = log(time_netlsd)'; 

    end
    auc_r3(auc_r3==0)=NaN;
    auc_r2(auc_r2==0)=NaN;
    
    fig1 = figure('visible','on');
    box on
    plot1 = plot(log(nall),hashtime1,'linewidth',LineWidth,'MarkerSize',MarkerSize, 'Color',[0, 0.5, 0],'Marker','^');
    hold on;
    plot1 = shadedErrorBar(log(nall),nanmean(elapsedTime1,1),nanstd(elapsedTime1,0,1),'lineProps',{'r-o','color',[0, 0.5, 0],'linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);
    
    hold on; 
    plot5 = shadedErrorBar(log(nall),nanmean(elapsedTime5,1),nanstd(elapsedTime5,0,1),'lineProps',{'r-o','color',[0.8500, 0.3250, 0.0980],'linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);
    hold on; 
    plot6 = shadedErrorBar(log(nall_noderes),nanmean(elapsedTime6(:,1:length(nall_noderes)),1),nanstd(elapsedTime6(:,1:length(nall_noderes)),0,1),'lineProps',{'r-o','color',[0.4940, 0.1840, 0.5560],'linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);
    hold on; 
    plot4 = shadedErrorBar(log(nall_R),nanmean(elapsedTime4,1),nanstd(elapsedTime4,0,1),'lineProps',{'r-o','color',[0,0,1],'linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);
    hold on;
    plot3 = shadedErrorBar(log(nall_netlsd),nanmean(elapsedTime3(:,1:length(nall_netlsd)),1),nanstd(elapsedTime3(:,1:length(nall_netlsd)),0,1),'lineProps',{'r-o','color','m','linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);
    hold on;
    plot2 = shadedErrorBar(log(nall_netcomp),nanmean(elapsedTime2(:,1:length(nall_netcomp)),1),nanstd(elapsedTime2(:,1:length(nall_netcomp)),0,1),'lineProps',{'r-o','color',[0, 0.4470, 0.7410],'linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);

    hold off;
    xlim([log(nall(1))-0.1,log(nall(end))+0.1]);
    xticks(log(nall));  xticklabels(nall);  xlabel('# of nodes');  ylabel('Log(time)');	
    ylim([-0.1,8]);
    cutoff = log(3600*12/30);
    y1 = yline(cutoff,'r:',{'Total running time = 12 hours'},'LineStyle','--','linewidth',2,'LabelHorizontalAlignment','center','FontSize', 15,'FontWeight','bold');
    legend("Our method (hash)","Our method (query)","Subsample","Resample","NonparGT",  "NetLSD","NetComp",'position',[0.59,0.28,0,0],'NumColumns', 2,'color','none');
    set(gca, 'FontSize', 15)
    ax = gca;
    ax.TitleFontSizeMultiplier = 1.8;
    title(strcat('Time cost'),'interpreter','latex');
%     set(gca,'LooseInset',get(gca,'TightInset'));
    pbaspect([1.2 1 1])
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 5.8, 5], 'PaperUnits', 'Inches', 'PaperSize', [5.8, 5])
    
%     exportgraphics(fig1,strcat('C:\phd4\network yuan\two sample inference for network moments\JASA_submission\plot\timecostcomparisonpval',example,'comp.png'))
    
    fig2 = figure('visible','on');
    box on
    plot1 = shadedErrorBar(log(nall),nanmean(auc_r1,1),nanstd(auc_r1,0,1),'lineProps',{'r-o','color',[0, 0.5, 0],'linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);
    hold on
    plot5 = shadedErrorBar(log(nall),nanmean(auc_r5,1),nanstd(auc_r5,0,1),'lineProps',{'r-o','color',[0.8500, 0.3250, 0.0980],'linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);
    hold on
    plot6 = shadedErrorBar(log(nall_noderes),nanmean(auc_r6(:,1:length(nall_noderes)),1),nanstd(auc_r6(:,1:length(nall_noderes)),0,1),'lineProps',{'r-o','color',[0.4940, 0.1840, 0.5560],'linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);
    hold on
    plot4 = shadedErrorBar(log(nall_R),nanmean(auc_r4,1),nanstd(auc_r4,0,1),'lineProps',{'r-o','color',[0,0,1],'linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);
    hold on
    plot3 = shadedErrorBar(log(nall_netlsd),nanmean(auc_r3(:,1:length(nall_netlsd)),1),nanstd(auc_r3(:,1:length(nall_netlsd)),0,1),'lineProps',{'r-o','color','m','linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);
    hold on
    plot2 = shadedErrorBar(log(nall_netcomp),nanmean(auc_r2(:,1:length(nall_netcomp)),1),nanstd(auc_r2(:,1:length(nall_netcomp)),0,1),'lineProps',{'r-o','color',[0, 0.4470, 0.7410],'linewidth',LineWidth,'MarkerSize',MarkerSize},'transparent',1);

    hold off
    xticks(log(nall));  xticklabels(nall);  xlabel('# of nodes');  ylabel('AUC');	ylim([0.4 1.05]);
    legend("Our method","Subsample","Resample","NonparGT", "NetLSD", "NetComp",'Location','southeast','NumColumns', 3);
    xlim([log(nall(1))-0.1,log(nall(end))+0.1]);
    ylim([0.3,1.05]);
    title(strcat('AUC'),'interpreter','latex');
    set(gca, 'FontSize', 15)
    ax = gca;
    ax.TitleFontSizeMultiplier = 1.8;
%     set(gca,'LooseInset',get(gca,'TightInset'));
    pbaspect([1.2 1 1])
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 5.8, 5], 'PaperUnits', 'Inches', 'PaperSize', [5.8, 5])
end