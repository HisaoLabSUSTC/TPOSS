clc,clear,close all
files = [
    "data_set_linear_triangular_M3_100000",...
    "data_set_convex_triangular_M3_100000",...
    "data_set_concave_triangular_M3_100000",...
    "data_set_linear_invertedtriangular_M3_100000",...
    "data_set_convex_invertedtriangular_M3_100000",...
    "data_set_concave_invertedtriangular_M3_100000",...
    "triazines","clean1","svmguide3","scene","usps","protein",...
    "sonar","Hill-Valley","musk","phishing","mediamill","CT-slices"
        ];
algs = ["TPOSS", "TPOSS_bm", "TPOSS_nds"];
dataset = [
    "linear","convex","concave","invert linear","invert convex","invert concave",...
    "triazines","clean1","svmguide3","scene","usps","protein",...
    "sonar","Hill-Valley","musk","phishing","mediamill","CT-slices"];

result = cell(length(files), length(algs));

for k = 1:length(files)
    for n = 1:length(algs)
        if algs(n) == "TPOSS"
            filename = "./result/Comparison/" + files(k) + "_" + algs(n);
        else
            filename = "./result/Ablation/" + files(k) + "_" + algs(n);
        end
        load(filename, "finalResult");
        result{k,n} = num2str(mean(finalResult(:,end)),'%.4f') + " \pm " + num2str(std(finalResult(:,end)),'%.4f');
    end
end

% create a table
resultTable = cell2table(result, 'VariableNames', cellstr(algs), 'RowNames', cellstr(dataset));

% write the table into an excel file
writetable(resultTable, 'result/ablation.xlsx', 'WriteRowNames', true);