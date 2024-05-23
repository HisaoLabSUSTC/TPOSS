clc,clear,close all
rng('shuffle');%set random seed
warning('off');
addpath(genpath(pwd));
k = 30;% cardinality constraint
run = 25;
epsilon = 1;
delta = 5;
tasks = ["Modified_CN","Modified_FS"];
algs = ["SPESS"];

for task = tasks(2)
    if task == "Modified_CN"
        str = {'Movies','GD99','GD01','GD97'};
        CallStack = dbstack('-completenames');
        for dataNo = 1:length(str)
            load(fullfile(fileparts(CallStack(1).file),'data/Dataset_CN.mat'),'Dataset');
            A = Dataset.(str{dataNo});
            G = graph(A&~logical(eye(length(A))));
            X = struct('A',A,'G',G);
            for alg = algs
                fileName = "./result/Comparison/" + task + "_" + str(dataNo) + "_" + alg;
                finalResult = zeros(run,44);
                for i = 1:run
                    finalResult(i,:) = 1./TestDiffAlg(alg,k,X,0,task);
                end
                save(fileName, "finalResult")
            end
        end
    else 
        str = {'MUSK1','Semeion_handwritten_digit','LSVT_voice_rehabilitation'};
        CallStack = dbstack('-completenames');
        for dataNo = 1:length(str)
            load(fullfile(fileparts(CallStack(1).file),'data/Dataset_FS.mat'),'Dataset');
            Data = Dataset.(str{dataNo});
            Fmin = min(Data(:,1:end-1),[],1);
            Fmax = max(Data(:,1:end-1),[],1);
            Data(:,1:end-1) = (Data(:,1:end-1)-repmat(Fmin,size(Data,1),1))./repmat(Fmax-Fmin,size(Data,1),1);
            Category    = unique(Data(:,end));
            TrainIn     = Data(1:ceil(end*0.8),1:end-1);
            TrainOut    = Data(1:ceil(end*0.8),end);
            ValidIn     = Data(ceil(end*0.8)+1:end,1:end-1);
            ValidOut    = Data(ceil(end*0.8)+1:end,end);
            X = struct('Category',Category,'TrainIn',TrainIn,'TrainOut',TrainOut,'ValidIn',ValidIn,'ValidOut',ValidOut);
            for alg = algs
                fileName = "./result/Comparison/" + task + "_" + str(dataNo) + "_" + alg;
                finalResult = zeros(run,44);
                for i = 1:run
                    finalResult(i,:) = 1./TestDiffAlg(alg,k,X,0,task);
                end
                save(fileName, "finalResult")
            end
        end
    end
end

function result = TestDiffAlg(alg,k,X,y,task)
    if alg == "POSS"
        % POSS
        tic;
        [selectedIndex,fitness,result]=POSS(k,X,y,task);
        toc;
        display(find(selectedIndex==1));
        display(fitness);
        display(['POSS time: ',num2str(toc)]);
    elseif alg == "PORSS-O"
        % POIM_singlepoint
        tic;
        [selectedIndex,fitness,result]=PORSS_onepoint(k,X,y,task);
        toc;
        display(find(selectedIndex==1));
        display(fitness);
        display(['PORSS_onepoint time: ',num2str(toc)]);
    elseif alg == "PORSS-U"
        % POIM_uniform
        tic;
        [selectedIndex,fitness,result]=PORSS_uniform(k,X,y,task);
        toc;
        display(find(selectedIndex==1));
        display(fitness);
        display(['PORSS_uniform time: ',num2str(toc)]);
    elseif alg == "SPESS"
        % SPESS
        tic;
        [selectedIndex,fitness,result]=SPESS(k,X,y,task);
        toc;
        display(find(selectedIndex==1));
        display(fitness);
        display(['SPESS time: ',num2str(toc)]);
    elseif alg == "TPOSS"
        % TPOSS
        epsilon = 1;
        delta = 5;
        tic;
        [selectedIndex,fitness,result] = TPOSS(k,X,y,epsilon,delta,task);
        toc;
        display(find(selectedIndex==1));
        display(fitness);
        display(['TPOSS time: ',num2str(toc)]);
    end
end