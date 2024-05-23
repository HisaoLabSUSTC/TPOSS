function fitness = calfitness(varargin)
    offspring = varargin{1};
    X = varargin{2};
    y = varargin{3};
    m = varargin{4};
    task = varargin{5};
    if task == "HSS"
            % HV subset selection
            pos=offspring==1;
            data=X(pos,:);
            if ispc
                fitness = stk_dominatedhv(data, 1.1*ones(1,size(data,2)));
            elseif isunix
                fitness = HVExact(data, 1.1*ones(1,size(data,2)));
            end
    elseif task == "SR"
            % sparse regression
            X = X';
            pos=offspring==1;
            coef=lscov(X(:,pos),y);
            err=y-X(:,pos)*coef;
            fitness=1-err'*err/m;           
    elseif task == "FS"
            %feature selection
            X = X';
            pos=offspring==1;
            fitness = norm(X(:,pos)*pinv(X(:,pos))*X, 'fro')^2;
    elseif task == "Modified_FS"
            TrainIn = X.TrainIn;    % Input of training set
            TrainOut = X.TrainOut;   % Output of training set
            ValidIn = X.ValidIn;    % Input of validation set
            ValidOut = X.ValidOut;   % Output of validation set
            Category = X.Category;
            pos = offspring == 1;
            [~,Rank] = sort(pdist2(ValidIn(:,pos),TrainIn(:,pos)),2);
            [~,Out]  = max(hist(TrainOut(Rank(:,1:3))',Category),[],1);
            Out      = Category(Out);
            fitness = 1/mean(Out~=ValidOut);
    elseif task == "Modified_CN"
            A = X.A;
            pos = offspring == 1;
            fitness =  1/(PairwiseConnectivity(A(~pos,~pos))/PairwiseConnectivity(A));
    end
end

function f = PairwiseConnectivity(A)
    f = 0;
    remain = true(1,length(A));
    while any(remain)
        c = false(1,length(A));
        c(find(remain,1)) = true;
        while true
            c1 = any(A(c,:),1) & remain;
            if all(c==c1)
                break;
            else
                c = c1;
            end
        end
        remain = remain & ~c;
        f = f + sum(c)*(sum(c)-1)/2;
    end
end