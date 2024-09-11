clear;
rng(1);
d1 = load("p_value_dis_mat.mat");
d2 = load("mean_conf_dis_mat.mat");
d1 = d1.d1;
d2 = d2.d2;
p= sort_nodes({d1,d2},{[2,1]});


fig1 = figure('Visible','on');
imagesc([p{2}]);
hold on;
vert = [1 1; 22 1; 22 22; 1 22]; 
fac = [1 2 3 4]; 
patch('Faces',fac,'Vertices',vert,'FaceColor','none','LineWidth',2,'Edgecolor','r','Linestyle','--');
hold on;
a = 39;
b = 39;
vert = 21+[1 1; 1+a 1; 1+a 1+b; 1 1+b]; 
fac = [1 2 3 4]; 
patch('Faces',fac,'Vertices',vert,'FaceColor','none','LineWidth',2,'Edgecolor','r','Linestyle','--');
a = 38;
b = 38;
vert = 91+[1 1; 1+a 1; 1+a 1+b; 1 1+b]; 
fac = [1 2 3 4]; 
patch('Faces',fac,'Vertices',vert,'FaceColor','none','LineWidth',2,'Edgecolor','r','Linestyle','--');
xt = get(gca, 'XTick');                                             
xtlbl = linspace(20, 120, numel(xt));                    
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XAxisLocation', 'top')  
set(gca, 'YTick',xt, 'YTickLabel',xtlbl)  
ax = gca;
ax.TitleFontSizeMultiplier = 1.5;
set(gca, 'FontSize', 18)
set(gca,'LooseInset',get(gca,'TightInset'));
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 5, 5], 'PaperUnits', 'Inches', 'PaperSize', [5, 5])
title(strcat("Similarity matrix"));
pbaspect([1 1 1])
saveas(fig1, "heatmap_distance_ego_CI_estimate.png")
