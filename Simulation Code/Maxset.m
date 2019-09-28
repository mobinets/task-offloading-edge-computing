function [Rankfirstset,Actualnum] = Maxset(Rank,Tasknum,Usernum)
%MAXSET 此处显示有关此函数的摘要
%   此处显示详细说明
Rankfirstset=zeros(1,Usernum);
Actualnum=0;
for i=1:Usernum
    [max,temp]=Max(Rank(:,:,i),Tasknum(1,i));
    if max>=0
    Rankfirstset(1,i)=temp;
    Actualnum=Actualnum+1;
    else
        Rankfirstset(1,i)=-1;
    end
end
end

