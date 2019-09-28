function [usage] = CPUusage(Servernum,schedule,N,Timeslot,Timeslotlast)
%CPUUSAGE 此处显示有关此函数的摘要
%   此处显示详细说明
Totaltime=Timeslot-Timeslotlast;
temp=0;
for k=1:Servernum
    for t=1:N
        if schedule(1,t,k)~=-1
         temp=temp+schedule(2,t,k)-schedule(1,t,k);
        end
    end
end
        usage=temp/Servernum/Totaltime;
end

