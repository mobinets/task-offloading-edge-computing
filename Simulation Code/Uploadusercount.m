function [Count] = Uploadusercount(Usernum,Servernum,Channel)
%UPLOADUSERCOUNT 此处显示有关此函数的摘要
%   此处显示详细说明
Count=0;
for i=1:Usernum
    for j=1:Servernum
        if Channel(i,j)==1
            Count=Count+1;
        end
    end
end
end

