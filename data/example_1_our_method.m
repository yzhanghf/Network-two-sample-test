addpath('../subroutines')

%%% PRE-PROCESSING DATA

Files = dir("./gplus");
isdir = [Files.isdir];
indexf = isdir ==0;
Filesf = Files(indexf);
for i = 1:length(Filesf)
    oldFilename = Filesf(i).name;
    parts = strsplit(oldFilename,'.');
    newFilename = strcat(parts(1),'_',parts(2),'.txt');
    movefile( strcat("./gplus/",oldFilename), strcat("./gplus/",newFilename{end}));
end
Files = dir("./gplus");
isdir = [Files.isdir];
indexf = isdir ==0;
Filesf = Files(indexf);
Nameallf = contains({Filesf.name},"edge");
Filespart = Filesf(Nameallf);
mkdir(strcat("./data_pre"));
allsize = zeros(length(Filespart),1);
deletename = cell(length(Filespart),1);
d = 0;
for i = 1:length(Filespart)
    if Filespart(i).bytes ~= 0
        data = readtable(strcat("./gplus/",Filespart(i).name));
        if size(data,1) >=30
            allsize(i,1) = size(data,1);
            parts = strsplit(string(Filespart(i).name),'_');
            s = string(table2array(data(:,1)));
            t = string(table2array(data(:,2)));
            G = digraph(s,t);
            At = adjacency(G);
            A = full(At);
            Atemp = A+A';
            Atemp(Atemp>0)= 1;
            A = Atemp;
            filenamesave = strcat("./data_pre/",parts(1));
            save(filenamesave,'A');
        else
            deletename{i,1}=Filespart(i).name;
        end
    end
end
save("deletefile","deletename")

clear
MotifName   = {'Triangle','Vshape'};
mkdir(strcat("./hash_edge"));
Files = dir("./data_pre");
isdir = [Files.isdir];
indexf = isdir ==0;
Filesf = Files(indexf);
for j = 1:length(Filesf)
    parts = strsplit(string(Filesf(j).name),'.');
    filenamesave = strcat("./hash_edge/",parts(1));
    A = load(strcat("./data_pre/",parts(1)));
    A = cell2mat(struct2cell(A));
    Our_method_NetHashing(A, MotifName,filenamesave);
end

%%% END OF PRE-PROCESSING DATA



%%% COMPUTING SIMILARITY MATRIX

Files = dir("./hash_edge");
isdir = [Files.isdir];
indexf = isdir ==0;
Filesf = Files(indexf);
MotifName   = {'Triangle','Vshape'};
p_all = zeros(length(Filesf),length(Filesf));
pesti = zeros(length(Filesf),length(Filesf));
conf_level = 0.05;
for i = 1:length(Filesf)
    for j = 1:length(Filesf)
        [p_value, conf_int] = Our_method_FastTest(strcat(Filesf(i).folder,'/',Filesf(i).name), strcat(Filesf(j).folder,'/',Filesf(j).name), conf_level);
        p_all(i,j) =  min(p_value);
        pesti(i,j) =  max(abs(mean(conf_int,2)));
    end
end
similarity = exp(-abs(pesti));
d1 = p_all;
d2 = similarity;
save('p_value_dis_mat','d1')
save('mean_conf_dis_mat','d2')

%%% END OF COMPUTING SIMILARITY MATRIX

%%% REPRODUCING THE FIGURE IN PAPER

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











