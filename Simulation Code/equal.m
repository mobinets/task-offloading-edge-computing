function [flag] = equal(Channellast,Channel,Usernum,Servernum)
%EQUAL 此处显示有关此函数的摘要
%   此处显示详细说明
flag=1;
for k=1:Usernum
    for p=1:Servernum
        if Channellast(k,p)~=Channel(k,p)
            flag=0;
            break;
        end
    end
end
end

