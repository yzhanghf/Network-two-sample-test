rng(2);
clear;
load('./data/TwoSampleNetwork/Final_data.mat');
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
load('pvalue_allnet.mat');
load('confi2_allnet.mat');
d1 = p_all;
d2 = exp(-abs(pesti));



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
d2 = d2(yyy,yyy);

fig1 = figure("visible","on");
axis equal
imagesc([d1(1:l_SZ,1:l_SZ),ones(l_SZ,1)*1,d1(1:l_SZ,(l_SZ+1):(l_NC+l_SZ));
    ones(1,(l_NC+l_SZ)+1)*1;
    d1((l_SZ+1):(l_NC+l_SZ),1:l_SZ),ones(l_NC,1)*1,d1((l_SZ+1):(l_NC+l_SZ),(l_SZ+1):(l_NC+l_SZ))])
hold on;
vert = [1 1; 16 1; 16 16; 1 16]; 
fac = [1 2 3 4]; 
patch('Faces',fac,'Vertices',vert,'FaceColor','none','LineWidth',1.5,'Edgecolor','r');
hold on;
a = 15;
b = 15;
vert = 16+[1 1; 1+a 1; 1+a 1+b; 1 1+b]; 
fac = [1 2 3 4]; 
patch('Faces',fac,'Vertices',vert,'FaceColor','none','LineWidth',1.5,'Edgecolor','r');
a = 46;
b = 46;
vert = 15+16+[1 1; 1+a 1; 1+a 1+b; 1 1+b]; 
fac = [1 2 3 4]; 
patch('Faces',fac,'Vertices',vert,'FaceColor','none','LineWidth',1.5,'Edgecolor','r');
a = 25;
b = 25;
vert = 45+16+16+[1 1; 1+a 1; 1+a 1+b; 1 1+b]; 
fac = [1 2 3 4]; 
patch('Faces',fac,'Vertices',vert,'FaceColor','none','LineWidth',1.5,'Edgecolor','r');
a = 15;
b = 15;
vert = 45+16+16+[1 1; 1+a 1; 1+a 1+b; 1 1+b]; 
fac = [1 2 3 4]; 
patch('Faces',fac,'Vertices',vert,'FaceColor','none','LineWidth',1.5,'Edgecolor','m');
a = 10;
b = 10;
vert = 15+45+16+16+[1 1; 1+a 1; 1+a 1+b; 1 1+b]; 
fac = [1 2 3 4]; 
patch('Faces',fac,'Vertices',vert,'FaceColor','none','LineWidth',1.5,'Edgecolor','m');
a = 25;
b = 25;
vert = 2+10+15+45+16+16+[1 1; 1+a 1; 1+a 1+b; 1 1+b]; 
fac = [1 2 3 4]; 
patch('Faces',fac,'Vertices',vert,'FaceColor','none','LineWidth',1.5,'Edgecolor','g');
a = 22;
b = 22;
vert = 26+1+10+15+45+16+16+[1 1; 1+a 1; 1+a 1+b; 1 1+b]; 
fac = [1 2 3 4]; 
patch('Faces',fac,'Vertices',vert,'FaceColor','none','LineWidth',1.5,'Edgecolor','g');
a = 24;
b = 24;
vert = 22+26+1+10+15+45+16+16+[1 1; 1+a 1; 1+a 1+b; 1 1+b]; 
fac = [1 2 3 4]; 
patch('Faces',fac,'Vertices',vert,'FaceColor','none','LineWidth',1.5,'Edgecolor','g');
a = 52;
b = 52;
vert = 24+22+26+1+10+15+45+16+16+[1 1; 1+a 1; 1+a 1+b; 1 1+b]; 
fac = [1 2 3 4]; 
patch('Faces',fac,'Vertices',vert,'FaceColor','none','LineWidth',1.5,'Edgecolor','g');
hold on;
FontSize = 18;
text(18,8,'SZ1', 'Color','Red', 'FontSize', FontSize,'FontWeight','bold');
text(16+16+2,16+6,'SZ2', 'Color','Red', 'FontSize', FontSize,'FontWeight','bold');
text(12+16+23,16+16+16,'SZ3', 'Color','Red', 'FontSize', FontSize,'FontWeight','bold');
text(23+16+15,50+16+16+6,'SZ4', 'Color','Red', 'FontSize', FontSize,'FontWeight','bold');
text(20+10+15+45+16+16+10,1+10+15+45+16+16+13,'NC1', 'Color','green', 'FontSize', FontSize,'FontWeight','bold');
text(43+1+10+15+45+16+16+10,26+1+10+15+45+16+16+13,'NC2', 'Color','green', 'FontSize', FontSize,'FontWeight','bold');
text(43+22+1+10+15+45+16+16+10,26+22+1+10+15+45+16+16+13,'NC3', 'Color','green', 'FontSize', FontSize,'FontWeight','bold');
text(41+24+22+1+10+15+45+16+16+10,34+24+22+1+10+15+45+16+16+13,'NC4', 'Color','green', 'FontSize', FontSize,'FontWeight','bold');
text(15+45+16+5,15+45+10,'a', 'Color','m', 'FontSize', FontSize,'FontWeight','bold');
text(15+45+16+16+2+12,15+45+16+16+6,'b', 'Color','m', 'FontSize', FontSize,'FontWeight','bold');


pbaspect([1 1 1])
xt = get(gca, 'XTick');                                             
xtlbl = linspace(50, 200, numel(xt));                    
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')   
set(gca, 'YTick',xt, 'YTickLabel',xtlbl)  
ax = gca;
ax.TitleFontSizeMultiplier = 1.5;
set(gca, 'FontSize', 18)
set(gca,'LooseInset',get(gca,'TightInset'));
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 5.5, 5], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5])

saveas(fig1, "heatmap_distance_pvalue_sz.png")

