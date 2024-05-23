clc,clear,close all
addpath(genpath(pwd));
algs = ["SparseEA", "MOEAPSL", "PMMOEA", "POSS", "PORSS-O", "PORSS-U", "SPESS", "TPOSS"];
pros = ["Modified_Sparse_CN","Modified_Sparse_FS"];
tasks = ["Modified_CN","Modified_FS"];
titleStrings = ["SparseCN","SparseFS"];
num_Ds = [102,234,311,452,166,256,310];
num_Evals = [35490,81418,108209,157269,57758,89073,107861];
k = 30;

for d = 1:length(num_Ds)
    if d <= 4
        pro = pros(1);
        task = tasks(1);
        titleString = titleStrings(1);
        str = {'Movies','GD99','GD01','GD97'};
        dataNo = d;
    else
        pro = pros(2);
        task = tasks(2);
        titleString = titleStrings(2);
        str = {'MUSK1','Semeion_handwritten_digit','LSVT_voice_rehabilitation'};
        dataNo = d - 4;
    end
    res = zeros(1,length(algs));
    for a = 1:length(algs)
        alg = algs(a);
        if a <= 3
            load("./result/Sparse/Fitness_" + alg + "_" + pro + "_M2_D" + num2str(num_Ds(d)) + ".mat","Fitness")
            res(1,a) = mean(Fitness(2,:));
        elseif a == 7 && d > 4
            fileName = "./result/Comparison/" + task + "_" + str(dataNo) + "_" + "POSS" + ".mat";
            load(fileName, "finalResult")
            res(1,a) = mean(finalResult(:,end));
        else
            fileName = "./result/Comparison/" + task + "_" + str(dataNo) + "_" + alg + ".mat";
            load(fileName, "finalResult")
            res(1,a) = mean(finalResult(:,end));
        end
    end
    figure
    bar(res)
    title(titleString+"_"+str(dataNo),'Interpreter','none')
    xticks(1:length(algs));
    xticklabels(algs);

    ax = gca;

    for i = 1:length(res)
        x = i;
        y = res(i) + ax.YLim(2)*0.026; 
        
        text(x, y, num2str(res(i), '%0.4f'), 'HorizontalAlignment', 'center');
    end
   exportgraphics(gca,"result/figure/Sparse/"+titleString+"_"+str(dataNo)+".png", "Resolution",300);
end