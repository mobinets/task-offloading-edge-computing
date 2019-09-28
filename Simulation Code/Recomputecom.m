function [Transferrate] = Recomputecom(k,Channel,Transferrate,Transferrateini,Usernum,Servernum)
%RECOMPUTECOM 此处显示有关此函数的摘要
%   此处显示详细说明
  Total=0;   
  
for j=1:Usernum
       if Channel(j,k)==1
           Total=Total+1;
       end
end
if Total==0
    div=1;
else
    div=Total;
end
   for u=1:Usernum
   for i=1:Servernum+1
   Transferrate(k,i,u)=Transferrateini(k,i,u)/div;
   Transferrate(i,k,u)=Transferrate(k,i,u);
   end
   end
end

