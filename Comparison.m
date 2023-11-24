clc,clear,close all
rng('shuffle'); % set random seed
warning('off');
addpath(genpath(pwd));

k = 8; % cardinality constraint
run = 25;
epsilon = 1;
delta = 5;
tasks = ["HSS", "SR", "FS"];
algs = ["POSS", "PORSS-O", "PORSS-U", "SPESS", "TPOSS"];

for task = tasks
    if task == "HSS" % hypervolume subset selection
        files = [
            "data_set_concave_invertedtriangular_M3_100000",...
            "data_set_concave_triangular_M3_100000",...
            "data_set_convex_invertedtriangular_M3_100000",...
            "data_set_convex_triangular_M3_100000",...
            "data_set_linear_invertedtriangular_M3_100000",...
            "data_set_linear_triangular_M3_100000"];   
    elseif task == "SR" % sparse regression
         files = ["triazines", "clean1", "svmguide3", "scene", "usps", "protein"];
    else % unsupervised feature selection
         files = ["sonar", "Hill-valley", "musk", "phishing", "mediamill", "CT-slices"];
    end
    
    for file = files   
        load(file+".mat");
        if task == "HSS"
            % data preprocessing in hv subset selection
            X = data_set;
            X = X(1:200,:);
            y = 0;
        elseif task == "SR"
            % data preprocessing in sparse regression
            A = bsxfun(@minus, X, mean(X, 1));
            B = bsxfun(@(x,y) x ./ y, A, std(A,1,1));
            X = B(:,isnan(B(1,:))==0);
            A = bsxfun(@minus, Y, mean(Y, 1));
            y = bsxfun(@(x,y) x ./ y, A, std(A,1,1));
            X = X';
        else
            % data preprocessing in feature selection
            X(:,sum(abs(X),1)==0) = [];
            if size(X,1) > 1000
                X = X(1:1000,:);
            end
            A = bsxfun(@minus, X, mean(X, 1));
            B = bsxfun(@(x,y) x ./ y, A, std(A,1,1));
            X = B(:,isnan(B(1,:))==0);
            y = 0;
            tempSum = trace(X'*X);
            [u,d,v] = svds(X,k);
            loss = norm(X-u*d*v', 'fro')^2;
            X = X';
        end
        
        for alg = algs
            finalResult = [];
            fileName = "./result/Comparison/" + file + "_" + alg;

            parfor i = 1:run
                display(['run: ',num2str(i)]);
                
                if alg == "POSS"
                    % POSS
                    tic;
                    [selectedIndex,fitness,result] = POSS(k,X,y,task);
                    toc;
                    display(find(selectedIndex==1));
                    display(fitness);
                    display(['POSS time: ',num2str(toc)]);
                    finalResult = [finalResult;result];
                elseif alg == "PORSS-O"
                    % POIM_singlepoint
                    tic;
                    [selectedIndex,fitness,result] = PORSS_onepoint(k,X,y,task);
                    toc;
                    display(find(selectedIndex==1));
                    display(fitness);
                    display(['PORSS_onepoint time: ',num2str(toc)]);
                    finalResult = [finalResult;result];
                elseif alg == "PORSS-U"
                    % POIM_uniform
                    tic;
                    [selectedIndex,fitness,result] = PORSS_uniform(k,X,y,task);
                    toc;
                    display(find(selectedIndex==1));
                    display(fitness);
                    display(['PORSS_uniform time: ',num2str(toc)]);
                    finalResult = [finalResult;result];
                elseif alg == "SPESS"
                    % SPESS
                    tic;
                    [selectedIndex,fitness,result] = SPESS(k,X,y,task);
                    toc;
                    display(find(selectedIndex==1));
                    display(fitness);
                    display(['SPESS time: ',num2str(toc)]);
                    finalResult = [finalResult;result];
                elseif alg == "TPOSS"
                    % TPOSS
                    tic;
                    [selectedIndex,fitness,result] = TPOSS(k,X,y,epsilon,delta,task);
                    toc;
                    display(find(selectedIndex==1));
                    display(fitness);
                    display(['TPOSS time: ',num2str(toc)]);
                    finalResult = [finalResult;result];
                end
            end

            if task == "FS"
                finalResult = (tempSum-finalResult)/loss;
            end
            save(fileName, "finalResult")
        end
        
    end
end
