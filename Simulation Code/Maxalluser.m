function [MAX,temp,user] = Maxalluser(Rank,Tasknum,Usernum)
%MAXALLUSER 此处显示有关此函数的摘要
%   此处显示详细说明
MAX=-1;
temp=1;
for j=1:Usernum
for i=1:Tasknum(1,j)
    if(MAX<Rank(1,i,j))
        MAX=Rank(1,i,j);
        user=j;
        temp=i;
    end
end
end
end

