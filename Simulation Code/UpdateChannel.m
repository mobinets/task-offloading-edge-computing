function [Channel] = UpdateChannel(Channel,User,server,Servernum,Local)
%UPDATECOM 此处显示有关此函数的摘要
%   此处显示详细说明
     for k=1:Servernum
         if Channel(User,k)==1
             Channel(User,k)=0; %k代表User原先占用的核 现在要释放
            % [Transferrate]=Recomputecom(k,Channel,Transferrate1,Transferrate2,Transferrate3,Transferrate1ini,Transferrate2ini,Transferrate3ini,Num,Q);
             break;
         end
     end
        if server~=Local
       Channel(User,server)=1;
       %[Transferrate]=Recomputecom(server,Channel,Transferrate,Transferrateini,Usernum,Servernum);
        end

