function [selectedIndex,currentFitness,result] = TPOSS_crossover(k,X,y,epsilon,delta,task)
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
        s1 = population(unidrnd(popSize),:);
        
        %uniform crossover, select one bit with prob 0.5 from two parents
        a=randsrc(1,n,[1,0; 0.5,0.5]);
%         b=allOnes-a;
        b=~a;
        offspring0=a.*s0+b.*s1;
        offspring1=s0+s1-offspring0;
        
        % targeted mutation  
        offspring0 = targeted_mutation(offspring0,k,1);
        offspring1 = targeted_mutation(offspring1,k,1);

        p = p+1;
        % targeted selection  
        [population,popSize,fitness,nothing] = env_selection(offspring0,population,fitness,popSize,X,y,m,k-epsilon,k+epsilon,delta,task); 
        if mod(p,k*n) == 0
         %print the result every kn iterations
            temp=fitness(:,2)<=k;
            j=max(fitness(temp,2));
            seq=find(fitness(:,2)==j);     
            %display(fitness(seq));
            result = [result,fitness(seq)];
        end
        p=p+1;
        [population,popSize,fitness,nothing] = env_selection(offspring1,population,fitness,popSize,X,y,m,k-epsilon,k+epsilon,delta,task);    
                
    end
    
    temp = fitness(:,2)<=k;
    j = max(fitness(temp,2));
    seq = find(fitness(:,2)==j);     
    [~,d] = max(fitness(seq,1));
    selectedIndex = population(seq(d),:);
    currentFitness = max(fitness(seq,:));
end