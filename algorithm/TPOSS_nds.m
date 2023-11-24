function [selectedIndex,currentFitness,result] = TPOSS_nds(k,X,y,task)
    [n,m] = size(X);
    % targeted initialization
    [population,popSize,fitness] = initialization(k,n,X,y,m,task);    
    T = round(2*n*k*k*exp(1));
    p = 0;
    result = [];
    infeasible = 0;
    % two parameters of TPOSS:
    epsilon = 1;
    delta = 5;
    while p < T
       if mod(p,k*n) == 0
            temp = fitness(:,2)<=k;
            j = max(fitness(temp,2));
            seq = find(fitness(:,2)==j);     
            result = [result,max(fitness(seq))];
        end
        s0 = population(unidrnd(popSize),:);
        % targeted mutation  
        offspring0 = targeted_mutation(s0,k,1);
        p = p+1;
        % remove targted selection
        [population,popSize,fitness] = evaluation_k(offspring0,population,fitness,popSize,X,y,m,k-epsilon-1,k+epsilon+1,task);     
    end
    
    temp = fitness(:,2)<=k;
    j = max(fitness(temp,2));
    seq = find(fitness(:,2)==j);     
    [~,d] = max(fitness(seq,1));
    selectedIndex = population(seq(d),:);
    currentFitness = max(fitness(seq,:));
end