clc, clear, close all
addpath(genpath(pwd));
algs = ["POSS", "PORSS-O", "PORSS-U", "SPESS","SparseEA","MOEAPSL","PMMOEA","TPOSS"];
pros = [
    "data_set_linear_triangular_M3_100000",...
    "data_set_convex_triangular_M3_100000",...
    "data_set_concave_triangular_M3_100000",...
    "data_set_linear_invertedtriangular_M3_100000",...
    "data_set_convex_invertedtriangular_M3_100000",...
    "data_set_concave_invertedtriangular_M3_100000",...
    "triazines","clean1","svmguide3","scene","usps","protein",...
    "sonar","Hill-Valley","musk","phishing","mediamill","CT-slices"
        ];
problems = [
    "MOHSS_Linear","MOHSS_Convex","MOHSS_Concave",...
    "MOHSS_Inverted_Linear", "MOHSS_Inverted_Convex","MOHSS_Inverted_Concave",... 
    "MOSR_triazines","MOSR_clean1", "MOSR_svmguide3",...
    "MOSR_scene", "MOSR_usps","MOSR_protein", ...
    "MOFS_sonar","MOFS_HillValley","MOFS_musk",...
    "MOFS_phishing","MOFS_mediamill","MOFS_CTslices"];

mean_res = zeros(length(pros), length(algs));
std_res = zeros(length(pros), length(algs));
win = zeros(length(pros),length(algs)-1,4);

for k = 1:length(pros)
    pro = pros(k);
    result = zeros(length(algs)-1,25);
    filename = "./result/Comparison/" + pro + "_" + algs(end);
    load("./result/Comparison/" + pro + "_" + algs(end), "finalResult")
    TPOSS_res = finalResult(:,end);
    for i = 1:length(algs)-1
        alg = algs(i);
        if i<=4
            load("./result/Comparison/"+pro+"_"+alg, "finalResult")
            result(i,:) = finalResult(:,end)';
        else
            load("./result/Comparison/"+alg+"_"+problems(k)+".mat","afterProcessing")
            result(i,:) = afterProcessing(end,:);
        end
        win(k,i,:) = Statest(result(i,:),TPOSS_res);
    end
end

for i = 1:3
    approx = squeeze(sum(win(6*(i-1)+1:6*i,:,1),1))
    smaller_better = squeeze(sum(win(6*(i-1)+1:6*i,:,2),1))
    larger_better = squeeze(sum(win(6*(i-1)+1:6*i,:,3),1))
    equal = squeeze(sum(win(6*(i-1)+1:6*i,:,4),1))
end

function win = Statest(di,dj)
    di = di(di~=0);
    dj = dj(dj~=0);
    win  = zeros(1,4);
    mi = mean(di);
    mj = mean(dj);
    [~,h] = ranksum(di,dj);
    win(1,1) = (h == 0);
    win(1,2) = (h & mi>mj);
    win(1,3) = (h & mi<mj);
    win(1,4) = (h & mi==mj);
end