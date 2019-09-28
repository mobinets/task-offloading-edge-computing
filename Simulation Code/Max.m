function [MAX,temp] = Max(Rank,N)
%MAX 此处显示有关此函数的摘要
%   此处显示详细说明
MAX=-2;
temp=1;
for i=1:N
    if(MAX<Rank(1,i))
        MAX=Rank(1,i);
        temp=i;
    end
end
end

