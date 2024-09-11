clear
% N = [10,20,40,80,160];
N = [20,40,80,160,320,640];
MotifNameall   = ["Triangle","Vshape"];
coverage = zeros(length(N),length(MotifNameall));
coverage2 = zeros(length(N),length(MotifNameall));

GraphonName1 =  'SmoothGraphon4';
GraphonName2 =  'SmoothGraphon2';
coveragemean = zeros(length(N),length(N));
coverage2mean = zeros(length(N),length(N));
coveragestd = zeros(length(N),length(N));
coverage2std = zeros(length(N),length(N));
for mf = 1:length(MotifNameall)
    for k = 1:length(N)
        for l = 1:length(N)
            m = N(k);
            n = N(l);
            MotifName = MotifNameall(mf);
            cover = readtable(strcat("./new-result/MC_t_cover_edge_",string(m),"_",string(n),"_",MotifName,"_",GraphonName1,"_",GraphonName2,"_mn.csv"));
            cover = table2array(cover);
            coveragemean(k,l) = nanmean(cover);
            coveragestd(k,l) = nanstd(cover,0);
            cover = readtable(strcat("./new-result/MC_t_cover_norm_",string(m),"_",string(n),"_",MotifName,"_",GraphonName1,"_",GraphonName2,"_mn.csv"));
            cover = table2array(cover);
            coverage2mean(k,l) = nanmean(cover);
            coverage2std(k,l) = nanstd(cover,0);
        end
    end
    fig = figure("visible","on");
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
    saveas(fig,strcat('heatmap_coverage_'+MotifName+'.png'))
end

