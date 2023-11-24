function offspring = sparseSS_mutation(offspring)
    n = length(offspring);
    rate1 = repmat(1/2/sum(offspring),1,n); 
    rate0 = repmat(1/2/(n-sum(offspring)),1,n);
    rate  = zeros(1,n);
    rate(offspring)     = rate1(offspring);
    rate(~offspring)    = rate0(~offspring);
    exchange            = rand(1,n)<rate;
    offspring(exchange) = ~offspring(exchange);
end

