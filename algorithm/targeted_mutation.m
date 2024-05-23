function offspring = targeted_mutation(offspring,k,num)
    offspring = logical(offspring);
    n = length(offspring);
    b = sum(offspring);
    a = n-b;

        rate0 = repmat((abs(k-b)+k-b+num)/(2*a),1,n);
        rate1 = repmat((abs(k-b)-k+b+num)/(2*b),1,n);

    
        rate  = zeros(1,n);
        rate(offspring)     = rate1(offspring);
        rate(~offspring)    = rate0(~offspring);
        exchange            = rand(1,n)<rate;
        offspring(exchange) = ~offspring(exchange);
end

