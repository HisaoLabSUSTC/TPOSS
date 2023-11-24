function [population,popSize,fitness] = initialization(k,n,X,y,m,task)
    population = zeros(1,n);
    popSize = 1;
    population(randperm(n,k)) = 1;
    fitness = zeros(1,2);
    fitness(2) = k;    
    fitness(1) = calfitness(population,X,y,m,task); 
end