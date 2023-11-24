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
algs = ["POSS", "PORSS-O", "PORSS-U", "SPESS", "TPOSS"];
dataset = [
    "linear","convex","concave","invert linear","invert convex","invert concave",...
    "triazines","clean1","svmguide3","scene","usps","protein",...
    "sonar","Hill-Valley","musk","phishing","mediamill","CT-slices"];

result = cell(length(files)+1, length(algs));
win = zeros(length(files), length(algs)-1);

for k = 1:length(files)
    data = zeros(length(algs),25);
    for n = 1:length(algs)
        filename = "./result/Comparison/" + files(k) + "_" + algs(n);
        load(filename, "finalResult");
        result{k,n} = num2str(mean(finalResult(:,end)),'%.4f') + " \pm " + num2str(std(finalResult(:,end)),'%.4f');
        data(n,:) = finalResult(:,end);
    end

    h = zeros(1,4);
    m = mean(data,2);
    % rank sum test
    for i = 1:length(algs)-1
        [~,h(i)] = ranksum(data(end,:),data(i,:));
    end
    if k <= 12 
        win(k,:) = (h & (m(end)>m(1:4))');
    else % smaller value is better in sparse regression
        win(k,:) = (h & (m(end)<m(1:4))');
    end
    win(k,:) = win(k,:) + 0.5*(h==0);
    
end

% adding the sum(win, 1) to the result array
for n = 1:length(algs)-1
    result{length(files)+1, n} = num2str(sum(win(:, n)), '%.1f');
end
result{end, end} = '-';

% create a table
resultTable = cell2table(result, 'VariableNames', cellstr(algs), 'RowNames', cellstr([dataset, "Total Wins"]));

% write the table into an excel file
writetable(resultTable, 'result/comparison.xlsx', 'WriteRowNames', true);