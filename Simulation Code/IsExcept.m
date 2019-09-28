function [Bool] = IsExcept(j,Except,len)
%ISEXCEPT 此处显示有关此函数的摘要
%   此处显示详细说明
Bool=0;  
for i=1:len
      if j==Except(1,i)
          Bool=1;
          break;
      end
end
end



