function [Comstartuptemp] = Comstartupart(Comstartup,Servernum,User)
%COMSTARTUPDETACH 此处显示有关此函数的摘要
%   此处显示详细说明
 Comstartuptemp=zeros(1,Servernum+1);
 Comstartuptemp(1,1:Servernum)=Comstartup(1,1:Servernum);
 Comstartuptemp(1,Servernum+1)=Comstartup(1,Servernum+User);
end

