function [selectedIndex,currentFitness,result]=SPESS(k,X,y,task)
    [n,m]=size(X);
    population=zeros(1,n);
    popSize=1;
    fitness=zeros(1,2);
    T=round(2*n*k*k*exp(1));
    p=0;
    result = [];
    while p < T
        offspring  = abs(population(randi([1,popSize],1,1),:)-randsrc(1,n,[1,0; 1/n,1-1/n]));% = xor    
        % print the result every kn iterations
        if mod(p,k*n) == 0         
            temp = fitness(:,2)<=k;
            j    = max(fitness(temp,2));
            seq  = find(fitness(:,2)==j);
            %display(fitness(seq));
            result = [result,fitness(seq)];
        end
        p = p+1;
        [population,popSize,fitness] = evaluation_k(offspring,population,fitness,popSize,X,y,m,0,k+1,task);     
        %  f(2) first hit to k time   
        if max(fitness(:,2))==k && popSize==k+1
            pp = p;
            p  = T;
            population = population(2:end,:);
            fitness    = fitness(2:end,:);
            popSize    = popSize-1;
        end
    end     
    while pp<T 
        s1 = logical(population(unidrnd(popSize),:));
        s2 = logical(population(unidrnd(popSize),:));
        [offspring1,offspring2] = sparseSS_crossover(s1,s2,k);
        offspring1 = sparseSS_mutation(offspring1);
        offspring2 = sparseSS_mutation(offspring2);
        % print the result every kn iterations
        if mod(pp,k*n) == 0         
            temp = fitness(:,2)<=k;
            j    = max(fitness(temp,2));
            seq  = find(fitness(:,2)==j);
            %display(fitness(seq));
            result = [result,fitness(seq)];
        end    
        pp = pp+1;
        [population,popSize,fitness] = evaluation_k(offspring1,population,fitness,popSize,X,y,m,0,k+1,task); 
        % print the result every kn iterations
        if mod(pp,k*n) == 0         
            temp = fitness(:,2)<=k;
            j    = max(fitness(temp,2));
            seq  = find(fitness(:,2)==j);
            %display(fitness(seq));
            result = [result,fitness(seq)];
        end    
        pp = pp+1;
        [population,popSize,fitness] = evaluation_k(offspring2,population,fitness,popSize,X,y,m,0,k+1,task);
    end
    j    = max(fitness(:,2));
    seq  = find(fitness(:,2)==j);     
    selectedIndex  = population(seq,:);
    currentFitness = fitness(seq,:);
end