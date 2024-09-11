clear
N = [1,2,5,10,20,40];
m = 80;
MotifNameall   = ["Triangle","Vshape"];
coverage = zeros(length(N),length(MotifNameall));
coverage2 = zeros(length(N),length(MotifNameall));

GraphonName1 =  'SmoothGraphon2';
GraphonName2 =  'SmoothGraphon2';


coveragemean = zeros(length(N),length(N));
coverage2mean = zeros(length(N),length(N));
coveragestd = zeros(length(N),length(N));
coverage2std = zeros(length(N),length(N));
for mf = 1:length(MotifNameall)
	MotifName = MotifNameall(mf);
    for k = 1:length(N)
        for l = 1:length(N)
            Na = N(k);
            Nb = N(l);
            cover = readtable(strcat("./new-result-2-multiple-pooling/cover_edge_",   MotifName,"_",GraphonName1,"_",GraphonName2,    "NA_",string(Na), "NB_",string(Nb), "_mn_",string(m),".csv"));
            cover = table2array(cover);
            coveragemean(k,l) = nanmean(cover);
            coveragestd(k,l) = nanstd(cover,0);
            cover = readtable(strcat("./new-result-2-multiple-pooling/cover_norm_",   MotifName,"_",GraphonName1,"_",GraphonName2,    "NA_",string(Na), "NB_",string(Nb), "_mn_",string(m),".csv"));
            cover = table2array(cover);
            coverage2mean(k,l) = nanmean(cover);
            coverage2std(k,l) = nanstd(cover,0);
        end
    end
    fig = figure("visible","off");
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
    saveas(fig,strcat('plots/heatmap_coverage_multiple_pooling_'+MotifName+'_'+GraphonName1+'_vs_'+GraphonName2+'.png'))
end

