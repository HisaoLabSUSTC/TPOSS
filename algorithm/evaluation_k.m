function [population,popSize,fitness,nothing] = evaluation_k(offspring,population,fitness,popSize,X,y,m,lb,ub,task)
        offspringFit    = -inf(1,2);
        offspringFit(2) = sum(offspring);   
        if offspringFit(2)>lb && offspringFit(2)<ub  
            nothing = false;
            offspringFit(1)=calfitness(offspring,X,y,m,task);            
            %update the population
            if ~(sum((fitness(1:popSize,1)>offspringFit(1)).*(fitness(1:popSize,2)<=offspringFit(2)))+sum((fitness(1:popSize,1)>=offspringFit(1)).*(fitness(1:popSize,2)<offspringFit(2)))>0)
                deleteIndex = ((fitness(1:popSize,1)<=offspringFit(1)).*(fitness(1:popSize,2)>=offspringFit(2)))'; 
                ndelete     = find(deleteIndex==0);
                population  = [population(ndelete,:);offspring];
                fitness     = [fitness(ndelete,:);offspringFit];          
                popSize     = length(ndelete)+1;
            end
        else
           nothing = true; 
        end
            
end