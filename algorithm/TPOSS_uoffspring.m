function [selectedIndex,currentFitness,result] = TPOSS_uoffspring(k,X,y,epsilon,delta,task,u)
    [n,m] = size(X);
    % targeted initilization  
    [population,popSize,fitness] = initialization(k,n,X,y,m,task);    
    T = round(2*n*k*k*exp(1));
    p = 0;
    result = [];
    infeasible = 0;
    % number of offspring in each generation
    % u = 5;
    temp = fitness(:,2)<=k;
    j = max(fitness(temp,2));
    seq = find(fitness(:,2)==j);     
    result = [result,max(fitness(seq))];
    while p < T
       % if mod(p,k*n) == 0
       %      temp = fitness(:,2)<=k;
       %      j = max(fitness(temp,2));
       %      seq = find(fitness(:,2)==j);     
       %      result = [result,max(fitness(seq))];
       %  end
        s0 = population(unidrnd(popSize),:);
        % targeted mutation  
        offspring0 = [];
        for i=1:u
            off = targeted_mutation(s0,k,1);
            offspring0 = [offspring0;off];
        end
        
        % targeted selection  
        for i=1:u
            p=p+1;
            [population,popSize,fitness,nothing] = env_selection(offspring0(i,:),population,fitness,popSize,X,y,m,k-epsilon,k+epsilon,delta,task); 
            if mod(p,k*n) == 0
                %print the result every kn iterations
                temp=fitness(:,2)<=k;
                j=max(fitness(temp,2));
                seq=find(fitness(:,2)==j);     
                %display(fitness(seq));
%                 result = [result,fitness(seq)];
                result = [result,max(fitness(seq))];
            end
        end                
    end
    
    temp = fitness(:,2)<=k;
    j = max(fitness(temp,2));
    seq = find(fitness(:,2)==j);     
    [~,d] = max(fitness(seq,1));
    selectedIndex = population(seq(d),:);
    currentFitness = max(fitness(seq,:));
end