function [population,popSize,fitness,nothing] = env_selection(offspring,population,fitness,popSize,X,y,m,lb,ub,delta,task)
        offspringFit    = -inf(1,2);
        offspringFit(2) = sum(offspring);   
        if offspringFit(2)>=lb && offspringFit(2)<=ub  
            nothing = false;
            index = find(fitness(:,2)==offspringFit(2));
            if isempty(index)
                offspringFit(1)=calfitness(offspring,X,y,m,task); 
                population  = [population;offspring];
                fitness     = [fitness;offspringFit];          
                popSize     = popSize+1; 
            else
                subpopulation = population(index,:);
                if ismember(offspring,subpopulation,'rows')
                    return;
                else
                    offspringFit(1)=calfitness(offspring,X,y,m,task); 
                    if length(index)<delta
                        population  = [population;offspring];
                        fitness     = [fitness;offspringFit];          
                        popSize     = popSize+1;  
                    else
                        [minVal,which] = min(fitness(index,1));
                        if minVal<offspringFit(1)
                            population(index(which),:) = offspring;
                            fitness(index(which),1) = offspringFit(1);
                        end
                    end
                end               
                
            end
           
        else
           nothing = true; 
        end            
end