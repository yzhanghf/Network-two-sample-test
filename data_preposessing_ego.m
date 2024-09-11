Files = dir("./data/gplus");
isdir = [Files.isdir];
indexf = isdir ==0;
Filesf = Files(indexf);
for i = 1:length(Filesf)
    oldFilename = Filesf(i).name;
    parts = strsplit(oldFilename,'.');
    newFilename = strcat(parts(1),'_',parts(2),'.txt');
    movefile( strcat("./data/gplus/",oldFilename), strcat("./data/gplus/",newFilename{end}));
end
Files = dir("./data/gplus");
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
        data = readtable(strcat("./data/gplus/",Filespart(i).name));
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


