function [selectedIndex,currentFitness,result]=POSS(k,X,y,task)
    [n,m]=size(X);
    if task == "Modified_CN"
        n = length(X.A);
    elseif task == "Modified_FS"
        n = size(X.TrainIn,2);
    end
    population=zeros(1,n);
    popSize=1;
    fitness=zeros(1,2);
    T=round(2*n*8*8*exp(1));
    flipPro=1.0/n;
    unChangedPro=1.0-flipPro;
    p=0;
    result = [];
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
        offspring0=abs(s0-randsrc(1,n,[1,0; flipPro,unChangedPro]));
        p=p+1;
        
        [population,popSize,fitness] = evaluation_k(offspring0,population,fitness,popSize,X,y,m,0,2*k,task);     
             
    end
    temp=fitness(:,2)<=k;
    j=max(fitness(temp,2));
    seq=find(fitness(:,2)==j);     
    selectedIndex=population(seq,:);
    currentFitness=fitness(seq,:);
end