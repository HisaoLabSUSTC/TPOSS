function [selectedIndex,currentFitness,result]=TPOSS(k,X,y,epsilon,delta,task)
    [n,m]=size(X);
    if task == "Modified_CN"
        n = length(X.A);
    elseif task == "Modified_FS"
        n = size(X.TrainIn,2);
    end
    [population,popSize,fitness] = initialization(k,n,X,y,m,task);    
    T=round(2*n*8*8*exp(1));
    p=0;
    result = [];
    infeasible = 0;
    %two parameters of TPOSS:
    %epsilon = 1;
    %delta = 5;
    while p<T
       if mod(p,8*n) == 0
         %print the result every kn iterations
            temp=fitness(:,2)<=k;
            j=max(fitness(temp,2));
            seq=find(fitness(:,2)==j);     
            %display(fitness(seq));
            result = [result,max(fitness(seq))];
        end
        s0=population(unidrnd(popSize),:);
        % mutation  
       % temp = 0;
       % while(temp<=k-delta || temp>=k+delta)
        offspring0 = targeted_mutation(s0,k,1);
       %     temp = sum(offspring0); 
       % end
        p=p+1;
        
        [population,popSize,fitness,nothing] = env_selection(offspring0,population,fitness,popSize,X,y,m,k-epsilon,k+epsilon,delta,task);    
%         if nothing == true
%             infeasible = infeasible+1;
%         end
                
    end
    
    temp=fitness(:,2)<=k;
    j=max(fitness(temp,2));
    seq=find(fitness(:,2)==j);     
    [~,d] = max(fitness(seq,1));
    selectedIndex=population(seq(d),:);
    currentFitness=max(fitness(seq,:));
end