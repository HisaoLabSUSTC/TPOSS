function [selectedIndex,currentFitness,result]=PORSS_onepoint(k,X,y,task)
    [n,m]=size(X);
    population=zeros(1,n);
    popSize=1;
    fitness=zeros(1,2);
    T=round(2*n*k*k*exp(1));
    flipPro=1.0/n;
    unChangedPro=1.0-flipPro;
    p=0;
    result = [];
    while p<T
       if mod(p,k*n) == 0
         %print the result every kn iterations
            temp=fitness(:,2)<=k;
            j=max(fitness(temp,2));
            seq=find(fitness(:,2)==j);     
            %display(fitness(seq));
            result = [result,fitness(seq)];
        end
        s0=population(unidrnd(popSize),:);
        s1=population(unidrnd(popSize),:);
        randIndex=randi(n,[1,1]);%generate a random integer [1,n]
        ss0=[s0(1:randIndex), s1(randIndex+1:end)];
        ss1=[s1(1:randIndex), s0(randIndex+1:end)];
        offspring0=abs(ss0-randsrc(1,n,[1,0; flipPro,unChangedPro]));
        offspring1=abs(ss1-randsrc(1,n,[1,0; flipPro,unChangedPro]));
        p=p+1;
        
        [population,popSize,fitness] = evaluation_k(offspring0,population,fitness,popSize,X,y,m,0,2*k,task);     

        if mod(p,k*n) == 0
         %print the result every kn iterations
            temp=fitness(:,2)<=k;
            j=max(fitness(temp,2));
            seq=find(fitness(:,2)==j);     
            %display(fitness(seq));
            result = [result,fitness(seq)];
        end
        p=p+1;
        [population,popSize,fitness] = evaluation_k(offspring1,population,fitness,popSize,X,y,m,0,2*k,task);     
        
    end
    temp=fitness(:,2)<=k;
    j=max(fitness(temp,2));
    seq=find(fitness(:,2)==j);     
    selectedIndex=population(seq,:);
    currentFitness=fitness(seq,:);
end