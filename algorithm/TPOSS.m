function [selectedIndex,currentFitness,result] = TPOSS(k,X,y,epsilon,delta,task)
    [n,m] = size(X);
    % targeted initilization  
    [population,popSize,fitness] = initialization(k,n,X,y,m,task);    
    T = round(2*n*k*k*exp(1));
    p = 0;
    result = [];
    infeasible = 0;
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
        % targeted selection  
        [population,popSize,fitness,nothing] = env_selection(offspring0,population,fitness,popSize,X,y,m,k-epsilon,k+epsilon,delta,task);    
                
    end
    
    temp = fitness(:,2)<=k;
    j = max(fitness(temp,2));
    seq = find(fitness(:,2)==j);     
    [~,d] = max(fitness(seq,1));
    selectedIndex = population(seq(d),:);
    currentFitness = max(fitness(seq,:));
end