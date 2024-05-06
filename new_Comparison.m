clc,clear,close all
rng('shuffle');%set random seed
warning('off');
addpath(genpath(pwd));
k = 8;% cardinality constraint
run = 25;
epsilon = 1;
delta = 5;
tasks = ["HSS","SR","FS"]; %"SR"
algs = ["TPOSS_uoffspring_u5","TPOSS_uoffspring_u10","TPOSS_crossover"];
% algs = ["TPOSS_crossover"];

for task = tasks
    if task == "HSS" %hypervolume subset selection
        files = [
            "data_set_concave_invertedtriangular_M3_100000",...
            "data_set_concave_triangular_M3_100000",...
            "data_set_convex_invertedtriangular_M3_100000",...
            "data_set_convex_triangular_M3_100000",...
            "data_set_linear_invertedtriangular_M3_100000",...
            "data_set_linear_triangular_M3_100000"];   
    elseif task == "SR" % sparse regression
        %  files = ["scene","protein"];
         files = ["triazines", "clean1", "svmguide3", "scene", "usps", "protein"];
    else % unsupervised feature selection
         files = ["sonar","Hill-Valley","musk","phishing","mediamill","CT-slices"];
    end
    
    for file=files   
        load(file+".mat");
        if task == "HSS"
            % hv subset selection
            X = data_set;
            X = X(1:200,:);
            y=0;
        elseif task == "SR"
            % sparse regression
            % normalization: make all the variables have expectation 0 and
            % variance 1
            A = bsxfun(@minus, X, mean(X, 1));
            B = bsxfun(@(x,y) x ./ y, A, std(A,1,1));
            X = B(:,isnan(B(1,:))==0);
            A = bsxfun(@minus, Y, mean(Y, 1));
            y = bsxfun(@(x,y) x ./ y, A, std(A,1,1));
            X = X';
        else
            % feature selection
            %eliminate the zero columns
            X(:,sum(abs(X),1)==0)=[];
            if size(X,1) > 1000
                X = X(1:1000,:);
            end
            
            A = bsxfun(@minus, X, mean(X, 1));
            B = bsxfun(@(x,y) x ./ y, A, std(A,1,1));
            X = B(:,isnan(B(1,:))==0);
            y = 0;
            
%             [m,n] = size(X);
%             if m > n
%                 [~,S,V]=svd(X, 'econ');
%                 %[~,S,V]=svdecon(data);
%                 sigma_vt = S*V';
%                 X = sigma_vt(1:n, :);    
%             end

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
                
                if alg == "TPOSS_uoffspring_u5"
                    % TPOSS_uoffspring_u5
                    tic;
                    [selectedIndex,fitness,result] = TPOSS_uoffspring(k,X,y,epsilon,delta,task,5);
                    toc;
                    display(find(selectedIndex==1));
                    display(fitness);
                    display(['TPOSS_uoffspring_u5 time: ',num2str(toc)]);
                    finalResult = [finalResult;result];
                elseif alg == "TPOSS_uoffspring_u10"
                    % TPOSS_uoffspring_u10
                    tic;
                    [selectedIndex,fitness,result] = TPOSS_uoffspring(k,X,y,epsilon,delta,task,10);
                    toc;
                    display(find(selectedIndex==1));
                    display(fitness);
                    display(['TPOSS_uoffspring_u10 time: ',num2str(toc)]);
                    finalResult = [finalResult;result];
                elseif alg == "TPOSS_crossover"
                    % TPOSS_crossover
                    tic;
                    [selectedIndex,fitness,result] = TPOSS_crossover(k,X,y,epsilon,delta,task);
                    toc;
                    display(find(selectedIndex==1));
                    display(fitness);
                    display(['TPOSS_crossover time: ',num2str(toc)]);
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
