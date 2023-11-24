function fitness = calfitness(offspring,X,y,m,task)
    if task == "HSS"
            % HV subset selection
            pos = offspring==1;
            data = X(pos,:);
            if ispc % windows
                fitness = stk_dominatedhv(data, 1.1*ones(1,size(data,2)));
            elseif isunix % linux
                fitness = HVExact(data, 1.1*ones(1,size(data,2)));
            end
    elseif task == "SR"
            % sparse regression
            X = X';
            pos = offspring==1;
            coef = lscov(X(:,pos),y);
            err = y-X(:,pos)*coef;
            fitness = 1-err'*err/m;           
    else
            % feature selection
            X = X';
            pos = offspring==1;
            fitness = norm(X(:,pos)*pinv(X(:,pos))*X, 'fro')^2;
    end
end