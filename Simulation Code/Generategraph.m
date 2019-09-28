function [Graph] = Generategraph(Num,Nummax,c,d)
%GENERATEGRAPH 此处显示有关此函数的摘要
%   c是图的稀疏因子 c越小 图越稀疏
%    d是图的并发性因子 d越小 图的并发性越小 生成不同并发性的图时c传入
Graph=zeros(Nummax,Nummax)-2;
    Graph(1:Num,1:Num)=rand(Num,Num);
   if c==-1
    temp=zeros(1,Num);
    len=0;
    for k=2:Num
        if Graph(1,k)>d
            Graph(1,k)=0;
            Graph(k,1)=0;
        else
            Graph(1,k)=1;
            Graph(k,1)=-1;
            temp(1,len+1)=k;
            len=len+1;
        end
    end
    for k=1:len
        for p=k:len
            Graph(temp(1,k),temp(1,p))=0;
            Graph(temp(1,p),temp(1,k))=0;
        end
    end
   end
    for i=1:Num
        Graph(i,i)=0;
        for j=1:i-1
            if Graph(i,j)~=0 && abs(Graph(i,j))~=1
            if Graph(i,j)<c
                Graph(i,j)=-1;
                Graph(j,i)=1;
            else 
                Graph(i,j)=0;
                Graph(j,i)=0;
            end
            end
        end
    end
    for i=2:(Num-1)
           if Isin(-1,Graph(i,:),Num)==0
               t=1+floor((i-1)*rand());
               Graph(i,t)=-1;
               Graph(t,i)=1;
           end
           if Isin(1,Graph(i,:),Num)==0
               t=i+1+floor(rand()*(Num-i));
               Graph(i,t)=1;
               Graph(t,i)=-1;
           end
    end
               
            
end

