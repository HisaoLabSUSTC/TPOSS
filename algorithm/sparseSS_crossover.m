function [offspring0,offspring1] = sparseSS_crossover(offspring0,offspring1,k)
     indtemp = offspring0;
     diff    = offspring0~=offspring1;
     x1      = sum(offspring0(diff));
     xx      = length(diff);
     rate10  = repmat(xx/2/2/x1,1,xx); 
     rate01  = repmat(xx/2/2/(xx-x1),1,xx);
     rate    = zeros(1,xx);
     rate(offspring0(diff))     = rate10(offspring0(diff));
     rate(~offspring0(diff))    = rate01(~offspring0(diff));
     exchange                   = rand(1,xx)<rate;
     offspring0(diff(exchange)) = offspring1(diff(exchange));
     offspring1(diff(exchange)) = indtemp(diff(exchange));
end

