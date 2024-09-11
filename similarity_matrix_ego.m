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




