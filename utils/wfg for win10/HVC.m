function Score = HVC(Population,RefPoint,index)
    data = Population;
    data1 = data;
    s = data1(index,:);
    data1(index,:)=[];
    data1 = max(s,data1);       
    Score = prod(RefPoint-s)-stk_dominatedhv(data1,RefPoint); 
end