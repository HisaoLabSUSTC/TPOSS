function [selectedIndex,currentFitness,result] = TPOSS_bm(k,X,y,task)
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
    flipPro = 1.0/n;
    unChangedPro = 1.0-flipPro;
    while p < T
       if mod(p,k*n) == 0
            temp = fitness(:,2)<=k;
            j = max(fitness(temp,2));
            seq = find(fitness(:,2)==j);     
            result = [result,max(fitness(seq))];
        end
        s0 = population(unidrnd(popSize),:);
        % remove targeted mutation
        offspring0 = abs(s0-randsrc(1,n,[1,0; flipPro,unChangedPro]));
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