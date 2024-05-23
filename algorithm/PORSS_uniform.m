function [selectedIndex,currentFitness,result]=PORSS_uniform(k,X,y,task)
    [n,m]=size(X);
    if task == "Modified_CN"
        n = length(X.A);
    elseif task == "Modified_FS"
        n = size(X.TrainIn,2);
    end
    population=zeros(1,n);
    popSize=1;
    fitness=zeros(1,2);
    allOnes=ones(1,n);
    T=round(n*8*8*2*exp(1));
    flipPro=1.0/n;
    unChangedPro=1.0-flipPro;
    p=0;
    result = [];
    infeasible = 0;
    while p<T
        if mod(p,8*n) == 0
         %print the result every kn iterations
            temp=fitness(:,2)<=k;
            j=max(fitness(temp,2));
            seq=find(fitness(:,2)==j);     
            %display(fitness(seq));
            result = [result,fitness(seq)];
        end
        s0=population(unidrnd(popSize),:);
        s1=population(unidrnd(popSize),:);
        %uniform crossover, select one bit with prob 0.5 from two parents
        a=randsrc(1,n,[1,0; 0.5,0.5]);
        b=allOnes-a;
        offspring0=a.*s0+b.*s1;
        offspring1=s0+s1-offspring0;
        %mutation
        offspring0=abs(offspring0-randsrc(1,n,[1,0; flipPro,unChangedPro]));
        offspring1=abs(offspring1-randsrc(1,n,[1,0; flipPro,unChangedPro]));
        p=p+1;
        
        [population,popSize,fitness,nothing] = evaluation_k(offspring0,population,fitness,popSize,X,y,m,0,2*k,task);     
        if nothing == true
           infeasible = infeasible+1; 
        end
        if mod(p,8*n) == 0
         %print the result every kn iterations
            temp=fitness(:,2)<=k;
            j=max(fitness(temp,2));
            seq=find(fitness(:,2)==j);     
            %display(fitness(seq));
            result = [result,fitness(seq)];
        end
        p=p+1;
        [population,popSize,fitness] = evaluation_k(offspring1,population,fitness,popSize,X,y,m,0,2*k,task);  
        if nothing == true
           infeasible = infeasible+1; 
        end
        
    end
    temp=fitness(:,2)<=k;
    j=max(fitness(temp,2));
    seq=find(fitness(:,2)==j);     
    selectedIndex=population(seq,:);
    currentFitness=fitness(seq,:);
end