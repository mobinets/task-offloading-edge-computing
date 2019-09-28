function [Graph] = Graphgenerateparalel(num,nummax,const)
%GRAPHGENERATEPARALEL 此处显示有关此函数的摘要
%   const是并行性因子 1-(num-2) 1指完全串行 num-2指除第一个和最后一个任务外全部并行
const=const-1;
if const<0 || (num>3)&&const>num-3
    1
    const+1
end
Graph=zeros(nummax,nummax)-2;
Graph(1:num,1:num)=0;
if const==0
    for k=1:(num-1)
        Graph(k,k+1)=1;
        Graph(k+1,k)=-1;
    end
else
parameter=num-const-2;
for k=1:parameter
    Graph(k,k)=0;
    Graph(k,k+1)=1;
    Graph(k+1,k)=-1;
end
for t=(parameter+1):(num-1)
    Graph(parameter,t)=1;
    Graph(t,parameter)=-1;
    Graph(t,num)=1;
    Graph(num,t)=-1;
end
end
end

