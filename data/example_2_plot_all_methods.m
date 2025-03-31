rng(2);
% READ IN DATA
load('Final_data_facsimile.mat');
l_NC = size(cor_NC_fisherZ_correct, 3);
l_SZ = size(cor_SZ_fisherZ_correct, 3);
m = size(cor_NC_fisherZ_correct, 1);


l_idx = size(idx_mat, 2);
idxList = {};
for(ii = 1:l_idx)
	idxList{ii} = find(idx_mat(:,ii)==1);
end

All_networks = cat(3, cor_SZ_fisherZ_correct, cor_NC_fisherZ_correct);
l_all = size(All_networks, 3);
method = ["Our method", "Subsample", "NonparGT", "NetComp"];
time = zeros(size(method,2),1);
for m = 1:length(method)
    methodnow = method(m);
    switch methodnow
        case "Our method"
            load("sz_ourmethod.mat")
            d1 = p_all;
            time(m,1) = time_query;
        case "NonparGT"
            d1 = readtable("sz_R_dissimilarity_pvalue_ori.csv");
            d1 = table2array(d1);
            timecost = readtable("sz_R_dissimilarity_timecost.csv");
            time(m,1) = table2array(timecost);
        case "NetComp"
            load("sz_python_dissimilarity_netcomp.mat")
%             d1 = exp(-abs(netcomp)/3);
            d1 = netcomp;  
            time(m,1) = time_cost;
        case "Subsample"
            load("result_sz_subsample.mat")
            d1 = p_all_dist;
            time(m,1) = time_subsample;
    end


    % try SVD
    K1 = 5;
    K2 = 4;
    K = max(K1,K2);
    [u,s,v ] = svd(d1);
    uk = u(:,1:K) * sqrt(abs(s(1:K,1:K)));
    
    
    cluster_result1= kmeans(uk(1:l_SZ,:),K1);
    cluster_result2= kmeans(uk((l_SZ+1):(l_SZ+l_NC),:),K2);
    [~,yyy1] = sort(cluster_result1);
    [~,yyy2] = sort(cluster_result2);
    cluster_all = [cluster_result1;cluster_result2+K1];
    yyy2 = yyy2+l_SZ;
    yyy = [yyy1;yyy2];
    d1 = d1(yyy,yyy);
    
    fig1 = figure("visible","on");
    axis equal
    imagesc([d1(1:l_SZ,1:l_SZ),ones(l_SZ,1)*1,d1(1:l_SZ,(l_SZ+1):(l_NC+l_SZ));
        ones(1,(l_NC+l_SZ)+1)*1;
        d1((l_SZ+1):(l_NC+l_SZ),1:l_SZ),ones(l_NC,1)*1,d1((l_SZ+1):(l_NC+l_SZ),(l_SZ+1):(l_NC+l_SZ))])
    colorbar;
    if methodnow == "NetComp"
        title(["Dissimilarity Matrix",strcat(methodnow,", distance")],'interpreter','latex');
    else

        title(["Similarity Matrix",strcat(methodnow,", p-value")],'interpreter','latex');
    end
    % title('Similarity Matrix. P value');
    pbaspect([1 1 1])
    
    xt = get(gca, 'XTick');                                             % Original 'XTick' Values
    xtlbl = linspace(50, 200, numel(xt));                     % New 'XTickLabel' Vector
    set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   % Label Ticks
    set(gca, 'YTick',xt, 'YTickLabel',xtlbl)   % Label Ticks
    ax = gca;
    ax.TitleFontSizeMultiplier = 1.5;
    set(gca, 'FontSize', 18)
    pbaspect([1 1 1])
    set(gca,'units','centimeters')
    set(gcf,'units','centimeters')
    pos = get(gca,'Position');
    ti = get(gca,'TightInset');
%     set(gcf, 'PaperPositionMode', 'manual');
    set(gca, 'Position',[1.5 0.3 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)+1]);
%     set(gcf, 'Units', 'Inches', 'Position', [0 0 5.5 5.8], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 6])
    set(gcf, 'Units', 'Inches', 'Position', [0 0 5.5 5.3], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 6])
    saveas(fig1, strcat(method(m),"_heatmap_distance_pvalue_sz.png"))
end
SZ_cluster = cluster_result1;
NC_cluster = cluster_result2;
save("cluster_sz","SZ_cluster","NC_cluster")

